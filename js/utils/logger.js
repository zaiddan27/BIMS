/**
 * Activity Logger - calls the log_action() RPC to record user actions.
 * Fire-and-forget: never blocks the UI or surfaces errors to the user.
 *
 * Auto-detects category and severity from the action string:
 *   - [AUDIT] prefix  → category: audit,  severity: WARN
 *   - Login/logout/signup/password → category: authentication
 *   - Delete/deactivate actions    → severity: WARN
 *   - Everything else              → category: general, severity: INFO
 */

// Category detection rules (order matters — first match wins)
const _categoryRules = [
    { test: /\[AUDIT\]/i,                            cat: 'audit',          sev: 'WARN'  },
    { test: /log(ged)?\s*(in|out)|sign(ed)?\s*(up|in)|password|otp/i, cat: 'authentication', sev: 'INFO'  },
    { test: /role|promot|demot|status|activat|deactivat/i,            cat: 'audit',          sev: 'WARN'  },
    { test: /delet|remov|permanent/i,                 cat: 'data_mutation',  sev: 'WARN'  },
    { test: /creat|upload|submit|insert|add/i,        cat: 'data_mutation',  sev: 'INFO'  },
    { test: /updat|edit|chang|archiv|restor|publish|unpublish|mark|start|cancel|reject|approv|featur|unfeatur/i, cat: 'data_mutation', sev: 'INFO' },
];

function _detectCategorySeverity(action) {
    for (const rule of _categoryRules) {
        if (rule.test.test(action)) return { cat: rule.cat, sev: rule.sev };
    }
    return { cat: 'general', sev: 'INFO' };
}

async function logAction(action, opts) {
    try {
        if (!action || typeof action !== 'string') return;

        const { cat, sev } = _detectCategorySeverity(action);

        const params = {
            p_action:     action.slice(0, 255),
            p_category:   opts?.category || cat,
            p_severity:   opts?.severity || sev,
            p_ip_address: null,
            p_user_agent: navigator.userAgent || null,
            p_metadata:   opts?.metadata || null,
        };

        // FK references (optional)
        if (opts?.replyId)        params.p_reply_id        = opts.replyId;
        if (opts?.postProjectId)  params.p_post_project_id = opts.postProjectId;
        if (opts?.applicationId)  params.p_application_id  = opts.applicationId;
        if (opts?.inquiryId)      params.p_inquiry_id      = opts.inquiryId;
        if (opts?.notificationId) params.p_notification_id = opts.notificationId;
        if (opts?.fileId)         params.p_file_id         = opts.fileId;
        if (opts?.testimonyId)    params.p_testimony_id    = opts.testimonyId;

        await supabaseClient.rpc('log_action', params);
    } catch (_) {
        // Silent — logging must never break the app
    }
}
