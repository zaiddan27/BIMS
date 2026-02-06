/**
 * Google OAuth Callback Handler for BIMS
 * Handles user data after Google OAuth redirect
 * Creates user records for new OAuth users
 * Manages role assignment and profile completion
 */

/**
 * Main handler for Google OAuth callback
 * Call this on page load for pages that receive OAuth redirects
 */
async function handleGoogleAuthCallback() {
  console.log('🔐 Checking for Google OAuth session...');

  try {
    // Get the current session from Supabase
    const { data: { session }, error: sessionError } = await supabaseClient.auth.getSession();

    if (sessionError) throw sessionError;

    // No session found - normal page load
    if (!session) {
      console.log('ℹ️ No active session - normal page load');
      return false;
    }

    const user = session.user;
    console.log('✅ Session found for user:', user.email);

    // Check if user exists in User_Tbl
    const { data: existingUser, error: checkError } = await supabaseClient
      .from('User_Tbl')
      .select('userID, firstName, lastName, birthday, contactNumber, address, accountStatus')
      .eq('userID', user.id)
      .single();

    if (checkError && checkError.code !== 'PGRST116') {
      throw checkError;
    }

    // If user exists and has complete profile, redirect to dashboard
    if (existingUser) {
      console.log('✅ Existing user found');

      // Check account status first
      if (existingUser.accountStatus !== 'ACTIVE') {
        console.log('⚠️ Account not active:', existingUser.accountStatus);
        if (typeof showToast === 'function') {
          showToast(`Account status: ${existingUser.accountStatus}. Please contact administrator.`, 'warning');
        }
        await supabaseClient.auth.signOut();
        setTimeout(() => {
          window.location.href = 'login.html';
        }, 3000);
        return true;
      }

      // Check if profile is incomplete (placeholder values from OAuth)
      const profileIncomplete =
        existingUser.birthday === '2000-01-01' ||
        !existingUser.contactNumber ||
        !existingUser.address;

      if (profileIncomplete) {
        console.log('⚠️ Profile incomplete - redirecting to complete-profile.html');
        if (typeof showToast === 'function') {
          showToast('Please complete your profile information.', 'info');
        }
        sessionStorage.setItem('profile_incomplete', 'true');
        setTimeout(() => {
          // Check if already on complete-profile page (works for both local and GitHub Pages)
          if (!window.location.pathname.endsWith('/complete-profile.html')) {
            window.location.href = 'complete-profile.html';
          }
        }, 1500);
        return true;
      }

      // Profile is complete - redirect to dashboard
      if (existingUser.accountStatus === 'ACTIVE') {
        console.log('✅ Profile complete - redirecting to dashboard');
        if (typeof showToast === 'function') {
          showToast(`Welcome back! Redirecting to your dashboard...`, 'success');
        }
        setTimeout(async () => {
          await redirectToDashboard();
        }, 1000);
      }

      return true;
    }

    // New OAuth user - user doesn't exist in User_Tbl yet
    // This handles the case where the trigger didn't run or failed
    console.log('📝 New Google OAuth user - creating user record...');

    // Extract name from Google profile
    const fullName = user.user_metadata.full_name || user.user_metadata.name || '';
    const nameParts = fullName.split(' ');
    const firstName = nameParts[0] || '';
    const lastName = nameParts.slice(1).join(' ') || '';
    const avatarUrl = user.user_metadata.avatar_url || user.user_metadata.picture || null;

    // Create user record
    const { error: insertError } = await supabaseClient
      .from('User_Tbl')
      .insert({
        userID: user.id,
        email: user.email,
        firstName: firstName,
        lastName: lastName,
        middleName: null,
        role: 'YOUTH_VOLUNTEER', // Default role for OAuth users
        birthday: '2000-01-01', // Placeholder - will be updated in profile completion
        contactNumber: '', // Empty - will be updated in profile completion
        address: '', // Empty - will be updated in profile completion
        imagePathURL: avatarUrl,
        termsConditions: true, // Auto-accept for OAuth users
        accountStatus: 'ACTIVE' // Auto-activate OAuth users (Google already verified email)
      });

    if (insertError) {
      console.error('❌ Error creating user record:', insertError);
      throw insertError;
    }

    console.log('✅ User record created successfully');

    // Show welcome message and redirect to profile completion
    if (typeof showToast === 'function') {
      showToast('Welcome! Please complete your profile information.', 'info');
    }

    // Redirect to profile completion after short delay
    setTimeout(() => {
      window.location.href = 'complete-profile.html';
    }, 1500);

    return true;

  } catch (error) {
    console.error('❌ Google OAuth callback error:', error);
    if (typeof showToast === 'function') {
      showToast('Authentication error. Please try again.', 'error');
    }
    return false;
  }
}

/**
 * Redirect user to appropriate dashboard based on role
 */
async function redirectToDashboard() {
  try {
    const { data: { session } } = await supabaseClient.auth.getSession();

    if (!session) {
      console.log('❌ No session - redirecting to login');
      window.location.href = 'login.html';
      return;
    }

    // Get user role from database
    const { data: user, error } = await supabaseClient
      .from('User_Tbl')
      .select('role, accountStatus')
      .eq('userID', session.user.id)
      .single();

    if (error || !user) {
      console.error('❌ Error fetching user role:', error);
      window.location.href = 'login.html';
      return;
    }

    // Check if account is active
    if (user.accountStatus !== 'ACTIVE') {
      if (typeof showToast === 'function') {
        showToast('Your account is not active. Please contact support.', 'error');
      }
      await supabaseClient.auth.signOut();
      setTimeout(() => {
        window.location.href = 'login.html';
      }, 2000);
      return;
    }

    // Role-based redirect
    console.log('🔀 Redirecting to dashboard for role:', user.role);

    switch (user.role) {
      case 'CAPTAIN':
        window.location.href = 'captain-dashboard.html';
        break;
      case 'SK_OFFICIAL':
        window.location.href = 'sk-dashboard.html';
        break;
      case 'YOUTH_VOLUNTEER':
        window.location.href = 'youth-dashboard.html';
        break;
      case 'SUPERADMIN':
        window.location.href = 'superadmin-dashboard.html';
        break;
      default:
        console.log('⚠️ Unknown role - redirecting to home');
        window.location.href = 'index.html';
    }

  } catch (error) {
    console.error('❌ Error redirecting to dashboard:', error);
    window.location.href = 'index.html';
  }
}

/**
 * Toast notification helper
 * Uses existing toast implementation if available, otherwise creates basic one
 */
function showToast(message, type = 'info') {
  // Check if toast element already exists
  const existingToast = document.querySelector('.toast');
  if (existingToast) {
    existingToast.remove();
  }

  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  toast.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    min-width: 300px;
    background: white;
    padding: 16px 20px;
    border-radius: 12px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
    display: flex;
    align-items: center;
    gap: 12px;
    transform: translateX(400px);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 9999;
    border-left: 4px solid ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#3b82f6'};
  `;

  let icon = '';
  if (type === 'success') {
    icon = '<svg class="w-6 h-6 text-green-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width:24px;height:24px;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>';
  } else if (type === 'error') {
    icon = '<svg class="w-6 h-6 text-red-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width:24px;height:24px;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>';
  } else {
    icon = '<svg class="w-6 h-6 text-blue-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width:24px;height:24px;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>';
  }

  toast.innerHTML = `
    ${icon}
    <div class="flex-1">
      <p class="text-sm font-medium text-gray-800" style="margin:0;font-size:14px;color:#1f2937;">${message}</p>
    </div>
  `;

  document.body.appendChild(toast);
  setTimeout(() => {
    toast.style.transform = 'translateX(0)';
  }, 10);

  setTimeout(() => {
    toast.style.transform = 'translateX(400px)';
    setTimeout(() => toast.remove(), 300);
  }, 4000);
}
