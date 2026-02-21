/**
 * Session Management for BIMS
 *
 * Handles:
 * - Session persistence
 * - Role-based access control
 * - Auto-refresh tokens
 * - Auth state change listeners
 * - Page protection
 * - Automatic redirects
 *
 * User Roles (from CLAUDE.md):
 * - SUPERADMIN: System Administrator (Full Access)
 * - CAPTAIN: Barangay Captain (Approval)
 * - SK_OFFICIAL: SK Officials (Administrator)
 * - YOUTH_VOLUNTEER: Youth Volunteers (User)
 */

const SessionManager = {
    /**
     * Initialize session manager
     * Call this on every protected page
     *
     * @param {string[]} allowedRoles - Array of roles allowed on this page
     * @returns {Promise<{success: boolean, user?: Object, error?: string}>}
     */
    async init(allowedRoles = []) {
        try {
            // Listen for auth state changes
            this.setupAuthListener();

            // Check if user is authenticated
            const sessionResult = await AuthService.getSession();

            if (!sessionResult.success || !sessionResult.session) {
                // Not authenticated - redirect to login
                this.redirectToLogin();
                return { success: false, error: 'Not authenticated' };
            }

            // Get user details
            const userResult = await AuthService.getCurrentUser();

            if (!userResult.success || !userResult.user) {
                this.redirectToLogin();
                return { success: false, error: 'User not found' };
            }

            const user = userResult.user;

            // Get user role and status from user_tbl (DATABASE, not metadata)
            const { data: userData, error: userError } = await supabaseClient
                .from('User_Tbl')
                .select('role, accountStatus, firstName, lastName, middleName, contactNumber, address, gender, birthday, imagePathURL')
                .eq('userID', user.id)
                .single();

            if (userError || !userData) {
                this.redirectToLogin('User profile not found. Please contact administrator.');
                return { success: false, error: 'User data not found' };
            }

            const userRole = userData.role;
            const accountStatus = userData.accountStatus;

            // Check if user role is allowed on this page
            if (allowedRoles.length > 0 && !allowedRoles.includes(userRole)) {
                this.redirectByRole(userRole);
                return { success: false, error: 'Access denied' };
            }

            // Check account status
            if (accountStatus === 'INACTIVE') {
                await AuthService.logout();
                this.redirectToLogin('Your account has been deactivated. Please contact administrator.');
                return { success: false, error: 'Account inactive' };
            }

            if (accountStatus === 'PENDING') {
                await AuthService.logout();
                this.redirectToLogin('Your account is pending approval.');
                return { success: false, error: 'Account pending' };
            }

            // Check if profile is incomplete (missing essential fields)
            // This applies to both email/password and Google OAuth users
            const isOnCompleteProfilePage = window.location.pathname.endsWith('/complete-profile.html') ||
                                            window.location.pathname.endsWith('complete-profile.html');

            if (!isOnCompleteProfilePage) {
                const profileIncomplete =
                    !userData.contactNumber ||
                    !userData.address ||
                    !userData.gender ||
                    !userData.birthday ||
                    userData.birthday === '2000-01-01';

                if (profileIncomplete) {
                    sessionStorage.setItem('profile_incomplete', 'true');
                    window.location.href = 'complete-profile.html';
                    return { success: false, error: 'Profile incomplete' };
                }
            }

            // Store user info in localStorage for quick access
            localStorage.setItem('userRole', userRole);
            localStorage.setItem('userName', `${userData.firstName} ${userData.middleName || ''} ${userData.lastName}`.trim().replace(/\s+/g, ' '));
            localStorage.setItem('userEmail', user.email);
            localStorage.setItem('userID', user.id);

            return {
                success: true,
                user: user,
                userData: userData,
                role: userRole,
                status: accountStatus
            };

        } catch (error) {
            console.error('Session init error:', error.message);
            return { success: false, error: error.message };
        }
    },

    /**
     * Setup auth state change listener
     * Handles automatic session refresh and logout
     */
    setupAuthListener() {
        supabaseClient.auth.onAuthStateChange((event, session) => {
            if (event === 'SIGNED_OUT') {
                // Clear all session data from local storage
                localStorage.removeItem('userRole');
                localStorage.removeItem('userName');
                localStorage.removeItem('userEmail');
                localStorage.removeItem('userID');

                // Redirect to login if not already there
                if (!window.location.pathname.includes('login.html') &&
                    !window.location.pathname.includes('index.html') &&
                    !window.location.pathname.includes('signup.html')) {
                    this.redirectToLogin('Your session has expired. Please login again.');
                }
            }
        });
    },

    /**
     * Require authentication on current page
     * Use this at the top of protected pages
     *
     * @param {string[]} allowedRoles - Roles allowed on this page
     * @returns {Promise<Object>} - User info if authenticated
     */
    async requireAuth(allowedRoles = []) {
        const result = await this.init(allowedRoles);

        if (!result.success) {
            // Init already handles redirects
            throw new Error('Authentication required');
        }

        return result;
    },

    /**
     * Redirect to login page
     *
     * @param {string} message - Optional message to display
     */
    redirectToLogin(message = '') {
        const loginUrl = new URL('/login.html', window.location.origin);

        if (message) {
            loginUrl.searchParams.set('message', message);
        }

        // Store current page for redirect after login
        const currentPath = window.location.pathname;
        if (!currentPath.includes('login.html') && !currentPath.includes('signup.html')) {
            loginUrl.searchParams.set('redirect', currentPath);
        }

        window.location.href = loginUrl.toString();
    },

    /**
     * Redirect user based on their role
     *
     * @param {string} role - User role
     */
    redirectByRole(role) {
        const roleRedirects = {
            'SUPERADMIN': '/superadmin-dashboard.html',
            'CAPTAIN': '/captain-dashboard.html',
            'SK_OFFICIAL': '/sk-dashboard.html',
            'YOUTH_VOLUNTEER': '/youth-dashboard.html'
        };

        const redirectPath = roleRedirects[role] || '/index.html';
        window.location.href = redirectPath;
    },

    /**
     * Get role dashboard URL
     * Helper function for redirecting to correct dashboard
     *
     * @param {string} role - User role
     * @returns {string} - Dashboard URL
     */
    getRoleDashboard(role) {
        const roleRedirects = {
            'SUPERADMIN': 'superadmin-dashboard.html',
            'CAPTAIN': 'captain-dashboard.html',
            'SK_OFFICIAL': 'sk-dashboard.html',
            'YOUTH_VOLUNTEER': 'youth-dashboard.html'
        };

        return roleRedirects[role] || 'index.html';
    },

    /**
     * Get current session directly from Supabase
     * Use this for quick session checks
     *
     * @returns {Promise<Object|null>} - Session object or null
     */
    async getSession() {
        const { data: { session }, error } = await supabaseClient.auth.getSession();

        if (error) {
            console.error('Session error:', error.message);
            return null;
        }

        return session;
    },

    /**
     * Logout user and redirect to login
     */
    async logout() {
        try {
            await supabaseClient.auth.signOut();
            localStorage.clear();
            window.location.href = 'login.html';
        } catch (error) {
            console.error('Session error:', error.message);
            // Force redirect even if logout fails
            localStorage.clear();
            window.location.href = 'login.html';
        }
    },

    /**
     * Get user role from current session
     *
     * @returns {string|null} - User role or null if not authenticated
     */
    getUserRole() {
        return localStorage.getItem('userRole');
    },

    /**
     * Get user name from current session
     *
     * @returns {string|null} - User name or null if not authenticated
     */
    getUserName() {
        return localStorage.getItem('userName');
    },

    /**
     * Get user email from current session
     *
     * @returns {string|null} - User email or null if not authenticated
     */
    getUserEmail() {
        return localStorage.getItem('userEmail');
    },

    /**
     * Check if current user has specific role
     *
     * @param {string|string[]} roles - Role(s) to check
     * @returns {boolean}
     */
    hasRole(roles) {
        const userRole = this.getUserRole();

        if (!userRole) {
            return false;
        }

        if (Array.isArray(roles)) {
            return roles.includes(userRole);
        }

        return userRole === roles;
    },

    /**
     * Update user profile in UI
     * Call this to populate header/sidebar with user info
     *
     * @param {string} nameElementId - ID of element to show user name
     * @param {string} roleElementId - ID of element to show user role
     * @param {string} emailElementId - ID of element to show user email (optional)
     */
    updateUserProfile(nameElementId, roleElementId, emailElementId = null) {
        const name = this.getUserName();
        const role = this.getUserRole();
        const email = this.getUserEmail();

        const nameElement = document.getElementById(nameElementId);
        const roleElement = document.getElementById(roleElementId);
        const emailElement = emailElementId ? document.getElementById(emailElementId) : null;

        if (nameElement && name) {
            nameElement.textContent = name;
        }

        if (roleElement && role) {
            // Format role for display
            const roleDisplay = {
                'SUPERADMIN': 'System Administrator',
                'CAPTAIN': 'Barangay Captain',
                'SK_OFFICIAL': 'SK Official',
                'YOUTH_VOLUNTEER': 'Youth Volunteer'
            };

            roleElement.textContent = roleDisplay[role] || role;
        }

        if (emailElement && email) {
            emailElement.textContent = email;
        }
    }
};

// Export for use in other modules
if (typeof window !== 'undefined') {
    window.SessionManager = SessionManager;
}
