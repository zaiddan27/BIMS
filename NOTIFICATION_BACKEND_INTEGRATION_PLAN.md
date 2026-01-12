# Notification Backend Integration Plan

## Overview
Integrate the notification system with Supabase backend to replace dummy data with real-time database notifications.

## Database Schema (from CLAUDE.md)
```sql
notifications (Notification_Tbl)
- id: SERIAL (PRIMARY KEY)
- user_id: UUID (FOREIGN KEY → users.id)
- notification_type: ENUM ('new_announcement', 'inquiry_update', 'new_project',
  'application_approved', 'application_pending', 'project_approved',
  'project_rejected', 'revision_requested', 'new_inquiry', 'new_application',
  'project_awaiting_approval')
- title: VARCHAR(255) (NOT NULL)
- is_read: BOOLEAN (DEFAULT: FALSE)
- created_at: TIMESTAMPTZ (DEFAULT: NOW())
- updated_at: TIMESTAMPTZ (DEFAULT: NOW())
```

## Notification Types by User Role

### Youth Volunteers
- `new_announcement` - New announcement posted
- `new_project` - New volunteer project posted
- `application_approved` - Application approved
- `application_pending` - Application under review
- `inquiry_update` - SK replied to inquiry

### SK Officials
- `new_inquiry` - Youth asked question on project
- `new_application` - New volunteer application
- `project_approved` - Captain approved project
- `project_rejected` - Captain rejected project
- `revision_requested` - Captain requested revision

### Captain
- `project_awaiting_approval` - New project needs approval

### Superadmin
- System notifications (if any)

## Implementation Plan

### Phase 1: Create Shared Notification Module
**File**: `js/notifications/notification-manager.js` (NEW)

Create a reusable notification manager class:
```javascript
class NotificationManager {
  constructor(supabaseClient, userId, userRole) {
    this.supabase = supabaseClient;
    this.userId = userId;
    this.userRole = userRole;
    this.notifications = [];
  }

  async loadNotifications() {
    // Fetch notifications from Supabase
    // Order by created_at DESC
    // Return formatted notifications
  }

  async markAsRead(notificationId) {
    // Update is_read = true
  }

  async markAllAsRead() {
    // Update all user's notifications to is_read = true
  }

  updateBadge() {
    // Update notification count badge
  }

  renderNotifications(containerId) {
    // Render notifications in modal
  }

  getIconForType(notificationType) {
    // Return appropriate SVG icon
  }

  getRouteForNotification(notification) {
    // Return appropriate page URL based on type
  }

  handleNotificationClick(notificationId) {
    // Mark as read and navigate
  }
}
```

### Phase 2: Update Youth Dashboard Files
**Files to update**:
- `youth-dashboard.html`
- `youth-files.html`
- `youth-projects.html`
- `youth-certificates.html`

**Changes for each file**:

1. **Add script import** (before closing `</body>`):
```html
<script src="js/notifications/notification-manager.js"></script>
```

2. **Remove dummy notification data**:
```javascript
// DELETE: let notifications = [...]
```

3. **Initialize NotificationManager** (in DOMContentLoaded):
```javascript
let notificationManager;

async function initNotifications() {
  const { data: { session } } = await supabaseClient.auth.getSession();
  if (!session) return;

  const { data: user } = await supabaseClient
    .from('user_tbl')
    .select('*')
    .eq('userid', session.user.id)
    .single();

  if (!user) return;

  notificationManager = new NotificationManager(
    supabaseClient,
    user.userid,
    user.role
  );

  await notificationManager.loadNotifications();
  notificationManager.updateBadge();
}
```

4. **Update existing functions**:
```javascript
function toggleNotificationModal() {
  const modal = document.getElementById('notificationModal');
  modal.classList.toggle('hidden');

  if (!modal.classList.contains('hidden')) {
    notificationManager.renderNotifications('notificationList');
  }
}

function closeNotificationModal() {
  document.getElementById('notificationModal').classList.add('hidden');
}

async function markAllAsRead() {
  await notificationManager.markAllAsRead();
  notificationManager.updateBadge();
  notificationManager.renderNotifications('notificationList');
}

// Make functions available globally
window.toggleNotificationModal = toggleNotificationModal;
window.closeNotificationModal = closeNotificationModal;
window.markAllAsRead = markAllAsRead;
```

5. **Call initNotifications** after auth check:
```javascript
window.addEventListener('DOMContentLoaded', async () => {
  const isAuthenticated = await checkAuth();
  if (!isAuthenticated) return;

  await initNotifications(); // Add this

  // ... rest of initialization
});
```

### Phase 3: Update SK Dashboard Files
**Files to update**:
- `sk-dashboard.html`
- `sk-projects.html`
- `sk-files.html`
- `sk-archive.html`
- `sk-testimonies.html`

**Apply same changes as Phase 2** (identical pattern)

### Phase 4: Update Captain Dashboard
**File**: `captain-dashboard.html`

**Apply same changes as Phase 2** (identical pattern)

###  Phase 5: Update Superadmin Files
**Files to update**:
- `superadmin-dashboard.html`
- `superadmin-activity-logs.html`

**Apply same changes as Phase 2** (identical pattern, but may have no/minimal notifications)

### Phase 6: Notification Icon Mapping
**In notification-manager.js**:

```javascript
getIconForType(notificationType) {
  const icons = {
    new_announcement: `<svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z"></path>
    </svg>`,

    inquiry_update: `<svg class="w-5 h-5 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path>
    </svg>`,

    new_project: `<svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
    </svg>`,

    application_approved: `<svg class="w-5 h-5 text-[#2f6e4e]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
    </svg>`,

    application_pending: `<svg class="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
    </svg>`,

    project_approved: `<svg class="w-5 h-5 text-[#2f6e4e]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
    </svg>`,

    project_rejected: `<svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
    </svg>`,

    revision_requested: `<svg class="w-5 h-5 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
    </svg>`,

    new_inquiry: `<svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
    </svg>`,

    new_application: `<svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
    </svg>`,

    project_awaiting_approval: `<svg class="w-5 h-5 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
    </svg>`
  };

  return icons[notificationType] || icons.new_announcement;
}
```

### Phase 7: Notification Routing
**In notification-manager.js**:

```javascript
getRouteForNotification(notification) {
  const type = notification.notification_type;

  // Parse metadata if stored as JSON in title or separate field
  // For now, route to logical pages

  const routes = {
    new_announcement: 'youth-dashboard.html',
    new_project: 'youth-projects.html',
    application_approved: 'youth-projects.html?tab=myApplications',
    application_pending: 'youth-projects.html?tab=myApplications',
    inquiry_update: 'youth-projects.html?tab=inquiries',

    new_inquiry: 'sk-projects.html?tab=inquiries',
    new_application: 'sk-projects.html?tab=applications',
    project_approved: 'sk-projects.html',
    project_rejected: 'sk-projects.html',
    revision_requested: 'sk-projects.html',

    project_awaiting_approval: 'captain-dashboard.html?tab=pending'
  };

  return routes[type] || '#';
}
```

## Critical Files to Create
1. **js/notifications/notification-manager.js** - New shared notification module

## Critical Files to Modify
### Youth (4 files):
1. youth-dashboard.html
2. youth-files.html
3. youth-projects.html
4. youth-certificates.html

### SK (5 files):
5. sk-dashboard.html
6. sk-projects.html
7. sk-files.html
8. sk-archive.html
9. sk-testimonies.html

### Captain (1 file):
10. captain-dashboard.html

### Superadmin (2 files):
11. superadmin-dashboard.html
12. superadmin-activity-logs.html

**Total: 1 new file + 12 modified files**

## Error Handling
```javascript
async loadNotifications() {
  try {
    const { data, error } = await this.supabase
      .from('Notification_Tbl')
      .select('*')
      .eq('userid', this.userId)
      .order('createdat', { ascending: false })
      .limit(50);

    if (error) {
      console.error('Error loading notifications:', error);
      return [];
    }

    this.notifications = data || [];
    return this.notifications;
  } catch (err) {
    console.error('Failed to load notifications:', err);
    return [];
  }
}
```

## Testing Plan

### Manual Testing
1. **Youth Volunteer Account**:
   - Login as youth volunteer
   - Check notification badge shows correct unread count
   - Open notification modal
   - Verify notifications display with correct icons
   - Click notification - verify it marks as read and navigates
   - Click "Mark all as read" - verify badge updates

2. **SK Official Account**:
   - Repeat above tests
   - Verify SK-specific notification types appear
   - Test inquiry and application notifications

3. **Captain Account**:
   - Verify approval-related notifications appear
   - Test navigation to pending projects

4. **Superadmin Account**:
   - Verify notification system works (even if no notifications)

### Database Verification
1. Check `Notification_Tbl` in Supabase dashboard
2. Verify notifications exist for test users
3. Verify `is_read` field updates correctly
4. Check foreign key relationships (userid → user_tbl)

### Edge Cases
- No notifications (empty state)
- Network error handling
- Invalid notification types
- Missing user session
- Database connection failures

## Rollout Strategy
1. Create notification-manager.js module first
2. Test with youth-dashboard.html (single file)
3. Once working, roll out to all other files
4. Monitor console for errors
5. Test with real user accounts

## Future Enhancements (Out of Scope)
- Real-time notifications using Supabase subscriptions
- Push notifications
- Notification preferences/settings
- Notification history pagination
- Delete/archive notifications
- Notification sounds/toasts on new notifications
