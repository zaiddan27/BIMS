# Supabase Setup Guide for BIMS

This guide will help you connect your BIMS frontend to Supabase backend.

---

## 📋 Prerequisites

- ✅ Supabase project created: "BIMS - SK MALANDAY"
- ✅ Project URL: `https://vreuvpzxnvrhftafmado.supabase.co`
- ⏳ Anon public key (we'll get this next)

---

## 🔑 Step 1: Get Your Supabase API Key

1. Go to your Supabase dashboard: https://supabase.com/dashboard/project/vreuvpzxnvrhftafmado
2. Click on **"Project Settings"** (⚙️ gear icon in the sidebar)
3. Click on **"API"** in the left menu
4. Copy the **`anon` `public`** key (long string starting with `eyJ...`)
   - ⚠️ **DO NOT** copy the `service_role` key (that's for server-side only)
   - The `anon` key is safe to use in your frontend code

---

## 🛠️ Step 2: Configure Your Local Environment

1. **Open** `js/config/env.js` in your code editor

2. **Replace** this line:
   ```javascript
   SUPABASE_ANON_KEY: 'YOUR_SUPABASE_ANON_KEY_HERE',
   ```

   With your actual key:
   ```javascript
   SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',  // Your actual key
   ```

3. **Save** the file

---

## ✅ Step 3: Test Your Connection

1. **Open** `test-supabase-connection.html` in your browser:
   ```
   C:\Users\Lenovo\OneDrive\Pictures\Documents\BIMS\test-supabase-connection.html
   ```

2. You should see:
   - ✅ Supabase library loaded successfully
   - ✅ Environment configuration loaded
   - ✅ Supabase client initialized successfully
   - ✅ Connection test passed! (or warning about no tables - normal in Phase 1)

3. If you see any ❌ red errors:
   - Check that you copied the correct anon key
   - Check that `env.js` is saved properly
   - Open browser console (F12) to see detailed error messages

---

## 📁 Files Created

| File | Purpose | Commit to Git? |
|------|---------|----------------|
| `js/config/env.js` | Contains API keys | ❌ **NO** (already in .gitignore) |
| `js/config/supabase.js` | Supabase client setup | ✅ Yes |
| `.env.example` | Template for others | ✅ Yes |
| `test-supabase-connection.html` | Connection testing | ✅ Yes |

---

## 🔐 Security Best Practices

### ✅ Safe (Anon Key)
- The `anon` key is designed for frontend use
- It's protected by Row Level Security (RLS) policies
- Users can only access data their RLS policies allow

### ❌ Unsafe (Service Role Key)
- **NEVER** use the `service_role` key in your frontend
- It bypasses all RLS policies (superuser access)
- Only use it in server-side code (backend APIs, cloud functions)

### 🔒 What's Protected
- `js/config/env.js` is already in `.gitignore`
- Never commit actual API keys to Git
- Share `.env.example` instead for documentation

---

## 🚀 Using Supabase in Your HTML Pages

Add these script tags to any page that needs Supabase:

```html
<!-- Load Supabase from CDN -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<!-- Load Configuration -->
<script src="js/config/env.js"></script>
<script src="js/config/supabase.js"></script>

<!-- Your custom scripts -->
<script>
    // Supabase is now available as window.supabaseClient

    // Example: Get all users
    async function getUsers() {
        const { data, error } = await supabaseClient
            .from('users')
            .select('*');

        if (error) {
            console.error('Error:', error);
        } else {
            console.log('Users:', data);
        }
    }
</script>
```

---

## 📊 Next Steps (Phase 2)

Once connection is working, you'll need to:

1. **Create Database Tables** (see `CLAUDE.md` for schema)
   - Use Supabase SQL Editor
   - Run migrations to create all 18 tables

2. **Setup Row Level Security (RLS)**
   - Define policies for SK_OFFICIAL, YOUTH_VOLUNTEER, CAPTAIN roles
   - Protect sensitive data

3. **Create Storage Buckets**
   - user-avatars
   - announcement-images
   - project-images
   - uploaded-files
   - certificates
   - etc.

4. **Implement Authentication**
   - Email/Password sign up
   - OTP verification via Gmail API
   - Role-based access control

---

## 🐛 Troubleshooting

### Error: "Supabase library not loaded"
- Check that the CDN script tag is before `env.js` and `supabase.js`
- Make sure you have internet connection (CDN requires it)

### Error: "ENV configuration not loaded"
- Check that `js/config/env.js` exists and is properly formatted
- Make sure the script tag order is correct

### Error: "API key not configured"
- Open `js/config/env.js`
- Make sure you replaced `YOUR_SUPABASE_ANON_KEY_HERE` with your actual key

### Warning: "Connected but no tables found"
- This is **NORMAL** in Phase 1
- You'll create tables in Phase 2

---

## 📞 Support

If you encounter issues:

1. Check browser console (F12 → Console tab)
2. Read error messages carefully
3. Verify your API key is correct
4. Check that all files are saved

---

## 🎉 Success!

Once you see ✅ green checkmarks on the test page, you're ready to:
- Proceed to Phase 2 (Database Setup)
- Start implementing authentication
- Connect frontend to backend

**Current Status:** Phase 1 (Frontend) ✅ → Phase 2 (Backend Setup) ⏳
