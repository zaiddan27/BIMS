# Database Casing Fix - Complete List

## Files That Need Fixing:

### ❌ **Files with lowercase references:**
1. `complete-profile.html` - user_tbl, userid
2. `sk-dashboard.html` - firstname, lastname, middlename, accountstatus
3. `youth-dashboard.html` - user_tbl, userid, firstname
4. `superadmin-user-management.html` - firstname, accountstatus
5. `captain-dashboard.html` - (need to check)
6. `superadmin-dashboard.html` - (need to check)

### ✅ **Already Fixed:**
- `login.html`
- `google-auth-handler.js`
- `session.js`

---

## Search and Replace Rules:

**Table Names (in JavaScript/HTML):**
```javascript
// WRONG:
.from('user_tbl')
.from('announcement_tbl')
.from('sk_tbl')

// CORRECT:
.from('User_Tbl')
.from('Announcement_Tbl')
.from('SK_Tbl')
```

**Column Names (in JavaScript/HTML):**
```javascript
// WRONG:
.select('userid, firstname, lastname, accountstatus')
.eq('userid', id)
userData.firstname
userData.accountstatus

// CORRECT:
.select('userID, firstName, lastName, accountStatus')
.eq('userID', id)
userData.firstName
userData.accountStatus
```

---

## Complete Replacement Map:

### Table Names:
| Wrong | Correct |
|-------|---------|
| `'user_tbl'` | `'User_Tbl'` |
| `'sk_tbl'` | `'SK_Tbl'` |
| `'announcement_tbl'` | `'Announcement_Tbl'` |
| `'file_tbl'` | `'File_Tbl'` |
| `'pre_project_tbl'` | `'Pre_Project_Tbl'` |
| `'application_tbl'` | `'Application_Tbl'` |
| `'captain_tbl'` | `'Captain_Tbl'` |
| `'notification_tbl'` | `'Notification_Tbl'` |

### Column Names:
| Wrong | Correct |
|-------|---------|
| `'userid'` | `'userID'` |
| `'firstname'` | `'firstName'` |
| `'lastname'` | `'lastName'` |
| `'middlename'` | `'middleName'` |
| `'accountstatus'` | `'accountStatus'` |
| `'contentstatus'` | `'contentStatus'` |
| `'imagepathurl'` | `'imagePathURL'` |
| `'contactnumber'` | `'contactNumber'` |
| `'termsconditions'` | `'termsConditions'` |
| `'createdat'` | `'createdAt'` |
| `'updatedat'` | `'updatedAt'` |
| `'publisheddate'` | `'publishedDate'` |

### JavaScript Object Properties:
| Wrong | Correct |
|-------|---------|
| `.firstname` | `.firstName` |
| `.lastname` | `.lastName` |
| `.middlename` | `.middleName` |
| `.accountstatus` | `.accountStatus` |
| `.contactnumber` | `.contactNumber` |
| `.imagepathurl` | `.imagePathURL` |

---

## Priority Files to Fix NOW (for Google OAuth):

These are blocking Google OAuth:
1. ✅ `complete-profile.html` - Users redirected here after OAuth
2. Any dashboard files referenced in redirectToDashboard()

Would you like me to:
A) Fix these files one by one manually
B) Create a bulk find/replace script
C) Focus only on the critical path for Google OAuth to work first
