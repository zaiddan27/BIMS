# SDD Reconstructed Sections - Copy-Paste Ready

Below are the sections and data dictionary tables from the SDD that need to be replaced. Copy-paste these directly into the SDD document, replacing the corresponding old sections and tables.

---

## Data Dictionary Tables (Replace each corresponding table in Tab 1)

### Table 3.3: Application_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Application_Tbl | applicationID | SERIAL | PRIMARY KEY | Unique identifier for each application |
| Application_Tbl | userID | UUID | FOREIGN KEY → User_Tbl.userID | Linked applicant |
| Application_Tbl | preProjectID | INTEGER | FOREIGN KEY → Pre_Project_Tbl.preProjectID | Linked project |
| Application_Tbl | preferredRole | VARCHAR(100) | NOT NULL | Desired role for the project |
| Application_Tbl | parentConsentFile | TEXT | NULLABLE (required if under 18) | Link to consent form in Supabase Storage |
| Application_Tbl | applicationStatus | VARCHAR(20) | DEFAULT: 'PENDING' | Status: 'PENDING', 'APPROVED', 'REJECTED' |
| Application_Tbl | appliedDate | TIMESTAMPTZ | DEFAULT: CURRENT_TIMESTAMP | Date of application |
| Application_Tbl | attended | BOOLEAN | DEFAULT: FALSE | Tracks whether applicant attended the project |
| Application_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |

### Table 3.7: Evaluation_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Evaluation_Tbl | evaluationID | SERIAL | PRIMARY KEY | Unique ID for evaluation |
| Evaluation_Tbl | postProjectID | INTEGER | FOREIGN KEY → Post_Project_Tbl.postProjectID, NULLABLE | Connected post-project record |
| Evaluation_Tbl | applicationID | INTEGER | FOREIGN KEY → Application_Tbl.applicationID | Connected applicant |
| Evaluation_Tbl | q1 | INTEGER | NOT NULL, CHECK (q1 BETWEEN 1 AND 5) | Budget Efficiency rating |
| Evaluation_Tbl | q2 | INTEGER | NOT NULL, CHECK (q2 BETWEEN 1 AND 5) | Volunteer Participation rating |
| Evaluation_Tbl | q3 | INTEGER | NOT NULL, CHECK (q3 BETWEEN 1 AND 5) | Timeline Adherence rating |
| Evaluation_Tbl | q4 | INTEGER | NOT NULL, CHECK (q4 BETWEEN 1 AND 5) | Community Impact rating |
| Evaluation_Tbl | q5 | INTEGER | NOT NULL, CHECK (q5 BETWEEN 1 AND 5) | Volunteer Feedback rating |
| Evaluation_Tbl | message | TEXT | NULLABLE | Suggestions and opinions |
| Evaluation_Tbl | timeStamp | TIMESTAMPTZ | NOT NULL | Date time an evaluation was completed |
| Evaluation_Tbl | hasCertificate | BOOLEAN | DEFAULT: FALSE | If the applicant is eligible for a certificate |
| Evaluation_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |

### Table 3.6: Expenses_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Expenses_Tbl | expenseID | SERIAL | PRIMARY KEY | Unique identifier for each expense record |
| Expenses_Tbl | breakdownID | INTEGER | FOREIGN KEY → BudgetBreakdown_Tbl.breakdownID | Associated budget breakdown |
| Expenses_Tbl | actualCost | DECIMAL(15,2) | NOT NULL | Actual amount spent for this expense |
| Expenses_Tbl | receiptURL | TEXT | NULLABLE | Path or URL to receipt/invoice document |
| Expenses_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |

### Table 3.11: Notification_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Notification_Tbl | notificationID | SERIAL | PRIMARY KEY | Unique notification identifier |
| Notification_Tbl | userID | UUID | FOREIGN KEY → User_Tbl.userID | Recipient user |
| Notification_Tbl | notificationType | VARCHAR(50) | NOT NULL | Type: 'new_announcement', 'inquiry_update', 'new_project', 'application_approved', 'application_pending', 'project_approved', 'project_rejected', 'revision_requested', 'new_inquiry', 'new_application', 'project_awaiting_approval', 'user_promoted', 'user_deactivated', 'user_reactivated', 'captain_term_expiring', 'captain_term_expired' |
| Notification_Tbl | title | VARCHAR(255) | NOT NULL | Title of the notification |
| Notification_Tbl | isRead | BOOLEAN | DEFAULT: FALSE | Indicates if the notification has been read |
| Notification_Tbl | referenceID | INTEGER | NULLABLE | Deep link to related entity (e.g., preProjectID) |
| Notification_Tbl | createdAt | TIMESTAMPTZ | NOT NULL, DEFAULT: NOW() | Date the notification was created |

### Table 3.12: OTP_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| OTP_Tbl | otpID | SERIAL | PRIMARY KEY | Unique identifier for each OTP entry |
| OTP_Tbl | userID | UUID | FOREIGN KEY → User_Tbl.userID | User associated with the OTP |
| OTP_Tbl | otpCode | VARCHAR(6) | NOT NULL | One-time password code |
| OTP_Tbl | expiresAt | TIMESTAMPTZ | NOT NULL | OTP expiration timestamp |
| OTP_Tbl | isUsed | BOOLEAN | DEFAULT: FALSE | Indicates if the OTP has been used |
| OTP_Tbl | purpose | VARCHAR(20) | NOT NULL | Purpose: 'LOGIN', 'FORGOT_PASSWORD', 'SIGN_UP' |
| OTP_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |

### Table 3.14: SK_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| SK_Tbl | skID | SERIAL | PRIMARY KEY | Unique SK record identifier |
| SK_Tbl | userID | UUID | FOREIGN KEY → User_Tbl.userID | User assigned as SK official |
| SK_Tbl | position | VARCHAR(20) | NOT NULL | Position: 'SK_CHAIRMAN', 'SK_SECRETARY', 'SK_TREASURER', 'SK_KAGAWAD' |
| SK_Tbl | termStart | DATE | NOT NULL | SK term start date |
| SK_Tbl | termEnd | DATE | NOT NULL | SK term end date |
| SK_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |

Note: SK_AUDITOR has been removed — it does not exist in the current system.

### Table 3.15: Pre_Project_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Pre_Project_Tbl | preProjectID | SERIAL | PRIMARY KEY | Unique project identifier |
| Pre_Project_Tbl | userID | UUID | FOREIGN KEY → User_Tbl.userID | Project creator |
| Pre_Project_Tbl | skID | INTEGER | FOREIGN KEY → SK_Tbl.skID | Project head |
| Pre_Project_Tbl | title | VARCHAR(255) | NOT NULL | Name of project |
| Pre_Project_Tbl | description | TEXT | NOT NULL | Overview of the project |
| Pre_Project_Tbl | category | VARCHAR(100) | NOT NULL | Type or classification of project |
| Pre_Project_Tbl | budget | BIGINT | NOT NULL | Allocated budget |
| Pre_Project_Tbl | volunteers | INTEGER | NOT NULL | Expected volunteer count |
| Pre_Project_Tbl | beneficiaries | INTEGER | NOT NULL | Expected beneficiary count |
| Pre_Project_Tbl | status | VARCHAR(20) | DEFAULT: 'ONGOING' | Status: 'ONGOING', 'COMPLETED', 'CANCELLED' |
| Pre_Project_Tbl | startDateTime | TIMESTAMPTZ | NOT NULL | Start date and time |
| Pre_Project_Tbl | endDateTime | TIMESTAMPTZ | NOT NULL | End date and time |
| Pre_Project_Tbl | location | TEXT | NOT NULL | Location of project |
| Pre_Project_Tbl | imagePathURL | TEXT | NULLABLE | Banner image URL (max 5MB upload) |
| Pre_Project_Tbl | submittedDate | TIMESTAMPTZ | NOT NULL | Date a project was submitted |
| Pre_Project_Tbl | approvalStatus | VARCHAR(20) | DEFAULT: 'PENDING' | Status: 'PENDING', 'APPROVED', 'REJECTED', 'REVISION' |
| Pre_Project_Tbl | approvalDate | TIMESTAMPTZ | NULLABLE | Date a project was approved |
| Pre_Project_Tbl | approvalNotes | TEXT | NULLABLE | Notes for revision or rejection of a project |
| Pre_Project_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |
| Pre_Project_Tbl | updatedAt | TIMESTAMPTZ | DEFAULT: NOW() | Record update timestamp |

### Table 3.16: Post_Project_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Post_Project_Tbl | postProjectID | SERIAL | PRIMARY KEY | Unique project identifier |
| Post_Project_Tbl | preProjectID | INTEGER | FOREIGN KEY → Pre_Project_Tbl.preProjectID | Pre-project reference |
| Post_Project_Tbl | breakdownID | INTEGER | FOREIGN KEY → BudgetBreakdown_Tbl.breakdownID | Budget breakdown reference |
| Post_Project_Tbl | actualVolunteer | INTEGER | NOT NULL | Actual volunteer count |
| Post_Project_Tbl | timelineAdherence | VARCHAR(30) | NOT NULL | Values: 'Completed_On_Time', 'Slightly_Delayed', 'Delayed', 'Significantly_Delayed' |
| Post_Project_Tbl | beneficiariesReached | INTEGER | NOT NULL | Total beneficiaries after the project |
| Post_Project_Tbl | projectAchievement | TEXT | NOT NULL | Summary of project achievements |
| Post_Project_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |
| Post_Project_Tbl | updatedAt | TIMESTAMPTZ | DEFAULT: NOW() | Record update timestamp |

### Table 3.18: Testimonies_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Testimonies_Tbl | testimonyID | SERIAL | PRIMARY KEY | Unique identifier for each testimony record |
| Testimonies_Tbl | userID | UUID | FOREIGN KEY → User_Tbl.userID | User providing the testimony |
| Testimonies_Tbl | message | TEXT | NOT NULL | Content of the testimony or feedback |
| Testimonies_Tbl | rating | INTEGER | NULLABLE, CHECK (rating BETWEEN 1 AND 5) | User's rating for the project (1-5 stars) |
| Testimonies_Tbl | isFiltered | BOOLEAN | DEFAULT: FALSE | Indicates if testimony has been reviewed/moderated |
| Testimonies_Tbl | timeStamp | TIMESTAMPTZ | DEFAULT: CURRENT_TIMESTAMP | Date and time the testimony was submitted |
| Testimonies_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |

### Table 3.19: User_Tbl (Replace entirely)

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| User_Tbl | userID | UUID | PRIMARY KEY (Supabase Auth UID) | Unique user identifier |
| User_Tbl | password | TEXT | NOT NULL (managed by Supabase Auth) | Password for authentication (bcrypt hashed) |
| User_Tbl | email | VARCHAR(255) | UNIQUE, NOT NULL | Email address of the user |
| User_Tbl | firstName | VARCHAR(100) | NOT NULL, min 2 characters | User's first name (Title Case) |
| User_Tbl | lastName | VARCHAR(100) | NOT NULL, min 2 characters | User's last name (Title Case) |
| User_Tbl | middleName | VARCHAR(100) | NULLABLE | User's middle name (Title Case) |
| User_Tbl | role | VARCHAR(20) | NOT NULL | Role: 'SUPERADMIN', 'CAPTAIN', 'SK_OFFICIAL', 'YOUTH_VOLUNTEER' |
| User_Tbl | birthday | DATE | NOT NULL | User's date of birth |
| User_Tbl | contactNumber | VARCHAR(13) | NOT NULL | User's contact number |
| User_Tbl | address | TEXT | NOT NULL | User's home address |
| User_Tbl | imagePathURL | TEXT | NULLABLE | Profile picture URL in Supabase Storage |
| User_Tbl | termsConditions | BOOLEAN | NOT NULL | Agreement to the terms and conditions |
| User_Tbl | accountStatus | VARCHAR(20) | DEFAULT: 'PENDING' | Status: 'ACTIVE', 'INACTIVE', 'PENDING' |
| User_Tbl | gender | VARCHAR(20) | NULLABLE | User's gender |
| User_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Account creation timestamp |
| User_Tbl | updatedAt | TIMESTAMPTZ | DEFAULT: NOW() | Account update timestamp |

---

## NEW TABLE: Captain_Tbl (Add as Table 3.20)

This table was not in the original SDD but exists in the current system.

### Table 3.20: Captain_Tbl

| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Captain_Tbl | captainID | SERIAL | PRIMARY KEY | Unique captain record identifier |
| Captain_Tbl | userID | UUID | FOREIGN KEY → User_Tbl.userID | User assigned as captain |
| Captain_Tbl | termStart | DATE | NOT NULL | Captain term start date |
| Captain_Tbl | termEnd | DATE | NOT NULL | Captain term end date |
| Captain_Tbl | isActive | BOOLEAN | DEFAULT: TRUE | Whether this is the current active captain |
| Captain_Tbl | createdAt | TIMESTAMPTZ | DEFAULT: NOW() | Record creation timestamp |
| Captain_Tbl | updatedAt | TIMESTAMPTZ | DEFAULT: NOW() | Record update timestamp |

Only ONE active CAPTAIN account is allowed. Promoting a new Captain automatically deactivates the existing active Captain.

---

## Section: System Overview — External Interface (Replace the paragraph about software interfaces)

To strengthen security, the system integrates email-based verification using the Gmail API to support two-factor authentication, combining standard login credentials with OTP verification. The backend uses Supabase, a Backend-as-a-Service (BaaS) platform that provides managed PostgreSQL database, authentication (JWT-based), file storage, and real-time subscriptions. The frontend communicates with Supabase via HTTPS REST API using the Supabase JavaScript client library. Row Level Security (RLS) policies are enforced at the database level to ensure role-based access control. Finally, the system includes a robust database interface to store and manage all system data, supporting reliable CRUD operations and enforcing role-based access control to protect sensitive information. Together, these external interfaces ensure a secure, efficient, and user-centered system experience.

---

## Section 4: Component Design — Class Diagram Description (Add these notes)

> **Additional roles in current system:** The User class now includes four role types: SUPERADMIN (system administrator who manages all user accounts and roles), CAPTAIN (Barangay Captain who approves/rejects projects), SK_OFFICIAL (SK council members who create and manage projects, files, and announcements), and YOUTH_VOLUNTEER (youth participants who view, apply, and inquire).

> **Role protection:** The system includes a `prevent_role_escalation()` PostgreSQL trigger that prevents any user except SUPERADMIN from changing another user's role or account status, ensuring security at the database level.

---

## Copy of Tab 1 — Data Dictionary Tables (These are the older version tables. If keeping both tabs, update Copy of Tab 1 with the same corrections as Tab 1 above. Key differences to fix in Copy of Tab 1:)

1. **User_Tbl role**: Change `ENUM(SK_OFFICIAL, YOUTH_VOLUNTEER)` → `VARCHAR(20): 'SUPERADMIN', 'CAPTAIN', 'SK_OFFICIAL', 'YOUTH_VOLUNTEER'`
2. **User_Tbl**: Add `gender VARCHAR(20) NULLABLE` column
3. **SK_Tbl position**: Remove `SK_AUDITOR` from enum, add `termStart DATE`, `termEnd DATE`
4. **Project_Tbl**: This old single-table design has been replaced by Pre_Project_Tbl + Post_Project_Tbl split (already in Tab 1)
5. **Content_Tbl**: Renamed to `Announcement_Tbl` in current system
6. **OTP**: Add `purpose` column with values `'LOGIN', 'FORGOT_PASSWORD', 'SIGN_UP'` (replaces old `LOGIN, FORGET, SIGN-UP`)
7. **Inquiry_Tbl**: `projectID` → `preProjectID`
8. **Application_Tbl**: `projectID` → `preProjectID`, add `attended BOOLEAN DEFAULT FALSE`
