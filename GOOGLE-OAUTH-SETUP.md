# Google OAuth Integration Guide for BIMS

Complete guide to integrate Google OAuth authentication with your existing Supabase email/password system.

---

## 📋 Prerequisites

✅ Supabase project created and working
✅ Email/Password authentication working
✅ Database tables created (User_Tbl, etc.)
✅ Google account for creating OAuth app

---

## 🚀 Part 1: Google Cloud Console Setup

### Step 1: Create Google Cloud Project

1. Go to **Google Cloud Console**: https://console.cloud.google.com/
2. Click **"Select a project"** → **"New Project"**
3. Enter project details:
   - **Project Name**: `BIMS-SK-Malanday`
   - **Organization**: Leave as default (No organization)
   - **Location**: Leave as default
4. Click **"Create"**
5. Wait for project creation (30 seconds)
6. Select your new project from the dropdown

### Step 2: Configure OAuth Consent Screen

1. In left sidebar, go to **"APIs & Services"** → **"OAuth consent screen"**
2. Choose **"External"** user type
3. Click **"Create"**

#### OAuth Consent Screen - Page 1 (App Information)

Fill in these fields:

```
App name: BIMS - SK Malanday
User support email: [Your email address]
App logo: [Optional - Upload your logo.svg]

Application home page: https://your-domain.com (or leave blank for dev)
Application privacy policy: https://your-domain.com/privacy (or leave blank for dev)
Application terms of service: https://your-domain.com/terms (or leave blank for dev)

Developer contact information:
Email addresses: [Your email address]
```

4. Click **"Save and Continue"**

#### OAuth Consent Screen - Page 2 (Scopes)

1. Click **"Add or Remove Scopes"**
2. Select these scopes:
   - ✅ `.../auth/userinfo.email` - See your primary Google Account email address
   - ✅ `.../auth/userinfo.profile` - See your personal info
   - ✅ `openid` - Associate you with your personal info on Google
3. Click **"Update"**
4. Click **"Save and Continue"**

#### OAuth Consent Screen - Page 3 (Test Users)

For development/testing, add test users:

1. Click **"+ Add Users"**
2. Add email addresses of people who will test (including yourself)
3. Click **"Add"**
4. Click **"Save and Continue"**

**Note**: Your app will be in "Testing" mode initially.

### Step 3: Create OAuth 2.0 Credentials

1. In left sidebar, go to **"APIs & Services"** → **"Credentials"**
2. Click **"+ Create Credentials"** → **"OAuth client ID"**
3. Select **"Web application"**
4. Fill in details:

```
Name: BIMS Web Client

Authorized JavaScript origins:
- http://localhost
- http://localhost:8000
- http://localhost:5500
- http://127.0.0.1
- https://your-netlify-site.netlify.app (add when deployed)

Authorized redirect URIs:
- https://[YOUR-SUPABASE-PROJECT-REF].supabase.co/auth/v1/callback
```

**How to find your Supabase Project Ref:**
- Go to Supabase Dashboard → Settings → General → Project URL
- Example: `abcdefghijklmnop.supabase.co`

5. Click **"Create"**
6. **SAVE THESE CREDENTIALS**:
   - ✅ Client ID (e.g., `123456789-abcdefg.apps.googleusercontent.com`)
   - ✅ Client Secret (e.g., `GOCSPX-abc123def456`)

⚠️ **SECURITY**: Keep Client Secret secure! Never commit to Git!

---

## 🔐 Part 2: Supabase Configuration

1. Go to **Supabase Dashboard** → **Authentication** → **Providers**
2. Find **"Google"** and toggle **"Enable"** to ON
3. Enter credentials:
   ```
   Client ID (for OAuth): [Your Google Client ID]
   Client Secret (for OAuth): [Your Google Client Secret]
   ```
4. Copy the **"Redirect URL"** shown (should be `https://[ref].supabase.co/auth/v1/callback`)
5. Click **"Save"**
6. Verify this redirect URL matches the one in Google Console

---

## 💻 Part 3: Frontend Integration

I'll now update your actual code files with Google OAuth integration.
