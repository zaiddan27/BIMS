# NEW TEST CASES - CONTENT MANAGEMENT (ANNOUNCEMENTS)

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Create Announcement with Image Upload (16:9 Cropper)
Test Case ID: AD-C6
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Content Management - Create with Image
Test Executed by:
Test Title: Create Announcement with Image Upload (16:9 Cropper)
Test Execution date:
Description: Verify that the SK Official can create an announcement with an image attachment that goes through the 16:9 cropper before uploading.

Pre-Condition: Logged in as SK Official and on the Dashboard/Content Management section.
Dependencies: Image cropper library (Cropper.js) is loaded; announcement-images storage bucket is configured.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Click on the "Create Announcement" button | | The Create Announcement form/modal opens with title, category, description, and image upload fields | | | |
| 2 | Enter announcement details | Title: "Youth Sports Fest 2026", Category: Urgent, Description: "Annual sports festival for all youth volunteers." | Input fields accept the text without errors | | | |
| 3 | Click the image upload field and select an image file | Image: sports_banner.jpg (under 5MB, JPEG format) | The image cropper modal opens displaying the selected image with a 16:9 aspect ratio crop box | | | |
| 4 | Adjust the crop area as desired and click "Crop & Upload" | | The cropper processes the image to 1280x720 pixels; the cropper modal closes; a preview of the cropped image appears in the create form | | | |
| 5 | Click "Post Announcement" | | System uploads the cropped image to storage, creates the announcement with the image URL, shows a success toast, and the new announcement card displays with the image | | | |

Post-Condition: The new announcement is saved in the database with an imagePathURL; the announcement card shows the cropped image on the dashboard.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Edit Announcement Image
Test Case ID: AD-C7
Test Designed by: JC Ledonio
Test Priority: Medium
Test Designed date: November 29, 2025
Function Name: Content Management - Edit Image
Test Executed by:
Test Title: Edit Announcement Image
Test Execution date:
Description: Verify that the SK Official can replace the image of an existing announcement through the edit modal.

Pre-Condition: Logged in as SK Official; at least one announcement with an image exists.
Dependencies: Image cropper and storage upload are functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Locate an announcement with an image and click the "Edit" (pencil) icon | General Assembly | The Edit Announcement modal opens with existing title, category, description pre-filled, and the current image displayed as a preview | | | |
| 2 | Click the image upload field to select a new image | New image: updated_banner.png (under 5MB) | The cropper modal opens with the new image and 16:9 aspect ratio crop box | | | |
| 3 | Adjust the crop and click "Crop & Upload" | | Cropper modal closes; the edit form now shows a preview labeled "New Image (Cropped)" replacing the old image preview | | | |
| 4 | Click "Save Changes" | | System uploads the new image, updates the announcement record with the new imagePathURL, shows success toast, and the announcement card now displays the new image | | | |

Post-Condition: The announcement's image is updated in the database and displayed correctly on the dashboard; the old image URL is replaced.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
Announcement Pagination
Test Case ID: AD-C8
Test Designed by: JC Ledonio
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Content Management - Pagination
Test Executed by:
Test Title: Announcement Pagination Navigation
Test Execution date:
Description: Verify that announcement pagination works correctly when there are more than 3 announcements, displaying 3 per page with functional navigation controls.

Pre-Condition: Logged in as SK Official; more than 3 announcements exist in the system (e.g., 7 announcements).
Dependencies: Announcements are loaded and pagination logic is functional.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Dashboard/Content Management section | | Announcements section displays 3 announcement cards on the first page with pagination dots visible below | | | |
| 2 | Verify the number of pagination dots | 7 announcements total | 3 pagination dots are visible (7 announcements / 3 per page = 3 pages); the first dot is wider and highlighted (active) | | | |
| 3 | Click the right/next arrow button | | The view scrolls to show the next 3 announcements (page 2); the second pagination dot becomes active | | | |
| 4 | Click the third pagination dot directly | | The view jumps to page 3 showing the remaining announcement(s); the third dot becomes active | | | |
| 5 | Click the left/previous arrow button | | The view returns to page 2; the second dot becomes active | | | |

Post-Condition: User can navigate through all announcement pages; pagination dots correctly reflect the current page.

---

Project Name: Barangay Information Management System (BIMS) of Barangay Malanday
View Announcements as Captain (Read-Only)
Test Case ID: CAP-C1
Test Designed by: JC Ledonio
Test Priority: Low
Test Designed date: November 29, 2025
Function Name: Content Management - Captain View
Test Executed by:
Test Title: View Announcements as Captain (Read-Only)
Test Execution date:
Description: Verify that the Barangay Captain can view announcements on their dashboard but cannot create, edit, or delete them.

Pre-Condition: Logged in as Barangay Captain; at least one announcement exists in the system.
Dependencies: Captain dashboard is functional; announcements are loaded.

| Steps | Test Steps | Test Data | Expected Result | Actual Result | Status | Notes |
|-------|-----------|-----------|-----------------|---------------|--------|-------|
| 1 | Navigate to the Captain Dashboard | | Dashboard loads with the Announcements section visible, showing announcement cards | | | |
| 2 | Verify that NO "Create Announcement" button is visible | | There is no create/add button for announcements in the Captain view | | | |
| 3 | Click the "View" button on an announcement card | General Assembly | A view-only modal opens displaying the full announcement details (title, description, date, category, image) | | | |
| 4 | Verify that NO "Edit" or "Delete" buttons are visible in the modal or on cards | | Only a "Close" button is available; no edit (pencil) or delete icons are present | | | |
| 5 | Close the modal | | Modal closes; Captain returns to the dashboard | | | |

Post-Condition: Captain can only view announcements; no modifications are possible from the Captain Dashboard.
