# Authentication Setup Guide for BIMS

Complete authentication system using Supabase Auth with Email/Password + OTP verification.

---

## 🎯 Features Implemented

✅ **Sign Up** (Youth Volunteers only)
- Email/Password registration
- OTP email verification (6-digit code, 10-min expiry)
- User profile data collection
- Terms & conditions acceptance
- Automatic role assignment (YOUTH_VOLUNTEER)
- Account status tracking (PENDING, ACTIVE, INACTIVE)

✅ **Login**
- Email/Password authentication
- OTP verification for unconfirmed emails
- Failed attempt tracking (5 attempts max, 15-min lockout)
- Automatic session management
- Role-based redirects

✅ **Session Management**
- Auto-refresh tokens
- Persistent sessions (localStorage)
- Role-based access control
- Page protection
- Automatic redirects for unauthorized access

✅ **Password Reset**
- OTP-based password recovery
- Email verification before reset

---

## 📁 Files Created

| File | Purpose |
|------|---------|
| `js/auth/auth.js` | Core authentication functions (sign up, login, OTP, password reset) |
| `js/auth/session.js` | Session management and role-based access control |
| `test-auth.html` | Testing page for all authentication features |
| `AUTH-SETUP.md` | This documentation |

---

## 🔐 Authentication Settings (Supabase)

Current configuration in Supabase dashboard:

| Setting | Value |
|---------|-------|
| Email Provider | ✅ Enabled |
| Secure Email Change | ✅ Enabled |
| Minimum Password Length | 8 characters |
| Email OTP Expiration | 600 seconds (10 minutes) |
| Email OTP Length | 6 digits |

---

## 🚀 Quick Start - Testing Authentication

### Step 1: Open Test Page

Open `test-auth.html` in your browser:
```
C:\Users\Lenovo\OneDrive\Pictures\Documents\BIMS\test-auth.html
```

### Step 2: Test Sign Up

1. Go to **"Sign Up"** tab
2. Fill in all fields:
   - First Name, Last Name, Middle Name
   - Email (use a real email you have access to)
   - Password (min 8 characters)
   - Birthday
   - Contact Number
   - Full Address
   - ✓ Accept terms
3. Click **"Sign Up"**
4. Check your email for 6-digit OTP code

### Step 3: Verify OTP

1. Go to **"Verify OTP"** tab
2. Enter your email
3. Enter the 6-digit code from email
4. Click **"Verify OTP"**
5. You should see: "✅ Email verified successfully!"

### Step 4: Test Login

1. Go to **"Login"** tab
2. Enter email and password
3. Click **"Login"**
4. If successful, you'll be auto-redirected to **"Session Info"** tab

### Step 5: Check Session

1. In **"Session Info"** tab, you'll see:
   - ✅ Authenticated
   - Email, Role, Name
   - Account Status
   - Session expiration time

---

## 📖 How to Use in Your Pages

### Protecting a Page (Require Login)

Add these scripts to any page that requires authentication:

```html
<!-- In <head> or before </body> -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="js/config/env.js"></script>
<script src="js/config/supabase.js"></script>
<script src="js/auth/auth.js"></script>
<script src="js/auth/session.js"></script>

<script>
    // Require authentication on page load
    // Only allow specific roles (optional)
    window.addEventListener('DOMContentLoaded', async () => {
        try {
            // For SK Officials only
            await SessionManager.requireAuth(['SK_OFFICIAL']);

            // Or for multiple roles
            // await SessionManager.requireAuth(['SK_OFFICIAL', 'CAPTAIN']);

            // Or for any authenticated user
            // await SessionManager.requireAuth();

            console.log('✅ User is authorized to view this page');

        } catch (error) {
            console.log('❌ User not authorized, redirecting...');
            // SessionManager already handles the redirect
        }
    });
</script>
```

### Example: SK Dashboard (sk-dashboard.html)

```html
<!DOCTYPE html>
<html>
<head>
    <!-- Your existing head content -->
</head>
<body>
    <!-- Your existing content -->

    <!-- Add before closing </body> -->
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <script src="js/config/env.js"></script>
    <script src="js/config/supabase.js"></script>
    <script src="js/auth/auth.js"></script>
    <script src="js/auth/session.js"></script>

    <script>
        // Protect this page - SK Officials only
        window.addEventListener('DOMContentLoaded', async () => {
            await SessionManager.requireAuth(['SK_OFFICIAL']);

            // Update UI with user info
            SessionManager.updateUserProfile('userName', 'userRole');
        });
    </script>
</body>
</html>
```

---

## 🔒 Role-Based Access Control

### Available Roles

| Role | Access Level | Dashboard |
|------|--------------|-----------|
| `CAPTAIN` | Approval | `captain-dashboard.html` |
| `SK_OFFICIAL` | Administrator | `sk-dashboard.html` |
| `YOUTH_VOLUNTEER` | User | `youth-dashboard.html` |

### How Roles Work

1. **Sign Up**: Always creates `YOUTH_VOLUNTEER` role
2. **SK Officials & Captain**: Must be manually assigned in database
3. **Automatic Redirects**: Users redirected to their role's dashboard

### Checking User Role in Code

```javascript
// Get current user role
const role = SessionManager.getUserRole();
console.log('User role:', role);

// Check if user has specific role
if (SessionManager.hasRole('SK_OFFICIAL')) {
    console.log('User is an SK Official');
}

// Check if user has any of multiple roles
if (SessionManager.hasRole(['SK_OFFICIAL', 'CAPTAIN'])) {
    console.log('User is an admin');
}
```

---

## 🛡️ Security Features

### 1. Login Attempt Tracking
- Tracks failed login attempts in localStorage
- After 5 failed attempts: 15-minute lockout
- Automatic cleanup of old attempts
- Clear attempts on successful login

### 2. Session Security
- Automatic token refresh
- Secure session storage (localStorage)
- Auth state change listeners
- Automatic logout on session expiry

### 3. Password Security
- Minimum 8 characters (enforced by Supabase)
- Hashed & salted by Supabase (bcrypt)
- Never stored in plain text

### 4. OTP Security
- 6-digit random code
- 10-minute expiration
- One-time use only
- Secure email delivery

---

## 📧 Email Templates

Supabase automatically sends emails for:

1. **Email Confirmation** (Sign Up)
   - Subject: "Confirm your email"
   - Contains 6-digit OTP code
   - Expires in 10 minutes

2. **Password Reset**
   - Subject: "Reset your password"
   - Contains reset link + OTP
   - Expires in 10 minutes

### Customizing Email Templates (Optional)

1. Go to: **Authentication** → **Email Templates** in Supabase
2. Edit templates with custom HTML/CSS
3. Use variables: `{{ .Token }}`, `{{ .SiteURL }}`, etc.

---

## 🔄 Integration Checklist

### For Login Page (login.html)

- [x] Add Supabase scripts
- [x] Add auth.js and session.js
- [ ] Replace existing login logic with `AuthService.login()`
- [ ] Add OTP verification flow
- [ ] Add login attempt tracking display
- [ ] Redirect to dashboard on success

### For Sign Up Page (signup.html)

- [x] Add Supabase scripts
- [x] Add auth.js and session.js
- [ ] Replace existing signup logic with `AuthService.signUp()`
- [ ] Add OTP verification step
- [ ] Show success message
- [ ] Redirect to login after verification

### For Protected Pages (dashboards, etc.)

- [ ] Add Supabase scripts
- [ ] Add session.js
- [ ] Add `SessionManager.requireAuth()` on page load
- [ ] Update header/sidebar with user info
- [ ] Add logout functionality

---

## 🐛 Troubleshooting

### Error: "User not found"
- User hasn't verified their email
- Go to "Verify OTP" tab and enter the code from email

### Error: "Email not confirmed"
- Check email for OTP code
- Code expires in 10 minutes
- Request new code if expired (re-login)

### Error: "Too many login attempts"
- Wait 15 minutes
- Clear localStorage: `localStorage.clear()` (dev only)

### Error: "Invalid credentials"
- Check email and password are correct
- Ensure password is at least 8 characters
- Remember: 5 failed attempts = 15-min lockout

### OTP Not Received
- Check spam/junk folder
- Verify email address is correct
- Wait a few minutes (email can be delayed)
- Check Supabase logs: **Authentication** → **Logs**

---

## 📊 Next Steps

### Phase 2 Remaining Tasks

- [ ] Create database tables (users, etc.)
- [ ] Setup Row Level Security (RLS) policies
- [ ] Create Storage buckets
- [ ] Integrate auth into existing pages:
  - [ ] login.html
  - [ ] signup.html
  - [ ] All dashboard pages
  - [ ] Add logout buttons
- [ ] Test end-to-end authentication flow

### Future Enhancements (Phase 3+)

- [ ] Profile picture upload
- [ ] Email change functionality
- [ ] Two-factor authentication (2FA)
- [ ] Social login (Google, Facebook)
- [ ] Admin panel for user management
- [ ] Audit logs for authentication events

---

## 📞 Support & Resources

### Supabase Docs
- Auth Guide: https://supabase.com/docs/guides/auth
- Email Auth: https://supabase.com/docs/guides/auth/auth-email
- Row Level Security: https://supabase.com/docs/guides/auth/row-level-security

### BIMS Documentation
- `PROGRESS.md` - Project progress tracking
- `CLAUDE.md` - Technical specifications
- `SUPABASE-SETUP.md` - Supabase connection guide

---

## ✅ Summary

**What's Ready:**
- ✅ Supabase authentication configured
- ✅ Email/Password auth with OTP verification
- ✅ Sign up, login, password reset functions
- ✅ Session management and role-based access
- ✅ Login attempt tracking (5 attempts, 15-min lockout)
- ✅ Test page for all features

**Next Steps:**
1. Test all features in `test-auth.html`
2. Create database tables
3. Integrate into actual login.html and signup.html pages
4. Protect all dashboard pages with SessionManager
5. Add logout buttons to all authenticated pages

**Status:** Phase 2 Authentication ✅ COMPLETE - Ready for Testing!
