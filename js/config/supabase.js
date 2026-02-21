/**
 * Supabase Client Configuration for BIMS
 *
 * This file initializes the Supabase client using the CDN version.
 *
 * Usage in HTML files:
 * <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
 * <script src="js/config/env.js"></script>
 * <script src="js/config/supabase.js"></script>
 */

// Initialize Supabase client
const supabaseClient = window.supabase.createClient(
    ENV.SUPABASE_URL,
    ENV.SUPABASE_ANON_KEY,
    {
        auth: {
            autoRefreshToken: true,
            persistSession: true,
            detectSessionInUrl: true,
            storage: window.localStorage,
        },
        global: {
            headers: {
                'X-Client-Info': 'bims-web-app',
            },
        },
    }
);

// Export for global use
window.supabaseClient = supabaseClient;
