/**
 * Authentication Service for BIMS
 *
 * Handles all authentication operations using Supabase Auth:
 * - Sign up (Youth Volunteers only)
 * - Login with OTP verification
 * - Password reset
 * - Session management
 * - Role-based access control
 *
 * Requirements from CLAUDE.md:
 * - Email/Password authentication
 * - OTP verification (6 digits, 10 min expiry)
 * - 5 login attempts max, then 15-min lockout
 * - Role-based redirection (SK_OFFICIAL, YOUTH_VOLUNTEER, CAPTAIN)
 */

const AuthService = {
    /**
     * Sign up a new user (Youth Volunteers only)
     *
     * @param {Object} userData - User registration data
     * @param {string} userData.email - User email
     * @param {string} userData.password - User password (min 8 chars)
     * @param {string} userData.firstName - First name
     * @param {string} userData.lastName - Last name
     * @param {string} userData.middleName - Middle name
     * @param {string} userData.birthday - Birth date (YYYY-MM-DD)
     * @param {string} userData.contactNumber - Contact number (max 13 chars)
     * @param {string} userData.address - Full address
     * @param {boolean} userData.termsConditions - Terms acceptance
     * @returns {Promise<{success: boolean, data?: Object, error?: string}>}
     */
    async signUp(userData) {
        try {
            // Validate required fields
            const requiredFields = ['email', 'password', 'firstName', 'lastName', 'middleName',
                                   'birthday', 'contactNumber', 'address', 'termsConditions'];

            for (const field of requiredFields) {
                if (!userData[field]) {
                    return { success: false, error: `${field} is required` };
                }
            }

            // Validate password length (min 8 chars as per settings)
            if (userData.password.length < 8) {
                return { success: false, error: 'Password must be at least 8 characters long' };
            }

            // Validate terms acceptance
            if (!userData.termsConditions) {
                return { success: false, error: 'You must accept the terms and conditions' };
            }

            // Sign up with Supabase Auth
            const { data: authData, error: authError } = await supabaseClient.auth.signUp({
                email: userData.email,
                password: userData.password,
                options: {
                    emailRedirectTo: `${window.location.origin}/login.html`,
                    data: {
                        first_name: userData.firstName,
                        last_name: userData.lastName,
                        middle_name: userData.middleName,
                        role: 'YOUTH_VOLUNTEER', // Default role for sign up
                        birthday: userData.birthday,
                        contact_number: userData.contactNumber,
                        address: userData.address,
                        terms_conditions: userData.termsConditions,
                        account_status: 'PENDING', // Requires admin approval
                    }
                }
            });

            if (authError) {
                return { success: false, error: authError.message };
            }

            return {
                success: true,
                data: authData,
                message: 'Sign up successful! Please check your email for verification code.'
            };

        } catch (error) {
            return { success: false, error: error.message };
        }
    },

    /**
     * Verify OTP code sent to email
     *
     * @param {string} email - User email
     * @param {string} token - 6-digit OTP code
     * @returns {Promise<{success: boolean, data?: Object, error?: string}>}
     */
    async verifyOTP(email, token) {
        try {
            const { data, error } = await supabaseClient.auth.verifyOtp({
                email: email,
                token: token,
                type: 'email' // Can be 'email', 'signup', 'recovery'
            });

            if (error) {
                return { success: false, error: error.message };
            }

            return { success: true, data: data };

        } catch (error) {
            return { success: false, error: error.message };
        }
    },

    /**
     * Login with email and password
     *
     * Note: Supabase will send OTP automatically if email confirmation is required
     *
     * @param {string} email - User email
     * @param {string} password - User password
     * @returns {Promise<{success: boolean, data?: Object, error?: string, needsOTP?: boolean}>}
     */
    async login(email, password) {
        try {
            // Check login attempts before proceeding
            const attemptCheck = this.checkLoginAttempts(email);
            if (!attemptCheck.allowed) {
                return {
                    success: false,
                    error: attemptCheck.error,
                    lockoutMinutes: attemptCheck.minutesRemaining
                };
            }

            const { data, error } = await supabaseClient.auth.signInWithPassword({
                email: email,
                password: password,
            });

            if (error) {
                // Track failed attempt
                this.recordFailedAttempt(email);

                return { success: false, error: error.message };
            }

            // Clear login attempts on successful login
            this.clearLoginAttempts(email);

            // Check if user email is confirmed
            if (data.user && !data.user.email_confirmed_at) {
                return {
                    success: false,
                    needsOTP: true,
                    email: email,
                    message: 'Please check your email for the verification code.'
                };
            }

            return { success: true, data: data };

        } catch (error) {
            return { success: false, error: error.message };
        }
    },

    /**
     * Logout current user
     *
     * @returns {Promise<{success: boolean, error?: string}>}
     */
    async logout() {
        try {
            const { error } = await supabaseClient.auth.signOut();

            if (error) {
                return { success: false, error: error.message };
            }

            // Clear all session data from local storage
            localStorage.removeItem('userRole');
            localStorage.removeItem('userName');
            localStorage.removeItem('userEmail');
            localStorage.removeItem('userID');

            return { success: true };

        } catch (error) {
            return { success: false, error: error.message };
        }
    },

    /**
     * Request password reset (sends OTP to email)
     *
     * @param {string} email - User email
     * @returns {Promise<{success: boolean, error?: string}>}
     */
    async requestPasswordReset(email) {
        try {
            const { data, error } = await supabaseClient.auth.resetPasswordForEmail(email, {
                redirectTo: `${window.location.origin}/reset-password.html`,
            });

            if (error) {
                return { success: false, error: error.message };
            }

            return {
                success: true,
                message: 'Password reset instructions sent to your email.'
            };

        } catch (error) {
            return { success: false, error: error.message };
        }
    },

    /**
     * Update password after reset
     *
     * @param {string} newPassword - New password (min 8 chars)
     * @returns {Promise<{success: boolean, error?: string}>}
     */
    async updatePassword(newPassword) {
        try {
            if (newPassword.length < 8) {
                return { success: false, error: 'Password must be at least 8 characters long' };
            }

            const { data, error } = await supabaseClient.auth.updateUser({
                password: newPassword
            });

            if (error) {
                return { success: false, error: error.message };
            }

            return { success: true, message: 'Password updated successfully.' };

        } catch (error) {
            return { success: false, error: error.message };
        }
    },

    /**
     * Get current authenticated user
     *
     * @returns {Promise<{success: boolean, user?: Object, error?: string}>}
     */
    async getCurrentUser() {
        try {
            const { data: { user }, error } = await supabaseClient.auth.getUser();

            if (error) {
                return { success: false, error: error.message };
            }

            if (!user) {
                return { success: false, error: 'No authenticated user' };
            }

            return { success: true, user: user };

        } catch (error) {
            return { success: false, error: error.message };
        }
    },

    /**
     * Get current session
     *
     * @returns {Promise<{success: boolean, session?: Object, error?: string}>}
     */
    async getSession() {
        try {
            const { data: { session }, error } = await supabaseClient.auth.getSession();

            if (error) {
                return { success: false, error: error.message };
            }

            if (!session) {
                return { success: false, error: 'No active session' };
            }

            return { success: true, session: session };

        } catch (error) {
            return { success: false, error: error.message };
        }
    },

    /**
     * Check if user is authenticated
     *
     * @returns {Promise<boolean>}
     */
    async isAuthenticated() {
        const sessionResult = await this.getSession();
        return sessionResult.success && sessionResult.session !== null;
    },

    /**
     * Track failed login attempts (5 attempts max, 15-min lockout)
     * Local storage based tracking
     */
    recordFailedAttempt(email) {
        const key = `login_attempts_${email}`;
        const attempts = JSON.parse(localStorage.getItem(key) || '[]');

        attempts.push(Date.now());

        localStorage.setItem(key, JSON.stringify(attempts));
    },

    /**
     * Check if user has exceeded login attempts
     *
     * @param {string} email - User email
     * @returns {Object} - {allowed: boolean, error?: string, minutesRemaining?: number}
     */
    checkLoginAttempts(email) {
        const key = `login_attempts_${email}`;
        const attempts = JSON.parse(localStorage.getItem(key) || '[]');
        const now = Date.now();
        const fifteenMinutes = 15 * 60 * 1000; // 15 minutes in milliseconds

        // Filter out attempts older than 15 minutes
        const recentAttempts = attempts.filter(timestamp => now - timestamp < fifteenMinutes);

        // Update storage with only recent attempts
        localStorage.setItem(key, JSON.stringify(recentAttempts));

        // Check if user has 5 or more failed attempts in last 15 minutes
        if (recentAttempts.length >= 5) {
            const oldestAttempt = Math.min(...recentAttempts);
            const lockoutEnd = oldestAttempt + fifteenMinutes;
            const minutesRemaining = Math.ceil((lockoutEnd - now) / 60000);

            return {
                allowed: false,
                error: `Too many failed login attempts. Please try again in ${minutesRemaining} minute(s).`,
                minutesRemaining: minutesRemaining
            };
        }

        return { allowed: true };
    },

    /**
     * Clear login attempts after successful login
     *
     * @param {string} email - User email
     */
    clearLoginAttempts(email) {
        const key = `login_attempts_${email}`;
        localStorage.removeItem(key);
    }
};

// Export for use in other modules
if (typeof window !== 'undefined') {
    window.AuthService = AuthService;
}
