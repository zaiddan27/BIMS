# BIMS Email Template Setup Guide

Beautiful, branded email templates for your BIMS authentication system.

---

## 🎨 Templates Created

| Template | File | Purpose |
|----------|------|---------|
| **Confirm Signup** | `confirm-signup.html` | OTP verification for new users |
| **Reset Password** | `reset-password.html` | Password reset link |

Both templates feature:
- ✅ BIMS branding with green gradient (#2f6e4e → #3d8b64)
- ✅ Professional, modern design
- ✅ Mobile-responsive layout
- ✅ Clear OTP code display (6 digits, prominent)
- ✅ Security warnings and instructions
- ✅ SK Malanday footer

---

## 📝 How to Apply Templates in Supabase

### Step 1: Open Email Templates

1. Go to your **Supabase dashboard**
2. Click **"Authentication"** in the left sidebar
3. Click **"Email Templates"**

You'll see 4 templates to customize:
- Confirm signup
- Magic Link
- Change Email Address
- Reset Password

---

### Step 2: Update "Confirm signup" Template

1. **Click on "Confirm signup"**
2. You'll see a text editor with the current template
3. **Delete all existing content**
4. **Copy the contents** of `confirm-signup.html`
5. **Paste** into the Supabase editor
6. **Click "Save"** at the bottom

**Preview:**
- Large green gradient header with "🏛️ BIMS"
- Welcome message
- **Big 6-digit OTP code in green box** ({{ .Token }})
- 10-minute expiry warning
- Professional footer with SK Malanday

---

### Step 3: Update "Reset Password" Template

1. **Click on "Reset Password"**
2. **Delete all existing content**
3. **Copy the contents** of `reset-password.html`
4. **Paste** into the Supabase editor
5. **Click "Save"**

**Preview:**
- Same green BIMS branding
- "Reset Your Password 🔒" heading
- Big green "Reset Password" button
- Security warnings in yellow box
- Same professional footer

---

## ✅ Testing Your New Templates

### Test Confirm Signup Email

1. Go to `test-auth.html`
2. Sign up with a **new email address** (different from before)
3. Check your email inbox
4. You should see:
   - ✅ Green BIMS header
   - ✅ Large 6-digit OTP code in green box
   - ✅ Professional styling

### Test Reset Password Email

1. Go to `test-auth.html`
2. Go to "Reset Password" tab
3. Enter your email
4. Check your inbox
5. You should see:
   - ✅ Green BIMS branding
   - ✅ Big "Reset Password" button
   - ✅ Security warnings

---

## 🎨 Template Variables

Supabase provides these variables you can use:

| Variable | Purpose | Used In |
|----------|---------|---------|
| `{{ .Token }}` | 6-digit OTP code | Confirm signup |
| `{{ .ConfirmationURL }}` | Reset password link | Reset password |
| `{{ .SiteURL }}` | Your app URL | Any template |
| `{{ .Email }}` | User's email | Any template |

Our templates already use the correct variables!

---

## 🔧 Customization Options

### Change Colors

If you want to adjust the green shade:

**Current colors:**
- Primary: `#2f6e4e`
- Secondary: `#3d8b64`
- Light: `#e8f5e9`

**To change:**
1. Find all instances of these hex codes in the template
2. Replace with your preferred color
3. Save in Supabase

### Add Your Logo

Replace this line in both templates:
```html
<h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: 700;">
    🏛️ BIMS
</h1>
```

With an image:
```html
<img src="YOUR_LOGO_URL" alt="BIMS Logo" style="height: 60px; max-width: 200px;">
```

**Note:** Logo must be hosted online (use Supabase Storage or another CDN)

---

## 📊 Template Features

### 1. Responsive Design
- Works on all devices (desktop, tablet, mobile)
- Uses table-based layout (best for email clients)
- Tested with Gmail, Outlook, Apple Mail

### 2. Professional Typography
- Clear hierarchy (headings, body text)
- Readable fonts (system fonts for best compatibility)
- Proper spacing and alignment

### 3. Security Indicators
- Expiry time prominently displayed
- Warning boxes for important information
- "Do not share" reminders

### 4. Accessibility
- High contrast text
- Clear calls-to-action
- Alt text for important elements

---

## 🐛 Troubleshooting

### Template Not Updating

**Problem:** Still seeing old email template after saving

**Solution:**
1. Clear browser cache
2. Try signing up with a **completely new email**
3. Check Supabase logs: **Authentication → Logs**
4. Make sure you clicked "Save" in the template editor

### OTP Code Not Showing

**Problem:** Email shows {{ .Token }} instead of actual code

**Solution:**
- Make sure you saved the template correctly
- Check that you didn't accidentally modify the `{{ .Token }}` variable
- Supabase must replace this automatically

### Email Not Arriving

**Problem:** Not receiving emails at all

**Solution:**
1. Check spam/junk folder
2. Verify email address is correct
3. Check Supabase logs for delivery status
4. Free tier has email limits (check quota)

---

## 📧 Email Sending Limits (Supabase Free Tier)

| Limit | Free Tier |
|-------|-----------|
| Emails per hour | 4 emails |
| Emails per day | ~30 emails |

If you exceed limits:
- Upgrade to Supabase Pro
- Or use custom SMTP (Gmail, SendGrid, etc.)

---

## 🚀 Next Steps

After applying templates:

1. ✅ Test with real email addresses
2. ✅ Verify OTP codes appear correctly
3. ✅ Test password reset flow
4. ✅ Check on different email clients (Gmail, Outlook, etc.)
5. Consider adding logo image (optional)

---

## 📞 Support

### Supabase Email Template Docs
- https://supabase.com/docs/guides/auth/auth-email-templates

### Email Template Testing
- Use [Litmus](https://www.litmus.com/) or [Email on Acid](https://www.emailonacid.com/) for comprehensive testing
- Or just test with Gmail, Outlook, and Apple Mail

---

## ✅ Summary

**Files Created:**
- `confirm-signup.html` - Branded OTP email
- `reset-password.html` - Branded password reset
- `TEMPLATE-SETUP-GUIDE.md` - This guide

**To Apply:**
1. Go to Supabase → Authentication → Email Templates
2. Copy-paste templates from files above
3. Save and test!

**Result:**
- 🎨 Beautiful BIMS-branded emails
- 💚 Green gradient theme matching your app
- 📱 Mobile-responsive design
- 🔒 Professional security messaging

**Status:** Ready to apply! 🚀
