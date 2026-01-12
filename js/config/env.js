/**
 * Environment Configuration for BIMS
 *
 * IMPORTANT SECURITY NOTE:
 * - In production, these values should come from environment variables
 * - For development, we load from a config object
 * - NEVER commit actual API keys to Git
 *
 * TODO: Replace these placeholder values with your actual Supabase credentials
 */

const ENV = {
    // Supabase Configuration
    SUPABASE_URL: 'https://vreuvpzxnvrhftafmado.supabase.co',
    SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyZXV2cHp4bnZyaGZ0YWZtYWRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc3ODE1OTMsImV4cCI6MjA4MzM1NzU5M30.NvyPWk24eMnyTcKE_yMqG8Pgal5yxQhLYJuyJtGgSJg',

    // Environment
    NODE_ENV: 'development', // 'development' or 'production'

    // API Configuration
    API_TIMEOUT: 30000, // 30 seconds
};

// Freeze the object to prevent modifications
Object.freeze(ENV);

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ENV;
}
