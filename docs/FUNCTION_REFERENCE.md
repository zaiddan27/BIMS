# BIMS Complete Function Reference

> Every JavaScript function across all 23 pages and shared modules, with descriptions and page-level flow explanations.

---

## Table of Contents

1. [Authentication Pages](#1-authentication-pages)
2. [SK Official Pages](#2-sk-official-pages)
3. [Youth Volunteer Pages](#3-youth-volunteer-pages)
4. [Captain Dashboard](#4-captain-dashboard)
5. [Superadmin Pages](#5-superadmin-pages)
6. [Shared Components](#6-shared-components)

---

## 1. Authentication Pages

### login.html

| Function | Description |
|----------|-------------|
| isValidEmail() | Validates email format using regex pattern |
| isValidPassword() | Checks if password meets minimum 8 character requirement |
| setInputState() | Applies validation visual states (error/success border + icon) to form inputs |
| signInWithGoogle() | Initiates Google OAuth sign-in flow via Supabase |
| Email blur handler | Real-time email validation on field blur |
| Password blur handler | Real-time password validation on field blur |
| Email input handler | Clears error state when user starts typing |
| Password input handler | Clears error state when user starts typing |
| Form submit handler | Main login: validates inputs, checks lockout, calls Supabase auth, verifies account status, redirects by role |

**How they work together:** When the page loads, blur handlers attach to email/password fields for real-time validation using isValidEmail() and isValidPassword(), with setInputState() providing visual feedback. On form submit, the handler first validates both fields, then checks localStorage for login lockout (5 attempts = 15-min lock). If clear, it calls Supabase signInWithPassword(). On success, it queries User_Tbl for role and accountStatus, checks profile completeness, and redirects to the appropriate dashboard. On failure, it increments the attempt counter. signInWithGoogle() bypasses this flow entirely, handing off to Google OAuth.

---

### signup.html

| Function | Description |
|----------|-------------|
| isValidEmail() | Validates email format using regex |
| isValidPassword() | Validates password complexity (8+ chars, uppercase, lowercase, digit, special char) |
| updatePasswordRequirements() | Updates UI checklist showing which of the 5 password requirements are met |
| isValidName() | Checks if name is at least 2 characters |
| formatName() | Converts names to Title Case (e.g., "john doe" to "John Doe") |
| setInputState() | Applies validation visual states (error/success) to form inputs |
| signUpWithGoogle() | Initiates Google OAuth sign-up flow via Supabase |
| First name blur handler | Validates first name on blur |
| Last name blur handler | Validates last name on blur |
| Email blur handler | Validates email format on blur |
| Password input handler | Real-time password complexity check with visual checklist |
| Password blur handler | Final password validation on blur |
| Confirm password blur handler | Validates passwords match on blur |
| Clear error handlers | Remove error styling when user starts typing in any field |
| Form submit handler | Validates all fields, formats names, creates Supabase auth user with metadata |

**How they work together:** Each form field has a blur handler that validates using isValidName(), isValidEmail(), or isValidPassword(), with setInputState() showing green/red borders. The password field additionally triggers updatePasswordRequirements() on every keystroke, giving a live checklist of the 5 complexity rules. On form submit, the handler re-validates everything, calls formatName() on names for Title Case, then creates the auth user via Supabase with role=YOUTH_VOLUNTEER in metadata. A DB trigger auto-creates the User_Tbl row. On success, the email is stored in sessionStorage and the user is redirected to verify-otp.html.

---

### verify-otp.html

| Function | Description |
|----------|-------------|
| OTP input handler | Auto-focuses next input on digit entry, enforces numeric-only |
| OTP keydown handler | Handles backspace to navigate to previous input |
| OTP paste handler | Extracts digits from clipboard and fills all 6 OTP inputs |
| updateTimer() | Updates 10-minute countdown timer display (MM:SS format) |
| OTP form submit handler | Concatenates 6 digits, verifies OTP with Supabase, redirects to login |
| Resend button handler | Resends verification email with 60-second cooldown between sends |

**How they work together:** On page load, the email is read from sessionStorage and the 10-minute countdown starts via updateTimer() running every second. The 6 OTP input fields work as a unit: typing a digit auto-advances focus, backspace goes back, and pasting fills all fields at once. On form submit, the 6 digits are concatenated and sent to supabaseClient.auth.verifyOtp() with type 'email'. Success clears sessionStorage and redirects to login. The resend handler re-calls supabase.auth.resend() but enforces a 60-second cooldown to prevent spam.

---

### forgot-password.html

| Function | Description |
|----------|-------------|
| isValidEmail() | Validates email format using regex |
| setInputState() | Applies validation visual states to email input |
| Email blur handler | Real-time email validation on blur |
| Email input handler | Clears error state on input |
| Form submit handler | Validates email, checks rate limit via RPC, checks account status via RPC, sends reset OTP |

**How they work together:** The email field validates on blur using isValidEmail() with setInputState() for visual feedback. On form submit, the handler first validates the email, then calls two server-side RPCs: check_password_reset_allowed() (max 3 resets per 15 min) and check_account_status() (ensures account exists and is ACTIVE). If both pass, it sends a recovery OTP via Supabase. A generic success message is always shown regardless of email existence to prevent email enumeration. The email is stored in sessionStorage for reset-password.html.

---

### reset-password.html

| Function | Description |
|----------|-------------|
| OTP input handler | Auto-focuses next input, enforces numeric-only |
| OTP keydown handler | Handles backspace to navigate to previous input |
| OTP paste handler | Fills all 6 inputs from clipboard paste |
| updateTimer() | 10-minute countdown timer for OTP expiry |
| OTP form submit handler | Verifies recovery OTP with Supabase, reveals password form |
| Resend button handler | Resends recovery OTP with 60-second cooldown |
| isValidPassword() | Validates password complexity (5 requirements) |
| updatePasswordRequirements() | Live checklist of password requirements as user types |
| setInputState() | Applies validation visual states to password inputs |
| Password input handler | Real-time complexity check on keystroke |
| Password blur handler | Final validation on blur |
| Confirm password blur handler | Validates passwords match |
| Confirm password input handler | Clears error state on input |
| Password form submit handler | Updates password via Supabase, signs out user, redirects to login |

**How they work together:** This page has two phases. Phase 1 (OTP verification): identical OTP input system as verify-otp.html with 10-minute timer. On successful verifyOtp() with type 'recovery', the OTP form hides and the password form appears. Phase 2 (new password): password input triggers updatePasswordRequirements() on every keystroke for a live checklist. On submit, the handler validates both password fields, calls supabaseClient.auth.updateUser() to set the new password, then signs out the user and redirects to login.html for a fresh login.

---

### complete-profile.html

| Function | Description |
|----------|-------------|
| loadUserData() | Loads current user session data and pre-fills form with existing profile fields |
| formatName() | Converts names to Title Case format |
| Form submit handler | Validates all required fields (name, birthday, contact, gender, address), updates User_Tbl, redirects to dashboard |
| DOMContentLoaded handler | Triggers loadUserData() on page initialization |

**How they work together:** On DOMContentLoaded, loadUserData() fetches the current session and queries User_Tbl to pre-fill any existing data (e.g., name from signup, Google avatar). The form requires: first/last name (2+ chars), birthday (age 15+), contact (09XXXXXXXXX format), gender, and address (10+ chars). On submit, all fields are validated, names are formatted via formatName(), and User_Tbl is updated. The profile_incomplete flag is cleared from sessionStorage and the user is redirected to their role-appropriate dashboard via SessionManager.redirectByRole().

---

### index.html (Public Landing Page)

| Function | Description |
|----------|-------------|
| sanitizeImageURL() | Validates image URLs against whitelist of allowed domains |
| formatCurrency() | Formats numbers as Philippine Peso currency |
| formatDate() | Formats date strings to readable format |
| filterProjects() | Filters project cards by status (all/ongoing/completed) |
| loadProjects() | Fetches APPROVED projects from Pre_Project_Tbl |
| renderProjectPage() | Renders current page of project cards to DOM |
| updateProjectPagination() | Updates pagination dots and prev/next button states |
| navigateProjectPage() | Navigates to next/previous project page |
| goToProjectPage() | Navigates to specific project page by index |
| createProjectCard() | Builds HTML card for a single project with status badge and details |
| getPerSlide() | Calculates testimonials per carousel slide based on screen width |
| generateStars() | Creates star rating SVG HTML from numeric rating |
| createTestimonyCard() | Builds HTML card for a testimony with avatar, stars, and preview text |
| openTestimonyModal() | Opens modal showing full testimony text and details |
| closeTestimonyModal() | Closes testimony detail modal |
| initCarousel() | Initializes testimony carousel with slides, dots, and 5-second auto-advance |
| goToSlide() | Navigates carousel to specific slide index |
| nextTestimonial() | Advances carousel to next slide |
| prevTestimonial() | Moves carousel to previous slide |
| startAutoSlide() | Starts 5-second auto-advance interval for carousel |
| resetAutoSlide() | Restarts auto-slide timer after user interaction |
| loadTestimonials() | Fetches featured testimonials (isFiltered=true) with user data |
| loadBudgetData() | Fetches annual budget categories and renders progress bars |
| loadProjectMetrics() | Calculates project stats (total, completed, success rate, volunteers) |
| loadPublishedFiles() | Fetches published files (isPublished=true) from File_Tbl |
| downloadFile() | Triggers browser download using Supabase storage public URL |
| DOMContentLoaded handler | Initializes all sections in parallel: projects, testimonials, budget, metrics, files |
| Google OAuth callback handler | Processes Google OAuth redirect, creates/validates User_Tbl record |
| Carousel hover handlers | Pauses auto-slide on hover, resumes on leave |
| Window resize handler | Recalculates carousel slides per view on resize |

**How they work together:** On DOMContentLoaded, five data loaders run in parallel: loadProjects(), loadTestimonials(), loadBudgetData(), loadProjectMetrics(), and loadPublishedFiles(). Each fetches from Supabase and renders its section independently. Projects use a paginated grid where filterProjects() filters by status, renderProjectPage() draws the current page, and navigation functions handle pagination. Testimonials use a carousel system: loadTestimonials() fetches featured ones, initCarousel() sets up slides (responsive via getPerSlide()), and startAutoSlide() advances every 5 seconds. The Google OAuth handler runs separately to process redirects from Google sign-in, creating User_Tbl records for new users.

---

### js/auth/session.js (SessionManager)

| Method | Description |
|--------|-------------|
| init(allowedRoles) | Validates auth session, checks role against allowed list, verifies account status, checks profile completeness |
| setupIdleTimeout() | Monitors mouse/keyboard/scroll activity, auto-logs out after 30 minutes idle |
| setupAuthListener() | Listens for Supabase auth state changes (SIGNED_OUT) and clears session |
| requireAuth(allowedRoles) | Enforces authentication; redirects to login if no valid session |
| redirectToLogin(message, redirect) | Redirects to login.html with optional error message and return URL |
| redirectByRole(role) | Sends user to their role-specific dashboard URL |
| getRoleDashboard(role) | Returns the dashboard URL string for a given role |
| getSession() | Retrieves current Supabase session object |
| logout() | Signs out via Supabase, clears all localStorage keys, redirects to login |
| getUserRole() | Returns cached user role from localStorage |
| getUserName() | Returns cached user display name from localStorage |
| getUserEmail() | Returns cached user email from localStorage |
| hasRole(roles) | Checks if current user's role matches any in the provided array |
| updateUserProfile() | Updates header UI elements (name, avatar) with current user data |

**How they work together:** Every protected page imports SessionManager and calls init(allowedRoles) on load. init() first calls getSession() to check for a valid Supabase token. If no session, redirectToLogin() fires. If session exists, it queries User_Tbl to verify the user's role is in allowedRoles and accountStatus is ACTIVE. If the profile is incomplete, it redirects to complete-profile.html. Once authenticated, setupIdleTimeout() starts monitoring for 30 minutes of inactivity, and setupAuthListener() watches for external sign-outs. The getter methods (getUserRole, getUserName, getUserEmail) read from localStorage for fast access without DB queries. logout() clears everything and redirects to login.

---

## 2. SK Official Pages

### sk-dashboard.html

| Function | Description |
|----------|-------------|
| initializeDashboard() | Auth check, loads all dashboard data in parallel |
| sanitizeImageURL() | Validates and sanitizes image URLs for security |
| validateImageFile() | Validates image file type and size before upload |
| updateUserProfile() | Updates header with user name, role, and avatar |
| loadAnnouncements() | Fetches all announcements from Announcement_Tbl |
| renderAnnouncements() | Renders announcement cards with pagination (3 per page) |
| updateAnnouncementPagination() | Creates pagination dots and updates nav button states |
| navigateAnnouncements() | Navigates between announcement pages forward/backward |
| goToAnnouncementPage() | Jumps to specific announcement page by index |
| openCreateModal() | Opens announcement creation modal |
| closeCreateModal() | Closes creation modal |
| postAnnouncement() | Creates new announcement with optional image upload to storage |
| openEditModal() | Opens edit modal pre-filled with announcement data |
| closeEditModal() | Closes edit modal |
| saveEdit() | Saves edited announcement changes to database |
| viewAnnouncement() | Opens read-only modal with full announcement details |
| closeViewModal() | Closes view modal |
| confirmDelete() | Shows delete confirmation modal |
| closeDeleteModal() | Closes delete confirmation |
| deleteAnnouncement() | Permanently removes announcement from database |
| openCropperModal() | Opens Cropper.js image editor for announcement images |
| closeCropperModal() | Closes cropper and cleans up instance |
| cropAndUploadImage() | Crops selected image and prepares for upload |
| loadDashboardStatistics() | Runs 4 parallel count queries (files, announcements, projects, volunteers) |
| loadProjectMetrics() | Calculates current year project stats and success rate |
| updateMetricsDisplay() | Renders project metrics in stat cards |
| loadBudgetData() | Loads budget allocation from localStorage |
| updateBudgetDisplay() | Renders budget categories with progress bars |
| editBudgetAllocation() | Opens budget category editing interface |
| closeBudgetEditModal() | Closes budget edit modal |
| renderBudgetCategoriesEdit() | Renders editable budget category rows |
| addBudgetCategory() | Adds new budget category row |
| removeBudgetCategory() | Removes budget category by ID |
| updateCategoryName() | Updates a budget category's name |
| updateCategoryAmount() | Updates a budget category's amount |
| updateEditBudgetTotal() | Recalculates total budget in edit mode |
| saveBudgetAllocation() | Saves budget allocation to localStorage |
| viewBudgetHistory() | Displays budget change history |
| showConfirm() | Generic confirmation dialog with customizable buttons |
| formatRelativeDate() | Formats dates as relative time ("2 days ago") |
| updateCharCount() | Live character counter for text inputs |
| setInputState() | Validation visual states for inputs |
| updateCurrentDate() | Updates displayed current date in header |
| addActivityLog() | Logs user activity action |
| handleLogout() | Signs out user and redirects |

**How they work together:** initializeDashboard() orchestrates the page: it checks auth via SessionManager, then fires loadAnnouncements(), loadDashboardStatistics(), and loadProjectMetrics() in parallel. Announcements follow a full CRUD flow: openCreateModal() collects data, optionally runs through openCropperModal() for image editing, and postAnnouncement() uploads the image to storage then inserts the record. Edit/delete follow similar modal patterns. The 4 stat cards update via loadDashboardStatistics() which counts files, announcements, projects, and volunteers in parallel. Budget is managed client-side in localStorage with its own edit/save flow. All user actions trigger addActivityLog() for audit trail.

---

### sk-files.html

| Function | Description |
|----------|-------------|
| initializePage() | Auth check, loads files and initializes UI |
| sanitizeFileURL() | Validates file URLs against Supabase domain whitelist |
| updateHeaderUserInfo() | Updates header with user name, role, avatar |
| loadFiles() | Fetches ACTIVE files from File_Tbl with filters |
| showLoadingSkeleton() | Shows/hides loading placeholder animation |
| renderFiles() | Renders file cards grid with type-specific icons |
| formatDate() | Formats date to short format (Jan 15, 2025) |
| formatDateLong() | Formats date to long format (January 15, 2025) |
| updateFilePagination() | Creates pagination dots for file grid |
| navigateFiles() | Navigates between file pages |
| goToFilePage() | Jumps to specific file page |
| applyFilters() | Applies search text and category filter to file list |
| openUploadModal() | Opens file upload modal |
| closeUploadModal() | Closes upload modal |
| resetUploadForm() | Resets upload form to initial state |
| uploadFile() | Uploads file to Supabase storage, inserts File_Tbl record with progress bar |
| viewFile() | Opens file preview modal (PDF.js for PDFs, img for images) |
| renderPDFPreview() | Renders PDF first page on canvas using PDF.js library |
| showFileIconFallback() | Shows file type icon for unsupported preview types |
| closeFileModal() | Closes file preview modal |
| archiveFile() | Soft-deletes file by setting status to ARCHIVED |
| closeArchiveFileModal() | Closes archive confirmation modal |
| promptDeleteFile() | Shows permanent delete confirmation |
| closeDeleteFileModal() | Closes delete confirmation modal |
| togglePublish() | Toggles file published status (visible on landing page) |
| closePublishModal() | Closes publish confirmation modal |
| confirmUnpublish() | Executes file unpublish operation |
| showFileToast() | Shows toast notification for file operations |
| updateCurrentDate() | Updates displayed current date |
| handleLogout() | Signs out user and redirects |

**How they work together:** initializePage() authenticates then calls loadFiles() which queries File_Tbl for ACTIVE files. renderFiles() draws the paginated grid with type-specific icons (PDF=red, XLSX=green, DOC=blue, image=purple). The upload flow starts at openUploadModal(), validates file type/size, then uploadFile() uploads to Supabase storage with a simulated progress bar and inserts the DB record. viewFile() opens a preview modal that renders PDFs using PDF.js's renderPDFPreview() or shows images directly, with showFileIconFallback() for unsupported types. Files can be published (visible on index.html), archived (moved to sk-archive.html), or permanently deleted. applyFilters() handles real-time search and category filtering client-side.

---

### sk-projects.html

| Function | Description |
|----------|-------------|
| initializePage() | Auth check, loads projects, SK officials, sets up realtime subscription |
| sanitizeImageURL() | Validates image URLs for security |
| updateCurrentDate() | Updates displayed current date |
| loadSKOfficials() | Loads SK officials list for project head dropdown |
| loadCurrentUserSKData() | Loads current user's SK position data |
| updateHeaderUserInfo() | Updates header with name, role, avatar |
| loadProjects() | Fetches all projects with nested applications, inquiries, budget data |
| populateCategoryFilter() | Populates category filter dropdown from project data |
| loadProjectApplications() | Reloads applications for a specific project after status change |
| loadProjectInquiries() | Loads inquiries for a specific project |
| loadProjectBudgetBreakdown() | Loads budget breakdown for a specific project |
| formatTimeAgo() | Formats timestamps as relative time ("2h", "3d") |
| showLoadingSkeleton() | Shows/hides loading skeleton placeholders |
| isCurrentUserProjectHead() | Checks if current user is head of a specific project |
| generateAttendancePDF() | Generates attendance report as downloadable PDF |
| renderProjects() | Renders paginated project cards with stats |
| navigateProjects() | Navigates between project pages |
| updatePaginationDots() | Updates pagination dot indicators |
| goToPage() | Jumps to specific project page |
| viewProject() | Opens project detail modal with tabs |
| closeProjectView() | Closes project detail modal |
| switchTab() | Switches between Details, Applicants, Inquiries, Feedback tabs |
| loadFeedbackTab() | Fetches and renders evaluation/survey data for feedback tab |
| loadApplicants() | Renders applicant cards with attendance checkboxes |
| getFilteredApplicants() | Filters applicants by status |
| filterApplicants() | Applies applicant filter and re-renders |
| toggleAttendance() | Toggles volunteer attendance checkbox in database |
| loadInquiries() | Renders inquiry cards with reply threads |
| viewApplicant() | Opens applicant detail modal with personal info and feedback |
| closeApplicantModal() | Closes applicant modal |
| updateStatus() | Updates application status (approve/reject/pending) with assigned role and notification |
| editProject() | Opens project edit modal pre-filled with current data |
| loadBudgetBreakdownForEdit() | Loads budget items for editing |
| closeProjectModal() | Closes project edit/create modal |
| cancelProjectApproval() | Cancels pending approval and returns to draft |
| closeCancelApprovalModal() | Closes cancel approval confirmation |
| confirmCancelApproval() | Executes approval cancellation |
| addBudgetRow() | Adds new budget breakdown row in editor |
| removeBudgetRow() | Removes budget breakdown row |
| updateBudgetItem() | Updates budget item field value |
| renderBudgetBreakdown() | Renders budget breakdown table in editor |
| updateBudgetTotal() | Recalculates budget total from breakdown |
| updateBudgetRemaining() | Calculates remaining budget from breakdown |
| clearBudgetBreakdown() | Clears all budget rows |
| autoFillBudgetFromCaptain() | Pre-fills budget from captain-approved amount |
| renderHeadsPills() | Renders selected project heads as removable pill tags |
| removeHead() | Removes a project head from selection |
| openHeadsDropdown() | Opens project heads search dropdown |
| renderHeadsDropdown() | Renders available heads in dropdown filtered by search |
| saveProjectBtn handler | Validates and saves project (create or update) with budget and heads |
| saveBudgetBreakdownItems() | Saves new budget breakdown items to database |
| updateBudgetBreakdownItems() | Updates existing budget breakdown items |
| createCaptainNotification() | Creates notification for captain about new/resubmitted project |
| sendInquiryReply() | Sends reply to a project inquiry |
| applyFilters() | Applies search text and category filter to projects |
| showConfirm() | Generic confirmation dialog |
| displayCaptainDecision() | Shows captain's approval/rejection/revision decision |
| handleURLParameters() | Processes URL params for deep linking from notifications |
| openEvaluationModal() | Opens project completion evaluation form |
| closeEvaluationModal() | Closes evaluation modal |
| renderVolunteerFeedback() | Renders volunteer survey feedback in evaluation |
| showAchievementSuggestions() | Shows autocomplete for achievement text |
| selectAchievementSuggestion() | Selects suggested achievement |
| addQuickAchievement() | Adds achievement from category button |
| addAchievement() | Adds new achievement to evaluation list |
| removeAchievement() | Removes achievement from list |
| renderAchievementsList() | Renders achievements list in form |
| loadActualBreakdownFromPlanned() | Loads actual budget from planned breakdown |
| renderActualBreakdownTable() | Renders actual spending table |
| addActualBreakdownRow() | Adds row to actual breakdown |
| updateActualBreakdownDescription() | Updates actual item description |
| updateActualBreakdownCost() | Updates actual item cost |
| deleteActualBreakdownRow() | Deletes actual breakdown row |
| uploadReceipt() | Uploads receipt image for budget item |
| removeReceipt() | Removes uploaded receipt |
| viewReceiptImage() | Displays receipt in modal |
| updateActualBreakdownTotals() | Recalculates actual spending totals |
| updateActualTotalFromBreakdown() | Updates total from breakdown items |
| calculateSuccessRate() | Calculates project success rate (attendance + budget + feedback + achievements) |
| submitEvaluation() | Submits project completion evaluation to database |
| startProject() | Changes project status from upcoming to ongoing |
| archiveProject() | Archives completed project to Post_Project_Tbl |
| checkAutoArchive() | Checks and auto-archives old completed projects |
| openDownloadReportModal() | Opens report format selection modal |
| closeDownloadReportModal() | Closes report modal |
| downloadReport() | Downloads project report in selected format |
| uploadAttendancePDF() | Uploads attendance PDF file |
| handleLogout() | Signs out user and redirects |

**How they work together:** initializePage() authenticates, then loads projects (with nested applications, inquiries, budget), SK officials list, and sets up a realtime Supabase subscription for new applications. The main view is a paginated card grid via renderProjects(). Clicking a card opens viewProject() with 4 tabs: Details (project info + captain decision), Applicants (cards with attendance checkboxes via loadApplicants()), Inquiries (threaded conversations via loadInquiries()), and Feedback (survey results via loadFeedbackTab()). The applicant flow: viewApplicant() shows details, updateStatus() approves/rejects with an assigned role and sends a professional notification. Project CRUD: editProject() pre-fills the form, the save handler persists to Pre_Project_Tbl including projectHeads and budget breakdown. The evaluation flow: openEvaluationModal() loads volunteer feedback, achievements, and actual spending, then calculateSuccessRate() computes the score and submitEvaluation() saves everything. archiveProject() moves completed projects to Post_Project_Tbl.

---

### sk-testimonies.html

| Function | Description |
|----------|-------------|
| initializeTestimonies() | Auth check, loads testimonies and UI |
| sanitizeImageURL() | Validates image URLs for security |
| formatDate() | Formats date to display format |
| updateUserProfile() | Updates header with user profile data |
| loadTestimonies() | Fetches testimonies from Testimonies_Tbl with User_Tbl join |
| renderTestimonies() | Renders testimony cards with search/filter applied |
| navigateTestimonies() | Navigates between testimony pages |
| updatePaginationControls() | Updates pagination UI |
| goToPage() | Jumps to specific page |
| updateStats() | Updates total and featured testimony counts |
| filterTestimonies() | Switches between "All" and "Featured" filter |
| searchTestimonies() | Filters testimonies by name/project/text |
| viewTestimony() | Opens detail modal with full testimony text |
| closeViewModal() | Closes testimony view modal |
| deleteTestimony() | Permanently removes testimony after confirmation |
| toggleFeature() | Toggles testimony featured status (isFiltered flag) |
| showFeatureInfoModal() | Educational modal explaining what featuring does |
| showConfirm() | Generic confirmation dialog |
| updateCurrentDate() | Updates current date display |
| handleLogout() | Signs out and redirects |

**How they work together:** initializeTestimonies() authenticates then calls loadTestimonies() which fetches all testimonies with joined user data. renderTestimonies() draws the cards with search and filter applied. The two key actions: toggleFeature() sets isFiltered=true/false (featured testimonies appear on index.html carousel), showing showFeatureInfoModal() for first-time education. deleteTestimony() permanently removes after showConfirm(). filterTestimonies() toggles between all/featured view, searchTestimonies() does client-side text matching, and updateStats() keeps the count badges current.

---

### sk-calendar.html

| Function | Description |
|----------|-------------|
| initializeCalendar() | Auth check, loads events, sets up sidebar refresh interval |
| sanitizeImageURL() | Validates image URLs for security |
| updateUserProfile() | Updates header with user data |
| loadEventsFromDatabase() | Fetches approved projects + announcements as calendar events |
| renderCalendar() | Renders month view grid with event pills |
| createDayCell() | Creates individual day cell HTML with event indicators |
| getEventsForDate() | Returns all events for a specific date |
| renderWeekView() | Renders 7-day hourly grid (8 AM - 6 PM) |
| renderDayView() | Renders single day with full event details |
| previousMonth() | Navigates to previous period (adapts to current view) |
| nextMonth() | Navigates to next period |
| goToToday() | Jumps to current date |
| updateHeaderLabel() | Updates month/year header text |
| setView() | Switches between month/week/day views |
| renderUpcomingProjects() | Renders 3 upcoming projects in sidebar |
| renderRecentAnnouncements() | Renders 3 recent announcements in sidebar |
| openEventModal() | Opens event detail modal with calendar integration links |
| closeEventModal() | Closes event modal |
| generateICS() | Generates iCalendar (.ics) content for multiple events |
| generateEventICS() | Generates iCalendar content for a single event |
| downloadICS() | Triggers .ics file download |
| exportCalendar() | Exports all events as single .ics file |
| exportSingleEvent() | Exports one event as .ics file |
| getAddToCalendarLinks() | Generates Google Calendar, Outlook, Office 365, Yahoo URLs |
| toggleNotificationModal() | Toggles notification panel |
| openProfileModal() | Opens profile editing modal |
| handleLogout() | Signs out and redirects |

**How they work together:** initializeCalendar() authenticates then calls loadEventsFromDatabase() which fetches approved projects (green) and announcements (blue) from Supabase. The default month view renders via renderCalendar() which calls createDayCell() for each day and getEventsForDate() to place event pills. setView() switches to renderWeekView() (hourly grid) or renderDayView() (full details). Navigation functions (previousMonth, nextMonth, goToToday) adapt to the current view. The sidebar refreshes periodically via renderUpcomingProjects() and renderRecentAnnouncements(). openEventModal() shows event details with calendar integration: getAddToCalendarLinks() generates URLs for Google/Outlook/Office365/Yahoo, and exportSingleEvent() generates a downloadable .ics file.

---

### sk-archive.html

| Function | Description |
|----------|-------------|
| loadArchivedProjects() | Fetches archived projects from Post_Project_Tbl with full data |
| updateOverviewStats() | Updates archive overview statistics display |
| renderProjects() | Renders archived project cards |
| getSuccessBadgeClass() | Returns CSS class for success rate badge color |
| getSuccessBarClass() | Returns CSS class for success rate progress bar |
| switchQuarter() | Switches displayed quarter filter |
| attachFilterListeners() | Attaches event listeners to all filter controls |
| applyFilters() | Applies category, status, and sort filters |
| updateQuarterSummary() | Updates quarter statistics summary |
| resetFilters() | Resets all project filters |
| resetFileFilters() | Resets all file filters |
| viewProject() | Opens archived project detail modal with full data |
| confirmPermanentDelete() | Shows permanent delete confirmation with checkbox |
| closeDeleteModal() | Closes delete confirmation |
| executeDelete() | Permanently deletes archived project from database |
| unarchiveProject() | Restores archived project back to active |
| updateDeleteButtonState() | Enables/disables delete button based on confirmation checkbox |
| closeModal() | Closes project view modal |
| toggleDownloadMenu() | Toggles export format dropdown menu |
| exportProject() | Routes export to correct format handler |
| exportAsPDF() | Generates comprehensive project report as PDF with page breaks |
| exportAsText() | Exports project details as plain text file |
| exportAsCSV() | Exports project data as CSV file |
| toggleProjectSelection() | Toggles project selection for bulk operations |
| updateSelectedCount() | Updates selected projects count badge |
| selectAllFiltered() | Selects all currently visible projects |
| deselectAll() | Deselects all selected projects |
| generateBulkReports() | Generates reports for all selected projects |
| showConfirm() | Generic confirmation dialog |
| updateCurrentDate() | Updates current date display |
| openProfileModal() | Opens profile editing modal |
| closeProfileModal() | Closes profile modal |
| handleProfilePictureChange() | Handles profile picture upload |
| updateHeaderAvatar() | Updates header avatar image |
| saveProfile() | Saves profile changes to database |
| sanitizeFileURL() | Validates file URLs |
| formatFileDate() | Formats file dates |
| loadArchivedFiles() | Loads archived files from File_Tbl |
| updateFilesCount() | Updates archived files count display |
| switchArchiveType() | Switches between Projects and Files archive tabs |
| renderArchivedFiles() | Renders archived file cards |
| viewArchivedFile() | Opens archived file preview modal |
| showArchivedFileIconFallback() | Shows file type icon for unsupported types |
| renderArchivedPdfPreview() | Renders PDF preview for archived file |
| closeViewArchivedFileModal() | Closes archived file preview |
| restoreFile() | Restores archived file to active |
| closeRestoreFileModal() | Closes restore confirmation |
| confirmRestoreFile() | Executes file restore |
| deleteArchivedFile() | Shows delete confirmation for archived file |
| closeDeleteArchivedFileModal() | Closes file delete confirmation |
| confirmDeleteArchivedFile() | Permanently deletes archived file |
| handleLogout() | Signs out and redirects |

**How they work together:** The page has two tabs: Projects and Files, switched via switchArchiveType(). For projects: loadArchivedProjects() fetches from Post_Project_Tbl with full data including applications, budget, and achievements. renderProjects() draws cards with success rate badges (color-coded via getSuccessBadgeClass()). viewProject() opens a comprehensive detail modal showing all project data. Projects can be permanently deleted (confirmPermanentDelete() with checkbox safety) or restored (unarchiveProject()). Export functions generate reports in PDF/Text/CSV formats, with bulk export via generateBulkReports(). For files: loadArchivedFiles() fetches files with status ARCHIVED, with restore and delete capabilities mirroring the project flow.

---

## 3. Youth Volunteer Pages

### youth-dashboard.html

| Function | Description |
|----------|-------------|
| sanitizeImageURL() | Validates image URLs against allowed domains |
| loadUserProfile() | Fetches current user's profile data from User_Tbl |
| updateProfileUI() | Updates UI with user name, role badge, and avatar |
| updateProfilePicture() | Updates header profile picture from user data |
| showFieldError() | Displays validation error message under a form field |
| clearFieldError() | Removes error message from a field |
| clearAllErrors() | Clears all validation errors on the form |
| validateField() | Validates individual form field against defined rules |
| setProfileFieldsState() | Enables or disables profile form fields for editing |
| enterEditMode() | Switches profile from view to edit mode, saves backup |
| cancelEdit() | Cancels editing and reverts to backed-up values |
| openProfileModal() | Opens profile editing modal dialog |
| closeProfileModal() | Closes profile modal without saving |
| handleProfilePictureChange() | Handles file input for new profile picture upload |
| saveProfile() | Validates all fields, uploads picture, updates User_Tbl |
| formatRelativeDate() | Formats dates as relative time ("2 days ago") |
| loadAnnouncements() | Fetches announcements from Announcement_Tbl |
| renderAnnouncements() | Renders announcement cards with pagination (3 per page) |
| updateAnnouncementPagination() | Creates pagination dots for announcements |
| navigateAnnouncements() | Navigates between announcement pages |
| goToAnnouncementPage() | Jumps to specific page |
| viewAnnouncement() | Opens announcement detail modal |
| closeAnnouncementModal() | Closes announcement modal |
| openAllAnnouncements() | Opens all-announcements view |
| openApplicationDetails() | Opens side drawer showing application details |
| closeAppDrawer() | Closes application details drawer |
| initializeStarRating() | Sets up interactive 5-star rating with hover effects |
| updateStarDisplay() | Highlights stars based on current rating |
| updateRatingText() | Shows rating label (Poor/Fair/Good/Very Good/Excellent) |
| updateCharCount() | Live character counter for feedback textarea (500 max) |
| setInputState() | Validation visual states for form inputs |
| showTestimonyConfirmation() | Shows preview modal before submitting feedback |
| resetTestimonyForm() | Clears all feedback form fields after submission |
| updateCurrentDate() | Updates date display |
| handleLogout() | Signs out and redirects |

**How they work together:** On load, loadUserProfile() fetches user data and updateProfileUI() renders the header. Profile editing uses a backup pattern: enterEditMode() saves current values, the user edits fields validated by validateField(), and saveProfile() uploads the picture and updates User_Tbl — or cancelEdit() restores the backup. Announcements load via loadAnnouncements() and render as paginated cards (read-only for youth). The testimony flow: initializeStarRating() sets up the interactive 5-star widget, updateCharCount() tracks the 500-char textarea, showTestimonyConfirmation() previews before submitting to Testimonies_Tbl, and resetTestimonyForm() clears everything after success. Application tracking via openApplicationDetails() shows a drawer with status badges.

---

### youth-projects.html

| Function | Description |
|----------|-------------|
| initializePage() | Auth check, loads projects and user applications |
| updateHeaderUserInfo() | Updates header with name and avatar |
| showLoadingSkeleton() | Shows/hides loading skeleton animation |
| loadProjects() | Fetches approved projects with inquiries from Supabase |
| populateCategoryFilter() | Populates category dropdown from project data |
| loadProjectInquiries() | Loads all inquiries for a specific project |
| loadInquiryReplies() | Loads replies for a specific inquiry |
| loadMyApplications() | Fetches current user's project applications |
| formatTimeAgo() | Formats timestamps as relative time |
| updateCurrentDate() | Updates date display |
| renderProjects() | Renders available project cards in paginated grid |
| navigateProjects() | Navigates between project pages |
| updatePaginationDots() | Updates pagination dot indicators |
| goToPage() | Jumps to specific page |
| viewProject() | Opens project detail view with tabs |
| closeProjectView() | Closes project detail view |
| switchTab() | Switches between Project Details and Inquiries tabs |
| loadInquiries() | Renders inquiry conversation threads |
| calculateAge() | Calculates age from birthday for parental consent |
| toggleParentalConsentSection() | Shows/hides parental consent upload based on age |
| openApplyModal() | Opens project application form |
| closeApplyModal() | Closes application form |
| submitApplication() | Validates and submits application to Application_Tbl |
| openEditApplicationModal() | Opens modal to edit a pending application |
| closeEditApplicationModal() | Closes edit application modal |
| saveEditedApplication() | Saves edited application changes |
| openInquiryModal() | Opens new inquiry submission form |
| closeInquiryModal() | Closes inquiry form |
| submitInquiry() | Submits new inquiry to Inquiry_Tbl |
| sendInquiryReply() | Sends reply to an existing inquiry |
| countUnreadReplies() | Counts unread inquiry replies |
| updateNotificationBadge() | Updates notification badge with unread count |
| showInquiryNotifications() | Opens modal showing unread inquiry notifications |
| closeNotificationsModal() | Closes notifications modal |
| showMyApplications() | Switches view to show user's applications |
| showProjectsView() | Switches view to show available projects |
| renderMyApplications() | Renders user's applications list (mobile/compact) |
| renderMyApplicationsGrid() | Renders applications in card grid with status badges and assigned roles |
| applyFilters() | Applies search text and category filter |
| handleURLParameters() | Processes URL params for deep linking from notifications |
| handleLogout() | Signs out and redirects |

**How they work together:** initializePage() authenticates, then loads projects (with inquiries) and the user's own applications in parallel. The main view shows available projects via renderProjects() as a paginated grid. Clicking a card opens viewProject() with two tabs: Project Details (info, heads, dates) and Inquiries (conversation threads loaded via loadInquiries()). The application flow: openApplyModal() shows the form, calculateAge() checks if parental consent is needed (under 18), and submitApplication() creates the Application_Tbl record. Pending applications can be edited via openEditApplicationModal(). The inquiry flow: openInquiryModal() submits new questions, sendInquiryReply() adds replies to threads, and countUnreadReplies() + updateNotificationBadge() track new responses. showMyApplications() toggles to the applications view where renderMyApplicationsGrid() shows cards with status badges, preferred role, and assigned role (if approved).

---

### youth-calendar.html

| Function | Description |
|----------|-------------|
| initializeCalendar() | Auth check, loads events, sets up sidebar refresh |
| sanitizeImageURL() | Validates image URLs |
| updateUserProfile() | Updates header with user data |
| loadEventsFromDatabase() | Fetches approved projects + announcements |
| renderCalendar() | Renders month view grid |
| createDayCell() | Creates individual day cell with event pills |
| getEventsForDate() | Returns events for a specific date |
| renderWeekView() | Renders 7-day hourly grid |
| renderDayView() | Renders single day event list |
| previousMonth() | Navigate to previous period |
| nextMonth() | Navigate to next period |
| goToToday() | Jump to current date |
| updateHeaderLabel() | Updates month/year header |
| setView() | Switches between month/week/day views |
| renderUpcomingProjects() | Sidebar: 3 upcoming projects |
| renderRecentAnnouncements() | Sidebar: 3 recent announcements |
| openEventModal() | Opens event details with calendar links |
| closeEventModal() | Closes event modal |
| generateICS() | Generates .ics content for multiple events |
| generateEventICS() | Generates .ics for single event |
| downloadICS() | Triggers .ics download |
| exportCalendar() | Exports all events as .ics |
| exportSingleEvent() | Exports single event as .ics |
| getAddToCalendarLinks() | Generates Google/Outlook/Office365/Yahoo URLs |
| toggleNotificationModal() | Toggles notification panel |
| openProfileModal() | Opens profile modal |
| handleLogout() | Signs out and redirects |
| updateCurrentDate() | Updates date display |

**How they work together:** Identical to sk-calendar.html but for youth role. initializeCalendar() authenticates for YOUTH_VOLUNTEER, loads events via loadEventsFromDatabase() (projects in green, announcements in blue). The three views (month/week/day) render the same event data differently. Calendar export generates standard .ics files compatible with all major calendar apps. Sidebar shows upcoming projects and recent announcements, refreshing periodically.

---

### youth-files.html

| Function | Description |
|----------|-------------|
| initializePage() | Auth check, loads files |
| sanitizeFileURL() | Validates file URLs against Supabase domain whitelist |
| updateHeaderUserInfo() | Updates header with user data |
| handleLogout() | Signs out and redirects |
| loadFiles() | Fetches ACTIVE files from File_Tbl (read-only) |
| formatDate() | Formats date to short format |
| formatDateLong() | Formats date to long format |
| renderFiles() | Renders file cards with type icons |
| getFilteredFiles() | Filters files by search and category |
| applyFilters() | Applies search and category filter |
| updateFilePagination() | Creates pagination dots |
| navigateFiles() | Navigates between file pages |
| goToFilePage() | Jumps to specific page |
| viewFile() | Opens file preview (PDF.js for PDFs, img for images) |
| renderPDFPreview() | Renders PDF first page on canvas |
| closeFileModal() | Closes preview modal |
| updateCurrentDate() | Updates date display |

**How they work together:** initializePage() authenticates then calls loadFiles() to fetch ACTIVE files. renderFiles() draws a paginated card grid — youth can only VIEW and DOWNLOAD, never upload or delete. viewFile() opens a preview modal: PDFs render via renderPDFPreview() using PDF.js, images display directly, and unsupported types show a "Preview not available" message with download option. applyFilters() handles real-time search by filename and category dropdown filtering, all client-side on the loaded array.

---

### youth-certificates.html

| Function | Description |
|----------|-------------|
| sanitizeImageURL() | Validates image URLs |
| loadCompletedProjects() | Fetches user's approved+attended applications with project data |
| renderProjects() | Renders project cards with survey status and action buttons |
| updateProjectPagination() | Creates pagination dots |
| navigateProjects() | Navigates between pages |
| goToProjectPage() | Jumps to specific page |
| openSurveyModal() | Opens 5-question satisfaction survey modal |
| closeSurveyModal() | Closes survey modal |
| calculateAverage() | Calculates live average from 5 slider values |
| submitSurvey() | Validates and submits survey to Evaluation_Tbl |
| viewCertificate() | Opens full-screen certificate preview with volunteer name and project |
| closeCertificateModal() | Closes certificate modal |
| initializeZoomControls() | Sets up mouse wheel, touch, and button zoom handlers |
| handleWheel() | Handles mouse wheel zoom events |
| handleTouchStart() | Handles touch start for pinch-to-zoom |
| handleTouchMove() | Handles touch move for pinch zoom |
| handleTouchEnd() | Finalizes touch zoom |
| handleMouseDown() | Handles mouse down for pan/drag |
| handleMouseMove() | Handles mouse move for panning |
| handleMouseUp() | Stops panning on mouse up |
| getDistance() | Calculates distance between two touch points |
| zoomIn() | Zooms certificate in by 0.25 |
| zoomOut() | Zooms certificate out by 0.25 |
| resetZoom() | Resets zoom to 100% |
| applyZoom() | Applies CSS transform for current zoom level |
| showTouchHint() | Shows brief hint about touch gestures on mobile |
| downloadCertificate() | Captures certificate as PDF via html2canvas + jsPDF |
| updateCurrentDate() | Updates date display |
| handleLogout() | Signs out and redirects |

**How they work together:** loadCompletedProjects() fetches applications where status=APPROVED and attended=true, joining project data. renderProjects() shows three card states: "Survey Pending" (openSurveyModal() available), "Waiting for Completion" (project still ongoing), or "Certificate Ready" (viewCertificate() available). The survey flow: openSurveyModal() presents 5 sliders (1-5), calculateAverage() updates the live score as sliders move, and submitSurvey() inserts into Evaluation_Tbl then auto-opens the certificate. The certificate viewer: viewCertificate() populates the certificate with the volunteer's name and project, initializeZoomControls() sets up desktop (wheel + drag) and mobile (pinch + pan) interactions with 50%-300% range. downloadCertificate() uses html2canvas to capture the certificate element and jsPDF to save as a landscape A4 PDF.

---

## 4. Captain Dashboard

### captain-dashboard.html

| Function | Description |
|----------|-------------|
| initializePage() | Auth check for CAPTAIN role, loads all dashboard data |
| sanitizeImageURL() | Validates image URLs |
| loadCaptainData() | Fetches captain profile and project statistics |
| updateHeaderUserInfo() | Updates header with captain name and avatar |
| openProfileModal() | Opens captain profile editing modal |
| closeProfileModal() | Closes profile modal |
| handleProfilePictureChange() | Handles profile picture file selection and preview |
| updateHeaderAvatar() | Updates header avatar image |
| saveProfile() | Saves profile changes to database |
| openChangePasswordModal() | Opens password change modal |
| closeChangePasswordModal() | Closes password modal |
| updatePassword() | Validates and updates password via Supabase auth |
| formatDate() | Formats date to readable format |
| calculateTimeRemaining() | Calculates years/days remaining in captain's term |
| updateStatistics() | Calculates pending/approved/rejected project counts |
| renderProjects() | Renders project cards for all status tabs |
| renderTabProjects() | Renders paginated project cards for a specific status |
| renderPagination() | Creates pagination dots for project list |
| goToPage() | Navigates to specific project page |
| navigatePage() | Navigates forward/backward through pages |
| renderProjectCard() | Generates HTML card for single project with badges |
| calculateDuration() | Calculates project duration in days |
| switchTab() | Switches between pending/approved/rejected tabs |
| viewProjectDetails() | Opens full project detail modal |
| renderBudgetBreakdown() | Renders project budget items table |
| closeModal() | Closes project detail modal |
| reviewDecision() | Shows approve/reject/revise action buttons |
| approveProject() | Approves project with confirmation and professional notification |
| rejectProject() | Rejects project with reason and professional notification |
| requestRevision() | Requests project revision with feedback and notification |
| showConfirm() | Generic confirmation dialog |
| updateCurrentDate() | Updates date display |
| createSKNotificationDB() | Creates notification in database for SK official |
| createSKNotification() | Creates legacy localStorage notification |
| handleURLParameters() | Processes URL params for deep linking |
| switchSection() | Switches between Dashboard, Approvals, and Archives sections |
| formatRelativeDate() | Formats dates as relative time |
| loadAnnouncements() | Fetches announcements from database |
| renderAnnouncements() | Renders paginated announcement cards |
| updateAnnouncementPagination() | Creates pagination dots |
| navigateAnnouncements() | Navigates announcement pages |
| goToAnnouncementPage() | Jumps to specific page |
| viewAnnouncement() | Opens announcement detail modal |
| closeAnnouncementModal() | Closes announcement modal |
| loadProjectApprovals() | Fetches pending projects needing captain approval |
| loadArchives() | Initializes archives section |
| switchArchiveTab() | Switches between archived projects and files |
| loadArchivedProjects() | Fetches archived projects |
| unarchiveProject() | Restores archived project |
| permanentDeleteProject() | Permanently deletes archived project |
| loadArchivedFiles() | Fetches archived files |
| handleLogout() | Signs out and redirects |

**How they work together:** initializePage() authenticates for CAPTAIN role, then loads captain data, project statistics, and announcements. The main dashboard shows 3 sections via switchSection(): Dashboard (stats + announcements), Approvals (project review), and Archives. The approval flow is the captain's primary function: loadProjectApprovals() fetches pending projects, renderTabProjects() shows them in tabs by status, viewProjectDetails() opens the full detail modal with budget breakdown. reviewDecision() reveals 3 action buttons: approveProject() (sets approvalStatus=APPROVED), rejectProject() (sets REJECTED with reason), or requestRevision() (sets REVISION with feedback). Each action calls createSKNotificationDB() to send a professional notification to the SK official. The Archives section mirrors sk-archive.html with project restore and permanent delete capabilities.

---

## 5. Superadmin Pages

### superadmin-dashboard.html

| Function | Description |
|----------|-------------|
| checkAuth() | Verifies SUPERADMIN authentication and authorization |
| loadProfileData() | Fetches superadmin profile data |
| checkSystemStatus() | Pings database, measures latency, shows connection health |
| loadDashboard() | Runs 8 parallel count queries for stat cards |
| loadUsersByRole() | Fetches user counts per role, renders progress bars |
| loadRecentAuditEvents() | Fetches last 3 audit-category logs |
| loadRecentActivity() | Fetches 5 most recent system activity logs |
| renderRecentActivitySimple() | Renders activity log items in timeline format |
| getTimeAgo() | Calculates relative time ("5m ago", "3h ago") |
| checkCaptainTermExpiration() | Checks if captain term is expiring/expired, shows alert |
| setCurrentDate() | Updates current date display |
| toggleSidebar() | Toggles sidebar on mobile |
| handleLogout() | Signs out and redirects |

**How they work together:** checkAuth() verifies SUPERADMIN role, then loadDashboard() fires 8 parallel count queries (total/active/pending/inactive users, projects, applications, total/today's logs) for the stat cards. loadUsersByRole() adds role distribution bars. checkSystemStatus() pings User_Tbl to measure DB latency. checkCaptainTermExpiration() queries Captain_Tbl and shows yellow/red alerts if the term is expiring within 30 days or already expired. loadRecentAuditEvents() shows the 3 most critical admin actions, while loadRecentActivity() shows the 5 most recent system events with relative timestamps via getTimeAgo().

---

### superadmin-user-management.html

| Function | Description |
|----------|-------------|
| checkAuth() | Verifies SUPERADMIN role |
| loadProfileData() | Loads superadmin profile |
| loadUsers() | Fetches ALL users with SK_Tbl join data |
| updateUserStats() | Updates 5 stat cards (total, SK, youth, pending, inactive) |
| renderUsers() | Renders paginated user table with role-based action buttons |
| filterUsers() | Client-side filtering by search text, role, and status |
| updateUsersPagination() | Creates pagination dots for user table |
| navigateUsers() | Navigates user table pages |
| goToUserPage() | Jumps to specific page |
| promoteToSK() | Opens promotion type chooser modal (SK or Captain) |
| closePromotionTypeModal() | Closes promotion type modal |
| selectPromotionType() | Selects SK Official or Captain promotion path |
| promoteToCaptain() | Promotes user to Captain, deactivates previous captains |
| closePromoteModal() | Closes promotion confirmation modal |
| confirmPromote() | Executes SK promotion with position selection and term dates |
| demoteUser() | Opens SK demotion modal |
| demoteCaptain() | Opens Captain demotion modal |
| closeDemoteModal() | Closes demotion modal |
| confirmDemote() | Executes demotion: deletes SK/Captain record, reverts to YOUTH_VOLUNTEER |
| deactivateUser() | Opens deactivation modal with reason dropdown |
| closeDeactivateModal() | Closes deactivation modal |
| confirmDeactivate() | Sets accountStatus=INACTIVE with reason |
| reactivateUser() | Reactivates INACTIVE user back to ACTIVE |
| setCurrentDate() | Updates date display |
| toggleSidebar() | Toggles sidebar on mobile |
| handleLogout() | Signs out and redirects |

**How they work together:** loadUsers() fetches all users with their SK positions, renderUsers() draws a paginated table where each row has role-specific action buttons. filterUsers() provides real-time client-side filtering by name/email, role, and status. The promotion flow: promoteToSK() lets superadmin choose SK Official or Captain. For SK: selectPromotionType() opens confirmPromote() which validates position limits (1 Chairman, 1 Secretary, 1 Treasurer, max 7 Kagawad), auto-deactivates previous holders, and creates SK_Tbl record. For Captain: promoteToCaptain() deactivates ALL existing captains first. Demotion: confirmDemote() deletes the SK/Captain record and reverts role to YOUTH_VOLUNTEER. Deactivation: confirmDeactivate() sets accountStatus=INACTIVE with a tracked reason. All admin actions create audit logs.

---

### superadmin-activity-logs.html

| Function | Description |
|----------|-------------|
| checkAuth() | Verifies SUPERADMIN role |
| loadProfileData() | Loads superadmin profile |
| switchTab() | Switches between All Logs, Audit Trail, and Database Stats tabs (lazy-loads) |
| fetchLogs() | Fetches paginated activity logs with optional date filter |
| renderLogs() | Renders log entries with severity color dots and category badges |
| updateLogsPagination() | Creates pagination dots for logs |
| navigateLogs() | Navigates log pages |
| goToLogsPage() | Jumps to specific log page |
| loadAllLogs() | Reloads logs and resets pagination |
| loadAuditTrail() | Fetches audit-category-only logs |
| renderAudit() | Renders audit entries as alert-style boxes with colored borders |
| updateAuditPagination() | Creates pagination for audit trail |
| navigateAudit() | Navigates audit pages |
| goToAuditPage() | Jumps to specific audit page |
| loadDatabaseStats() | Runs 15 parallel count queries across all tables |
| paginationDot() | Generates individual pagination dot button HTML |
| setCurrentDate() | Updates date display |
| toggleSidebar() | Toggles sidebar on mobile |
| handleLogout() | Signs out and redirects |

**How they work together:** The page has 3 lazy-loaded tabs via switchTab(). Tab 1 (All Logs): fetchLogs() queries Logs_Tbl with server-side pagination (20 per page) and optional date filter, renderLogs() color-codes entries by severity (red=CRITICAL, yellow=WARN, blue=INFO). Tab 2 (Audit Trail): loadAuditTrail() fetches only category='audit' logs, renderAudit() shows them as alert-style boxes — these are critical admin actions like promotions and deactivations. Tab 3 (Database Stats): loadDatabaseStats() fires 15 parallel count queries across all tables to show record counts, plus lists storage buckets. Each tab loads data only on first click, preventing unnecessary queries.

---

## 6. Shared Components

### js/components/NotificationModal.js

| Method | Description |
|--------|-------------|
| getTemplate() | Returns HTML template for notification modal |
| render() | Inserts modal into DOM and initializes instance |
| open() | Opens notification modal and loads latest notifications |
| close() | Closes notification modal |
| toggle() | Toggles modal visibility |
| loadNotifications() | Fetches user's notifications from Notification_Tbl |
| renderNotifications() | Renders notification list items |
| getNotificationHTML() | Generates HTML for a single notification item |
| getNotificationIcon() | Returns type-specific icon (green check for approved, red X for rejected, etc.) |
| handleNotificationClick() | Marks notification as read and navigates to relevant page |
| getRouteForNotification() | Maps notification type to destination page and parameters |
| handleLocalNavigation() | Handles in-page navigation when already on the target page |
| markAsRead() | Marks single notification as read in database |
| markAllAsRead() | Marks all notifications as read |
| updateBadgeCount() | Updates bell icon badge with unread count |
| formatTimeAgo() | Formats timestamp to relative time |
| escapeHtml() | Escapes HTML special characters for XSS prevention |
| showError() | Displays error message in notification container |
| destroy() | Removes modal from DOM and cleans up |

**How they work together:** render() injects the notification HTML into any page. loadNotifications() fetches from Notification_Tbl ordered by newest first. renderNotifications() builds the list using getNotificationHTML() for each item, with getNotificationIcon() providing type-specific icons (green=approved, red=rejected, yellow=pending, blue=announcement). handleNotificationClick() marks as read via markAsRead() then uses getRouteForNotification() to determine where to navigate — either a page redirect or handleLocalNavigation() for same-page scrolling. updateBadgeCount() keeps the bell badge current with unread count.

---

### js/components/ProfileModal.js

| Method | Description |
|--------|-------------|
| getTemplate() | Returns HTML template for profile editing modal |
| render() | Inserts modal into DOM and sets up event listeners |
| setupEventListeners() | Attaches handlers for profile picture upload |
| loadUserData() | Loads user profile from session and database |
| open() | Opens modal and populates form fields |
| close() | Closes modal and resets state |
| updateProfilePicturePreview() | Updates profile picture preview (image or initials fallback) |
| hasSavedBirthday() | Checks if user has a valid birthday saved (not placeholder) |
| enterEditMode() | Enables editing, shows upload button, saves backup |
| cancelEdit() | Restores backed-up values and exits edit mode |
| toggleButtons() | Shows/hides view vs edit mode buttons |
| setFieldsState() | Enables/disables form fields based on edit state |
| showFieldError() | Displays field validation error message |
| clearFieldError() | Clears field error |
| clearAllErrors() | Clears all validation errors |
| validateField() | Validates field against rules (required, length, pattern, custom) |
| handleProfilePictureChange() | Handles profile picture file selection and validation |
| validateImageFile() | Validates image type (JPG/PNG/GIF/WebP) and size (max 5MB) |
| save() | Validates all fields and saves profile changes to User_Tbl |
| showToast() | Displays toast notification |

**How they work together:** render() injects the modal HTML and setupEventListeners() attaches the picture upload handler. open() calls loadUserData() to fetch current data and populates all form fields. The edit flow: enterEditMode() saves a backup of current values and enables fields via setFieldsState(). Each field validates via validateField() with rules for required, length, and pattern. handleProfilePictureChange() validates the image via validateImageFile() and uploads to Supabase storage. save() validates all fields, updates User_Tbl, and dispatches a 'profileUpdated' custom event so the page header updates. cancelEdit() restores the backup. Birthday is locked after first save via hasSavedBirthday().

---

### js/auth/session.js (SessionManager)

Listed in [Authentication Pages section](#jsauthsessionjs-sessionmanager).

### js/utils/logger.js (logAction)

| Function | Description |
|----------|-------------|
| logAction(action, opts) | Fire-and-forget logging: auto-detects category and severity from action text, inserts into Logs_Tbl via RPC |

**How it works:** Called from every page (56 call sites). Parses the action string to auto-assign category (authentication, data_mutation, audit) and severity (INFO, WARN, CRITICAL) based on keywords. Actions prefixed with `[AUDIT]` are tagged for the audit trail. Captures browser user agent and metadata. Never blocks UI — errors are silently swallowed so logging failures never break the app.

---

### js/components/sidebar.js

| Function | Description |
|----------|-------------|
| IIFE initializer | Self-executing function that renders the role-appropriate sidebar HTML |
| updateSidebarActive() | Updates active navigation state for captain dashboard sections |

**How they work together:** The IIFE runs on script load, detects the current page from the URL, and renders the appropriate sidebar navigation (SK, Youth, Captain, or Superadmin). Active page is highlighted automatically. updateSidebarActive() is only used on captain-dashboard.html to handle section switching within the single page.
