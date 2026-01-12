# Google OAuth Quick Start Guide

✅ **Files Updated/Created - Ready to Test!**

---

## 📁 What Was Done

### Files Created:
1. ✅ `GOOGLE-OAUTH-SETUP.md` - Complete setup documentation
2. ✅ `js/auth/google-auth-handler.js` - OAuth callback handler
3. ✅ `complete-profile.html` - Profile completion page for OAuth users
4. ✅ `supabase/migrations/008_update_oauth_trigger.sql` - Database trigger update
5. ✅ `GOOGLE-OAUTH-QUICKSTART.md` - This file!

### Files Updated:
1. ✅ `signup.html` - Google sign up button now works
2. ✅ `login.html` - Google login button now works
3. ✅ `index.html` - Added OAuth callback handler

---

## 🚀 Implementation Steps

### Step 1: Google Cloud Console Setup (5-10 minutes)

1. **Create Project**
   - Go to: https://console.cloud.google.com/
   - Click "New Project"
   - Name: `BIMS-SK-Malanday`
   - Click "Create"

2. **Configure OAuth Consent Screen**
   - Go to: APIs & Services → OAuth consent screen
   - Choose "External" user type
   - Fill in:
     - App name: `BIMS - SK Malanday`
     - User support email: Your email
     - Developer email: Your email
   - Add scopes:
     - `.../auth/userinfo.email`
     - `.../auth/userinfo.profile`
     - `openid`
   - Add test users (yourself + any testers)
   - Save

3. **Create OAuth 2.0 Client**
   - Go to: APIs & Services → Credentials
   - Click "+ Create Credentials" → "OAuth client ID"
   - Type: "Web application"
   - Name: `BIMS Web Client`
   - Authorized JavaScript origins:
     ```
     http://localhost
     http://localhost:8000
     http://localhost:5500
     ```
   - Authorized redirect URIs:
     ```
     https://[YOUR-SUPABASE-REF].supabase.co/auth/v1/callback
     ```
     (Find your ref in Supabase Dashboard → Settings → General)
   - Click "Create"
   - **SAVE** your Client ID and Client Secret!

### Step 2: Supabase Configuration (2 minutes)

1. **Enable Google Provider**
   - Go to: Supabase Dashboard → Authentication → Providers
   - Find "Google"
   - Toggle "Enable" to ON
   - Enter:
     - Client ID: [Paste from Google Console]
     - Client Secret: [Paste from Google Console]
   - Click "Save"

2. **Verify Redirect URL**
   - Copy the "Redirect URL" shown in Supabase
   - Make sure it matches what you entered in Google Console
   - Should be: `https://[your-ref].supabase.co/auth/v1/callback`

### Step 3: Update Database Trigger (1 minute)

Run this SQL in Supabase SQL Editor:

```sql
-- Run the migration file
-- Copy contents of: supabase/migrations/008_update_oauth_trigger.sql
-- Paste and run in Supabase SQL Editor
```

Or manually run:

```sql
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  user_metadata JSONB;
  full_name TEXT;
  name_parts TEXT[];
  first_name TEXT;
  last_name TEXT;
BEGIN
  user_metadata := NEW.raw_user_meta_data;

  IF NEW.app_metadata->>'provider' = 'google' THEN
    full_name := COALESCE(user_metadata->>'full_name', user_metadata->>'name', '');
    name_parts := string_to_array(full_name, ' ');
    first_name := COALESCE(name_parts[1], '');
    last_name := COALESCE(array_to_string(name_parts[2:array_length(name_parts, 1)], ' '), '');

    INSERT INTO public.user_tbl (
      userid, email, firstname, lastname, middlename, role,
      birthday, contactnumber, address, imagepathurl,
      termsconditions, accountstatus
    ) VALUES (
      NEW.id, NEW.email, first_name, last_name, NULL, 'YOUTH_VOLUNTEER',
      '2000-01-01'::DATE, '', '',
      COALESCE(user_metadata->>'avatar_url', user_metadata->>'picture'),
      TRUE, 'ACTIVE'
    )
    ON CONFLICT (userid) DO UPDATE
    SET email = EXCLUDED.email, imagepathurl = EXCLUDED.imagepathurl,
        accountstatus = 'ACTIVE', updatedat = CURRENT_TIMESTAMP;
  ELSE
    INSERT INTO public.user_tbl (
      userid, email, firstname, lastname, middlename, role,
      birthday, contactnumber, address, imagepathurl,
      termsconditions, accountstatus
    ) VALUES (
      NEW.id, NEW.email,
      COALESCE(user_metadata->>'first_name', ''),
      COALESCE(user_metadata->>'last_name', ''),
      user_metadata->>'middle_name',
      COALESCE(user_metadata->>'role', 'YOUTH_VOLUNTEER'),
      COALESCE((user_metadata->>'birthday')::DATE, CURRENT_DATE),
      COALESCE(user_metadata->>'contact_number', ''),
      COALESCE(user_metadata->>'address', ''),
      user_metadata->>'image_path_url',
      COALESCE((user_metadata->>'terms_conditions')::BOOLEAN, false),
      CASE WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE' ELSE 'PENDING' END
    )
    ON CONFLICT (userid) DO UPDATE
    SET email = EXCLUDED.email,
        accountstatus = CASE WHEN NEW.email_confirmed_at IS NOT NULL THEN 'ACTIVE' ELSE user_tbl.accountstatus END,
        updatedat = CURRENT_TIMESTAMP;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

---

## 🧪 Testing (5 minutes)

### Test 1: Google Sign Up

1. Open `signup.html` in browser
2. Click **"Continue with Google"**
3. You should be redirected to Google consent screen
4. Select your Google account
5. Approve permissions
6. You'll be redirected to `index.html`
7. Then automatically redirected to `complete-profile.html`
8. Fill in:
   - Middle Name (optional)
   - Birthday
   - Contact Number (11 digits, starts with 09)
   - Full Address
9. Click **"Complete Profile"**
10. You should be redirected to `youth-dashboard.html`

**✅ Expected Result**: New user created with YOUTH_VOLUNTEER role, ACTIVE status

### Test 2: Google Login (Existing User)

1. Logout from the system
2. Open `login.html`
3. Click **"Continue with Google"**
4. Select same Google account
5. You should be redirected directly to `youth-dashboard.html` (no profile completion)

**✅ Expected Result**: Existing user logged in successfully

### Test 3: Mixed Authentication

1. Create one user with Google OAuth
2. Create another user with email/password
3. Verify both users appear in Superadmin user management
4. Verify both can be promoted to SK_OFFICIAL

**✅ Expected Result**: Both auth methods work independently

---

## 🐛 Troubleshooting

### Issue: "redirect_uri_mismatch"

**Fix**:
1. Check Supabase callback URL: Authentication → Providers → Google → Redirect URL
2. Copy it exactly
3. Add to Google Console → Credentials → OAuth 2.0 Client → Authorized redirect URIs

### Issue: "Access blocked: This app's request is invalid"

**Fix**:
1. Go to Google Console → OAuth consent screen
2. Make sure you added all required scopes
3. Add yourself as a test user

### Issue: User created but missing in database

**Fix**:
1. Check Supabase logs: Authentication → Logs
2. Make sure trigger function was created successfully
3. Run the migration SQL again

### Issue: Profile completion not showing

**Fix**:
1. Check browser console for errors
2. Make sure `google-auth-handler.js` is loaded
3. Check if user record exists in database

### Issue: Redirect loop

**Fix**:
1. Clear browser cache and cookies
2. Check if `index.html` has the OAuth handler scripts
3. Make sure `complete-profile.html` exists and is accessible

---

## 📊 User Flow Diagram

```
┌─────────────────┐
│  User clicks    │
│ "Continue with  │
│     Google"     │
└────────┬────────┘
         │
         v
┌─────────────────┐
│   Redirect to   │
│ Google Consent  │
│     Screen      │
└────────┬────────┘
         │
         v
┌─────────────────┐
│   User approves │
│   permissions   │
└────────┬────────┘
         │
         v
┌─────────────────┐
│  Google calls   │
│Supabase callback│
└────────┬────────┘
         │
         v
┌─────────────────┐
│ Supabase creates│
│  auth session   │
└────────┬────────┘
         │
         v
┌─────────────────┐
│  Trigger creates│
│   user record   │
│ (YOUTH_VOLUNTEER│
│     ACTIVE)     │
└────────┬────────┘
         │
         v
┌─────────────────┐
│  Redirect to    │
│   index.html    │
└────────┬────────┘
         │
         v
┌─────────────────┐
│OAuth handler    │
│checks profile   │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    v         v
Profile   Profile
Complete  Incomplete
    │         │
    v         v
Dashboard  Complete
          Profile Page
              │
              v
          Dashboard
```

---

## 🎯 What Happens Behind the Scenes

### 1. User Clicks Google Button
- JavaScript calls `supabaseClient.auth.signInWithOAuth()`
- Supabase generates OAuth state/nonce
- Redirects to Google consent screen

### 2. Google Authenticates
- User logs in with Google
- Google shows permission consent
- User approves access

### 3. Google Redirects Back
- Google calls Supabase callback URL with auth code
- Supabase exchanges code for tokens
- Supabase creates session

### 4. Database Trigger Fires
- `handle_new_user()` trigger executes
- Detects `provider = 'google'`
- Extracts name from Google profile
- Creates user record with:
  - Role: YOUTH_VOLUNTEER
  - Status: ACTIVE
  - Birthday: 2000-01-01 (placeholder)
  - Contact: empty (placeholder)
  - Address: empty (placeholder)

### 5. OAuth Handler Checks Profile
- `google-auth-handler.js` runs on index.html
- Checks if profile is complete
- If incomplete → redirect to `complete-profile.html`
- If complete → redirect to dashboard

### 6. User Completes Profile
- Fills in birthday, contact, address
- Updates user_tbl record
- Redirects to youth dashboard

---

## 🔒 Security Features

✅ **OAuth 2.0 Protocol** - Industry standard authentication
✅ **State Parameter** - Prevents CSRF attacks
✅ **Nonce Verification** - Prevents replay attacks
✅ **Secure Token Storage** - Tokens stored in Supabase
✅ **Auto-Activated Users** - Google already verified email
✅ **Role-Based Access** - Same RBAC as email/password users
✅ **Profile Validation** - Ensures complete user data

---

## 📝 Notes

- OAuth users are **auto-activated** (Google already verified email)
- They still need to **complete profile** (birthday, contact, address)
- Default role is **YOUTH_VOLUNTEER** (same as email/password)
- Superadmin can **promote** OAuth users (same as email users)
- OAuth users can **logout and login** again with Google
- Mixed authentication is supported (some users with Google, some with email)

---

## ✅ Checklist

Before going live, make sure:

- [ ] Google Cloud Console project created
- [ ] OAuth consent screen configured
- [ ] OAuth 2.0 credentials created
- [ ] Supabase Google provider enabled
- [ ] Client ID and Secret entered in Supabase
- [ ] Redirect URLs match between Google and Supabase
- [ ] Database trigger updated
- [ ] Tested Google sign up flow
- [ ] Tested Google login flow
- [ ] Tested profile completion
- [ ] Tested mixed authentication (Google + email/password)
- [ ] Tested Superadmin promotion of OAuth users
- [ ] Added production URLs (when deploying)

---

## 🌐 Production Deployment

Before deploying to production:

1. **Update Authorized URLs**
   - Add production domain to Google Console
   - Example: `https://bims-skmalanday.netlify.app`

2. **Update Redirect URLs**
   - Change `window.location.origin` in code to production URL
   - Or use environment variables

3. **Submit for Verification** (optional)
   - Google Cloud Console → OAuth consent screen
   - Click "Publish App"
   - Submit for verification if >100 users needed

4. **Update Environment Variables**
   - Create `.env` file for production
   - Never commit secrets to Git
   - Use Netlify environment variables

---

## 🎉 You're Done!

Google OAuth is now fully integrated with your BIMS system!

**What users can do:**
- ✅ Sign up with Google (no password needed)
- ✅ Login with Google (one click)
- ✅ Complete profile automatically
- ✅ Apply to projects as Youth Volunteer
- ✅ Get promoted to SK Official by Superadmin

**What you achieved:**
- ✅ Seamless OAuth integration
- ✅ Automatic user record creation
- ✅ Profile completion flow
- ✅ Mixed authentication support
- ✅ Same role management for all users

Need help? Check `GOOGLE-OAUTH-SETUP.md` for detailed documentation.
