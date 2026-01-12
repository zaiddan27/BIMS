/**
 * Supabase Client Configuration for BIMS
 *
 * This file initializes the Supabase client using the CDN version.
 * No npm or build process required.
 *
 * Usage in HTML files:
 * <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
 * <script src="js/config/env.js"></script>
 * <script src="js/config/supabase.js"></script>
 */

// Check if Supabase library is loaded
if (typeof supabase === 'undefined' && typeof window.supabase === 'undefined') {
    console.error('❌ Supabase library not loaded! Make sure to include the CDN script in your HTML.');
}

// Check if ENV is loaded
if (typeof ENV === 'undefined') {
    console.error('❌ ENV configuration not loaded! Make sure to include js/config/env.js before this file.');
}

// Initialize Supabase client
const supabaseClient = window.supabase.createClient(
    ENV.SUPABASE_URL,
    ENV.SUPABASE_ANON_KEY,
    {
        auth: {
            autoRefreshToken: true,
            persistSession: true,
            detectSessionInUrl: true,
            storage: window.localStorage, // Use localStorage for session persistence
        },
        global: {
            headers: {
                'X-Client-Info': 'bims-web-app',
            },
        },
    }
);

// Helper function to check connection
async function testSupabaseConnection() {
    try {
        console.log('🔄 Testing Supabase connection...');

        // Try to query a simple table (this will fail if no tables exist yet, but connection works)
        const { data, error } = await supabaseClient.from('users').select('count', { count: 'exact', head: true });

        if (error && error.code !== 'PGRST116') {
            // PGRST116 = table doesn't exist yet (expected in Phase 1)
            console.warn('⚠️  Supabase connected, but query failed:', error.message);
            console.log('This is normal if you haven\'t created database tables yet.');
        } else {
            console.log('✅ Supabase connection successful!');
        }

        return true;
    } catch (err) {
        console.error('❌ Supabase connection failed:', err.message);
        return false;
    }
}

// Log connection status (for debugging)
console.log('🚀 Supabase client initialized');
console.log('📍 Project URL:', ENV.SUPABASE_URL);
console.log('🔑 API Key configured:', ENV.SUPABASE_ANON_KEY ? '✓ Yes' : '✗ No (please update env.js)');

// Export for global use
window.supabaseClient = supabaseClient;
window.testSupabaseConnection = testSupabaseConnection;
