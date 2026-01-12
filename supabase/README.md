# BIMS Supabase Setup Guide

This guide will help you set up the PostgreSQL database schema, storage buckets, and Row Level Security policies for the Barangay Information Management System.

## Prerequisites

1. A Supabase project (https://supabase.com)
2. Supabase project URL and anon key configured in `js/config/env.js`

## Migration Files

The migrations are numbered in the order they should be executed:

1. **001_create_schema.sql** - Creates all database tables with indexes
2. **002_create_storage_buckets.sql** - Sets up storage buckets and policies
3. **003_row_level_security.sql** - Configures RLS policies for all tables
4. **004_auth_sync_trigger.sql** - Sets up auth sync and notification triggers
5. **005_captain_table.sql** - Creates Captain term tracking and succession management
6. **006_add_superadmin_role.sql** - Adds SUPERADMIN role and restructures permissions (Option A)

## Setup Instructions

### Option 1: Using Supabase Dashboard (Recommended)

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor** in the left sidebar
3. Click **New Query**
4. Copy and paste the content of each migration file in order (001, 002, 003, 004)
5. Click **Run** after pasting each file
6. Verify that each migration completes without errors before proceeding to the next

### Option 2: Using Supabase CLI

```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Run migrations
supabase db push
```

## Database Schema Overview

### Core Tables

- **User_Tbl** - User accounts and profiles (roles: SUPERADMIN, CAPTAIN, SK_OFFICIAL, YOUTH_VOLUNTEER)
- **SK_Tbl** - SK Officials information
- **Captain_Tbl** - Barangay Captain term tracking
- **Announcement_Tbl** - Public announcements
- **File_Tbl** - Document repository
- **Pre_Project_Tbl** - Project proposals
- **Post_Project_Tbl** - Completed projects
- **Application_Tbl** - Volunteer applications
- **Inquiry_Tbl** / **Reply_Tbl** - Q&A system
- **Notification_Tbl** - User notifications
- **Certificate_Tbl** - Volunteer certificates
- **Evaluation_Tbl** - Project evaluations
- **Testimonies_Tbl** - User testimonials

## Storage Buckets

### Public Buckets (publicly accessible)

- **user-images** - User profile photos
- **announcement-images** - Announcement images
- **project-images** - Project cover images
- **general-files** - Public documents (PDF, Excel, Word)
- **project-files** - Project-related files

### Private Buckets (role-based access)

- **consent-forms** - Parental consent forms (under 18)
- **receipts** - Expense receipts
- **certificates** - Volunteer certificates

## Row Level Security (RLS)

All tables have RLS enabled with the following general rules:

### Public Access

- View active announcements
- View approved projects
- View SK Officials
- View annual budgets
- View testimonies (unfiltered)

### Youth Volunteers

- View and update their own profile
- Apply to projects
- View their applications
- Submit inquiries
- View their certificates
- Submit evaluations
- Submit testimonies

### SK Officials

- Full CRUD on announcements
- Full CRUD on files
- Create and manage projects
- View all applications
- Manage application status
- Reply to inquiries
- Upload certificates
- View all evaluations

### System Administrator (SUPERADMIN)

- Full user management (promote, demote, deactivate users)
- View all system logs and audit trails
- Database statistics and monitoring
- Designate new Barangay Captain when term expires

### Barangay Captain

- View announcements (read-only)
- Approve/reject/request revision for projects
- View archives (projects and files, read-only)

## Important Helper Functions

The following functions are available for use in your application:

### `update_user_profile()`

Updates the authenticated user's profile information.

```sql
SELECT update_user_profile(
  'John',                    -- firstName
  'Doe',                     -- lastName
  'M',                       -- middleName
  '2000-01-01',             -- birthday
  '+639123456789',          -- contactNumber
  '123 Main St, Malanday',  -- address
  'https://...'             -- imagePathURL
);
```

### `create_notification()`

Creates a notification for a specific user.

```sql
SELECT create_notification(
  'user-uuid',              -- userID
  'new_announcement',       -- notificationType
  'New announcement posted' -- title
);
```

### `log_action()`

Logs a user action to the Logs_Tbl.

```sql
SELECT log_action(
  'Created new project',    -- action
  NULL,                     -- replyID (optional)
  123,                      -- postProjectID (optional)
  NULL,                     -- applicationID (optional)
  NULL,                     -- inquiryID (optional)
  NULL,                     -- notificationID (optional)
  NULL,                     -- fileID (optional)
  NULL                      -- testimonyID (optional)
);
```

## Automatic Triggers

The following triggers run automatically:

1. **on_auth_user_created** - Syncs new Supabase Auth users to User_Tbl
2. **on_inquiry_reply_created** - Notifies users when their inquiry is answered
3. **on_application_status_changed** - Notifies users of application status updates
4. **on_project_approval_changed** - Notifies project creators of approval status
5. **on_new_project_created** - Notifies Captain of new projects awaiting approval
6. **update\_\*\_updated_at** - Automatically updates updatedAt timestamps

## Verification Steps

After running all migrations, verify the setup:

1. **Check Tables**

   - Go to **Table Editor** in Supabase Dashboard
   - Verify all 20 tables are created (19 from migration 001 + Captain_Tbl from migration 005)

2. **Check Storage**

   - Go to **Storage** in Supabase Dashboard
   - Verify all 8 buckets are created

3. **Check RLS**

   - Go to **Authentication** → **Policies**
   - Verify policies are enabled for all tables

4. **Test User Creation**
   - Sign up a new user via your signup.html
   - Check if the user appears in User_Tbl
   - Verify accountStatus is 'ACTIVE' after email verification

## File Upload Examplen

```javascript
// Upload user profile image
const file = event.target.files[0];
const fileName = `${userId}/${Date.now()}_${file.name}`;

const { data, error } = await supabaseClient.storage
  .from('user-images')
  .upload(fileName, file);

if (!error) {
  const { data: { publicUrl } } = supabaseClient.storage
    .from('user-images')
    .getPublicUrl(fileName);

  // Update user profile with image URL
  await update_user_profile(..., publicUrl);
}
```

## Troubleshooting

### Error: "permission denied for schema public"

- Make sure you're running migrations as the postgres role or have proper permissions

### Error: "relation already exists"

- Some tables may already exist. You can safely skip those errors or drop existing tables first

### RLS blocking queries

- Check if the user is authenticated
- Verify the user's role in User_Tbl
- Check if the RLS policy conditions match your query

## Next Steps

After completing the database setup:

1. Update `js/config/env.js` with your Supabase credentials
2. Test user signup and login flows
3. Implement profile editing functionality
4. Build the dashboard interfaces for each role
5. Implement file upload functionality
6. Test RLS policies with different user roles

## Support

For issues related to:

- Supabase setup: https://supabase.com/docs
- BIMS implementation: Check CLAUDE.md and PROGRESS.md
