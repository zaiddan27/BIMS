/**
 * Profile Modal Component
 * Reusable profile management modal for SK Officials and Youth Volunteers
 *
 * Usage:
 *   import { ProfileModal } from './js/components/ProfileModal.js';
 *   const modal = new ProfileModal();
 *   modal.render();
 *
 * Features:
 * - View/Edit mode toggle
 * - Profile picture upload
 * - Form validation
 * - Database integration
 * - Real-time field validation
 */

export class ProfileModal {
  constructor() {
    this.modalId = "profileModal";
    this.isEditMode = false;
    this.profileBackup = {};
    this.userProfile = {
      firstName: "",
      middleName: "",
      lastName: "",
      email: "",
      position: "",
      address: "",
      contact: "",
      gender: "",
      birthday: "",
      profilePicture: ""
    };
    this.currentUser = null;
    this.currentUserData = null;

    // XSS prevention helper
    this._escapeHTML = (str) => {
      if (!str) return '';
      const div = document.createElement('div');
      div.appendChild(document.createTextNode(str));
      return div.innerHTML;
    };
  }

  /**
   * Returns the HTML template for the profile modal
   */
  getTemplate() {
    return `
      <!-- Profile Modal -->
      <div id="${this.modalId}" class="hidden fixed inset-0 z-50 overflow-y-auto bg-black bg-opacity-50" role="dialog" aria-modal="true" aria-labelledby="profileModalTitle">
        <div class="flex items-center justify-center min-h-screen px-4">
          <div class="relative bg-white rounded-2xl shadow-2xl max-w-2xl w-full">
            <!-- Header -->
            <div class="bg-gradient-to-r from-[#3d8b64] to-[#3d8b64] text-white p-6 rounded-t-2xl">
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                  <div class="relative">
                    <div id="profilePicturePreview" class="w-20 h-20 bg-white/20 backdrop-blur rounded-full flex items-center justify-center text-white font-bold text-2xl overflow-hidden">
                      --
                    </div>
                    <label id="profilePictureUploadBtn" for="profilePictureInput" class="hidden absolute bottom-0 right-0 bg-white text-[#2f6e4e] rounded-full p-2 cursor-pointer hover:bg-[#2f6e4e]/10 transition shadow-lg">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"></path>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path>
                      </svg>
                    </label>
                    <input type="file" id="profilePictureInput" class="hidden" accept="image/jpeg,image/png,image/jpg,image/gif,image/webp" />
                  </div>
                  <div>
                    <h2 id="profileModalTitle" class="text-2xl font-bold">Profile Settings</h2>
                    <p class="text-white/70 text-sm">Manage your account information</p>
                  </div>
                </div>
                <button onclick="window.profileModal.close()" class="text-white hover:bg-white/10 rounded-lg p-2 transition">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                  </svg>
                </button>
              </div>
            </div>

            <!-- Form Content -->
            <div class="p-4 md:p-6 max-h-[calc(100vh-300px)] overflow-y-auto">
              <form id="profileForm" class="space-y-6">
                <!-- Personal Information -->
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2">
                    <svg class="w-5 h-5 text-[#2f6e4e]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                    Personal Information
                  </h3>
                  <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Last Name *</label>
                      <input type="text" id="profileLastName" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#3d8b64] focus:border-transparent" required />
                      <p id="lastNameError" class="hidden text-xs text-red-600 mt-1"></p>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">First Name *</label>
                      <input type="text" id="profileFirstName" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#3d8b64] focus:border-transparent" required />
                      <p id="firstNameError" class="hidden text-xs text-red-600 mt-1"></p>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Middle Name</label>
                      <input type="text" id="profileMiddleName" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#3d8b64] focus:border-transparent" />
                      <p id="middleNameError" class="hidden text-xs text-red-600 mt-1"></p>
                    </div>
                  </div>
                </div>

                <!-- Contact Information -->
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2">
                    <svg class="w-5 h-5 text-[#2f6e4e]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                    Contact Information
                  </h3>
                  <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                      <input type="email" id="profileEmail" class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50" disabled />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Position</label>
                      <input type="text" id="profilePosition" class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50" disabled />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Contact Number *</label>
                      <input type="tel" id="profileContact" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#3d8b64] focus:border-transparent" placeholder="09XXXXXXXXX" />
                      <p id="contactError" class="hidden text-xs text-red-600 mt-1"></p>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Address *</label>
                      <input type="text" id="profileAddress" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#3d8b64] focus:border-transparent" />
                      <p id="addressError" class="hidden text-xs text-red-600 mt-1"></p>
                    </div>
                  </div>
                </div>

                <!-- Additional Details -->
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2">
                    <svg class="w-5 h-5 text-[#2f6e4e]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                    Additional Details
                  </h3>
                  <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Gender</label>
                      <select id="profileGender" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#3d8b64] focus:border-transparent">
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                      </select>
                      <p id="genderError" class="hidden text-xs text-red-600 mt-1"></p>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Birthday *</label>
                      <input type="date" id="profileBirthday" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#3d8b64] focus:border-transparent" />
                      <p id="birthdayError" class="hidden text-xs text-red-600 mt-1"></p>
                    </div>
                  </div>
                </div>
              </form>
            </div>

            <!-- Footer -->
            <div class="bg-gray-50 px-6 py-4 rounded-b-2xl flex justify-end gap-3">
              <!-- View Mode Buttons -->
              <div id="viewModeButtons" class="flex gap-3 w-full justify-end">
                <button type="button" onclick="window.profileModal.close()" class="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100 transition font-medium">
                  Close
                </button>
                <button type="button" onclick="window.profileModal.enterEditMode()" class="px-6 py-2 bg-[#2f6e4e] text-white rounded-lg hover:bg-[#2f6e4e]/90 transition font-medium shadow-lg shadow-[#2f6e4e]/30">
                  Edit Profile
                </button>
              </div>
              <!-- Edit Mode Buttons -->
              <div id="editModeButtons" class="hidden flex gap-3 w-full justify-end">
                <button type="button" onclick="window.profileModal.cancelEdit()" class="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100 transition font-medium">
                  Cancel
                </button>
                <button type="button" onclick="window.profileModal.save()" class="px-6 py-2 bg-[#2f6e4e] text-white rounded-lg hover:bg-[#2f6e4e]/90 transition font-medium shadow-lg shadow-[#2f6e4e]/30">
                  Save Changes
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  /**
   * Renders the profile modal into the DOM
   */
  render() {
    // Check if modal already exists
    if (document.getElementById(this.modalId)) {
      return;
    }

    // Insert modal at the end of body
    document.body.insertAdjacentHTML("beforeend", this.getTemplate());

    // Setup event listeners
    this.setupEventListeners();

    // Make instance globally accessible
    window.profileModal = this;
  }

  /**
   * Setup event listeners for profile picture upload
   */
  setupEventListeners() {
    const profilePictureInput = document.getElementById('profilePictureInput');
    if (profilePictureInput) {
      profilePictureInput.addEventListener('change', (e) => this.handleProfilePictureChange(e));
    }
  }

  /**
   * Load user profile data from session
   */
  async loadUserData(user, userData) {
    this.currentUser = user;
    this.currentUserData = userData;

    // Determine position based on role
    let position = "User";
    if (userData.role === 'SK_OFFICIAL') {
      position = "SK Official";
    } else if (userData.role === 'YOUTH_VOLUNTEER') {
      position = "Youth Volunteer";
    } else if (userData.role === 'CAPTAIN') {
      position = "Barangay Captain";
    } else if (userData.role === 'SUPERADMIN') {
      position = "System Administrator";
    }

    // Update userProfile object with real data
    this.userProfile = {
      firstName: userData.firstName || "",
      middleName: userData.middleName || "",
      lastName: userData.lastName || "",
      email: user.email || "",
      position: position,
      address: userData.address || "",
      contact: userData.contactNumber || "",
      gender: userData.gender || "",
      birthday: userData.birthday || "",
      profilePicture: userData.imagePathURL || ""
    };
  }

  /**
   * Opens the profile modal and populates with user data
   */
  open() {
    const modal = document.getElementById(this.modalId);
    if (!modal) {
      return;
    }

    // Populate form fields
    document.getElementById('profileFirstName').value = this.userProfile.firstName;
    document.getElementById('profileMiddleName').value = this.userProfile.middleName;
    document.getElementById('profileLastName').value = this.userProfile.lastName;
    document.getElementById('profileEmail').value = this.userProfile.email;
    document.getElementById('profilePosition').value = this.userProfile.position;
    document.getElementById('profileAddress').value = this.userProfile.address;
    document.getElementById('profileContact').value = this.userProfile.contact;
    document.getElementById('profileGender').value = this.userProfile.gender;
    document.getElementById('profileBirthday').value = this.userProfile.birthday;

    // Load profile picture preview
    this.updateProfilePicturePreview();

    // Always start in view mode
    this.isEditMode = false;
    this.setFieldsState(false);
    this.clearAllErrors();
    this.toggleButtons(false);

    modal.classList.remove('hidden');
  }

  /**
   * Closes the profile modal
   */
  close() {
    const modal = document.getElementById(this.modalId);
    if (modal) {
      modal.classList.add('hidden');
      // Reset to view mode
      this.isEditMode = false;
      this.setFieldsState(false);
      this.clearAllErrors();
      this.toggleButtons(false);
    }
  }

  /**
   * Update profile picture preview
   */
  updateProfilePicturePreview() {
    const previewDiv = document.getElementById('profilePicturePreview');
    if (!previewDiv) return;

    if (this.userProfile.profilePicture) {
      previewDiv.innerHTML = `<img src="${this._escapeHTML(this.userProfile.profilePicture)}" alt="Profile Picture" class="w-full h-full object-cover rounded-full" />`;
    } else {
      const firstInitial = this.userProfile.firstName ? this.userProfile.firstName.charAt(0).toUpperCase() : '-';
      const lastInitial = this.userProfile.lastName ? this.userProfile.lastName.charAt(0).toUpperCase() : '-';
      previewDiv.innerHTML = `<span class="text-white font-bold text-2xl">${firstInitial}${lastInitial}</span>`;
    }
  }

  /**
   * Enter edit mode
   */
  enterEditMode() {
    // Save current state for potential cancel
    this.profileBackup = {
      firstName: document.getElementById('profileFirstName').value,
      middleName: document.getElementById('profileMiddleName').value,
      lastName: document.getElementById('profileLastName').value,
      address: document.getElementById('profileAddress').value,
      contact: document.getElementById('profileContact').value,
      gender: document.getElementById('profileGender').value,
      birthday: document.getElementById('profileBirthday').value
    };

    this.isEditMode = true;
    this.setFieldsState(true);
    this.clearAllErrors();
    this.toggleButtons(true);

    // Show profile picture upload button
    const uploadBtn = document.getElementById('profilePictureUploadBtn');
    if (uploadBtn) uploadBtn.classList.remove('hidden');
  }

  /**
   * Cancel edit and restore backup
   */
  cancelEdit() {
    // Restore backed up values
    document.getElementById('profileFirstName').value = this.profileBackup.firstName;
    document.getElementById('profileMiddleName').value = this.profileBackup.middleName;
    document.getElementById('profileLastName').value = this.profileBackup.lastName;
    document.getElementById('profileAddress').value = this.profileBackup.address;
    document.getElementById('profileContact').value = this.profileBackup.contact;
    document.getElementById('profileGender').value = this.profileBackup.gender;
    document.getElementById('profileBirthday').value = this.profileBackup.birthday;

    this.isEditMode = false;
    this.setFieldsState(false);
    this.clearAllErrors();
    this.toggleButtons(false);

    // Hide profile picture upload button
    const uploadBtn = document.getElementById('profilePictureUploadBtn');
    if (uploadBtn) uploadBtn.classList.add('hidden');
  }

  /**
   * Toggle button visibility between view and edit mode
   */
  toggleButtons(editMode) {
    const viewButtons = document.getElementById('viewModeButtons');
    const editButtons = document.getElementById('editModeButtons');

    if (editMode) {
      viewButtons?.classList.add('hidden');
      editButtons?.classList.remove('hidden');
    } else {
      viewButtons?.classList.remove('hidden');
      editButtons?.classList.add('hidden');
    }
  }

  /**
   * Set fields editable/disabled state
   */
  setFieldsState(editable) {
    const editableFields = ['profileFirstName', 'profileMiddleName', 'profileLastName', 'profileContact', 'profileAddress', 'profileGender', 'profileBirthday'];

    editableFields.forEach(fieldId => {
      const field = document.getElementById(fieldId);
      if (field) {
        field.disabled = !editable;
        if (editable) {
          field.classList.remove('bg-gray-50', 'cursor-not-allowed');
          field.classList.add('bg-white');
        } else {
          field.classList.add('bg-gray-50', 'cursor-not-allowed');
          field.classList.remove('bg-white');
        }
      }
    });
  }

  /**
   * Show field error
   */
  showFieldError(fieldId, errorId, message) {
    const field = document.getElementById(fieldId);
    const error = document.getElementById(errorId);
    if (field && error) {
      field.classList.add('border-red-500');
      field.classList.remove('border-gray-300');
      error.textContent = message;
      error.classList.remove('hidden');
    }
  }

  /**
   * Clear field error
   */
  clearFieldError(fieldId, errorId) {
    const field = document.getElementById(fieldId);
    const error = document.getElementById(errorId);
    if (field && error) {
      field.classList.remove('border-red-500');
      field.classList.add('border-gray-300');
      error.classList.add('hidden');
    }
  }

  /**
   * Clear all errors
   */
  clearAllErrors() {
    const errorFields = ['firstNameError', 'middleNameError', 'lastNameError', 'contactError', 'addressError', 'genderError', 'birthdayError'];
    const inputFields = ['profileFirstName', 'profileMiddleName', 'profileLastName', 'profileContact', 'profileAddress', 'profileGender', 'profileBirthday'];

    errorFields.forEach((errorId, index) => {
      this.clearFieldError(inputFields[index], errorId);
    });
  }

  /**
   * Validate a field
   */
  validateField(fieldId, value, rules) {
    const { required, minLength, maxLength, pattern, patternMessage, customValidation, errorId, fieldName } = rules;

    if (required && (!value || value.trim() === '')) {
      this.showFieldError(fieldId, errorId, `${fieldName} is required`);
      return false;
    }

    if (minLength && value && value.length < minLength) {
      this.showFieldError(fieldId, errorId, `${fieldName} must be at least ${minLength} characters`);
      return false;
    }

    if (maxLength && value && value.length > maxLength) {
      this.showFieldError(fieldId, errorId, `${fieldName} must not exceed ${maxLength} characters`);
      return false;
    }

    if (pattern && value && !pattern.test(value)) {
      this.showFieldError(fieldId, errorId, patternMessage || `Invalid ${fieldName} format`);
      return false;
    }

    if (customValidation) {
      const customResult = customValidation(value);
      if (!customResult.valid) {
        this.showFieldError(fieldId, errorId, customResult.message);
        return false;
      }
    }

    this.clearFieldError(fieldId, errorId);
    return true;
  }

  /**
   * Handle profile picture change
   */
  async handleProfilePictureChange(event) {
    const file = event.target.files[0];
    if (!file) {
      return;
    }

    // Validate file
    const validation = this.validateImageFile(file);
    if (!validation.valid) {
      this.showToast(validation.error, 'error');
      event.target.value = ''; // Clear the input
      return;
    }

    // Preview the image
    const reader = new FileReader();
    reader.onload = (e) => {
      const previewDiv = document.getElementById('profilePicturePreview');
      if (previewDiv) {
        previewDiv.innerHTML = `<img src="${this._escapeHTML(e.target.result)}" alt="Profile Preview" class="w-full h-full object-cover rounded-full" />`;
      }
    };
    reader.readAsDataURL(file);

    // Store file for upload during save
    this.pendingProfilePicture = file;
  }

  /**
   * Validate image file
   */
  validateImageFile(file) {
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    const maxSize = 5 * 1024 * 1024; // 5MB

    if (!allowedTypes.includes(file.type)) {
      return { valid: false, error: `Invalid file type: ${file.type}. Only JPG, PNG, GIF, and WebP images are allowed` };
    }

    if (file.size > maxSize) {
      return { valid: false, error: `Image size (${(file.size / 1024 / 1024).toFixed(2)} MB) exceeds 5MB limit` };
    }

    return { valid: true };
  }

  /**
   * Save profile changes
   */
  async save() {
    try {
      // Clear all previous errors
      this.clearAllErrors();

      // Get form values
      const firstName = document.getElementById('profileFirstName').value.trim();
      const middleName = document.getElementById('profileMiddleName').value.trim();
      const lastName = document.getElementById('profileLastName').value.trim();
      const address = document.getElementById('profileAddress').value.trim();
      const contact = document.getElementById('profileContact').value.trim();
      const birthday = document.getElementById('profileBirthday').value;
      const gender = document.getElementById('profileGender').value;

      // Comprehensive validation
      let isValid = true;

      // Validate first name
      isValid = this.validateField('profileFirstName', firstName, {
        required: true,
        minLength: 2,
        maxLength: 50,
        errorId: 'firstNameError',
        fieldName: 'First name'
      }) && isValid;

      // Validate last name
      isValid = this.validateField('profileLastName', lastName, {
        required: true,
        minLength: 2,
        maxLength: 50,
        errorId: 'lastNameError',
        fieldName: 'Last name'
      }) && isValid;

      // Validate contact number
      isValid = this.validateField('profileContact', contact, {
        required: true,
        pattern: /^09\d{9}$/,
        patternMessage: 'Contact number must be 11 digits starting with 09',
        errorId: 'contactError',
        fieldName: 'Contact number'
      }) && isValid;

      // Validate address
      isValid = this.validateField('profileAddress', address, {
        required: true,
        minLength: 10,
        maxLength: 200,
        errorId: 'addressError',
        fieldName: 'Address'
      }) && isValid;

      // Validate birthday with age check
      isValid = this.validateField('profileBirthday', birthday, {
        required: true,
        errorId: 'birthdayError',
        fieldName: 'Birthday',
        customValidation: (value) => {
          if (!value) return { valid: false, message: 'Birthday is required' };

          const birthDate = new Date(value);
          const today = new Date();
          let age = today.getFullYear() - birthDate.getFullYear();
          const monthDiff = today.getMonth() - birthDate.getMonth();

          if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
          }

          if (age < 13) {
            return { valid: false, message: 'You must be at least 13 years old' };
          }

          if (age > 120) {
            return { valid: false, message: 'Please enter a valid birth date' };
          }

          return { valid: true };
        }
      }) && isValid;

      if (!isValid) {
        this.showToast('Please fix the errors before saving', 'error');
        return;
      }

      // Get current session
      const { data: { session }, error: sessionError } = await supabaseClient.auth.getSession();

      if (sessionError) throw sessionError;
      if (!session) {
        this.showToast('Please log in again', 'error');
        window.location.href = 'login.html';
        return;
      }

      // Format names to Title Case
      const formatName = (name) => {
        if (!name) return '';
        return name.split(' ')
          .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
          .join(' ');
      };

      const formattedFirstName = formatName(firstName);
      const formattedMiddleName = middleName ? formatName(middleName) : null;
      const formattedLastName = formatName(lastName);

      // Prepare update data
      const updateData = {
        firstName: formattedFirstName,
        middleName: formattedMiddleName,
        lastName: formattedLastName,
        contactNumber: contact,
        address: address,
        gender: gender || null,
        birthday: birthday,
        updatedAt: new Date().toISOString()
      };

      // Upload profile picture if changed
      if (this.pendingProfilePicture) {
        const fileExt = this.pendingProfilePicture.type.split('/')[1].replace('jpeg', 'jpg');
        const fileName = `profile_${Date.now()}.${fileExt}`;
        const filePath = `${session.user.id}/${fileName}`;

        const { data: uploadData, error: uploadError } = await supabaseClient.storage
          .from('user-images')
          .upload(filePath, this.pendingProfilePicture, {
            cacheControl: '3600',
            upsert: true,
            contentType: this.pendingProfilePicture.type
          });

        if (uploadError) {
          throw new Error(`Image upload failed: ${uploadError.message}`);
        }

        const { data: urlData } = supabaseClient.storage
          .from('user-images')
          .getPublicUrl(filePath);

        updateData.imagePathURL = urlData.publicUrl;
      }

      // Update database
      const { data, error } = await supabaseClient
        .from('User_Tbl')
        .update(updateData)
        .eq('userID', session.user.id)
        .select();

      if (error) throw error;

      // Update local profile data
      this.userProfile.firstName = formattedFirstName;
      this.userProfile.middleName = formattedMiddleName || "";
      this.userProfile.lastName = formattedLastName;
      this.userProfile.contact = contact;
      this.userProfile.address = address;
      this.userProfile.gender = gender;
      this.userProfile.birthday = birthday;
      if (updateData.imagePathURL) {
        this.userProfile.profilePicture = updateData.imagePathURL;
      }

      // Clear pending picture
      this.pendingProfilePicture = null;

      // Exit edit mode
      this.isEditMode = false;
      this.setFieldsState(false);
      this.toggleButtons(false);

      // Hide profile picture upload button
      const uploadBtn = document.getElementById('profilePictureUploadBtn');
      if (uploadBtn) uploadBtn.classList.add('hidden');

      this.showToast('Profile updated successfully!', 'success');

      // Trigger update header event (if page needs to refresh header)
      const event = new CustomEvent('profileUpdated', { detail: this.userProfile });
      window.dispatchEvent(event);

    } catch (error) {
      console.error("[ProfileModal] Save error:", error);
      this.showToast('Failed to update profile. Please try again.', 'error');
    }
  }

  /**
   * Show toast notification
   */
  showToast(message, type = 'success') {
    // Remove existing toast
    const existingToast = document.querySelector('.toast');
    if (existingToast) {
      existingToast.remove();
    }

    const toast = document.createElement('div');
    toast.className = `toast ${type}`;

    let icon = '';
    if (type === 'success') {
      icon = '<svg class="w-5 h-5 text-green-600" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>';
    } else if (type === 'error') {
      icon = '<svg class="w-5 h-5 text-red-600" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg>';
    }

    toast.innerHTML = `
      ${icon}
      <span class="font-medium">${message}</span>
    `;

    document.body.appendChild(toast);

    // Trigger animation
    setTimeout(() => toast.classList.add('show'), 100);

    // Auto remove after 3 seconds
    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }
}
