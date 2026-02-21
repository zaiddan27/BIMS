/**
 * Environment Configuration for BIMS
 *
 * NOTE: The Supabase anon key is designed for client-side use.
 * All data access is protected by Row Level Security (RLS) policies.
 * The anon key only grants access that RLS explicitly allows.
 */

const ENV = {
    // Supabase Configuration
    SUPABASE_URL: 'https://vreuvpzxnvrhftafmado.supabase.co',
    SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyZXV2cHp4bnZyaGZ0YWZtYWRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc3ODE1OTMsImV4cCI6MjA4MzM1NzU5M30.NvyPWk24eMnyTcKE_yMqG8Pgal5yxQhLYJuyJtGgSJg',

    // Environment
    NODE_ENV: 'production',

    // API Configuration
    API_TIMEOUT: 30000, // 30 seconds
};

// Freeze the object to prevent modifications
Object.freeze(ENV);

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ENV;
}
