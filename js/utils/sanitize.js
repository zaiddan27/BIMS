/**
 * Shared Sanitization Utilities
 * Used across all pages for XSS prevention
 */

/**
 * Escapes HTML special characters to prevent XSS
 * @param {string} str - The string to escape
 * @returns {string} HTML-escaped string
 */
function escapeHTML(str) {
  if (!str) return '';
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}

/**
 * Handles avatar image load errors by showing initials
 * Replaces fragile inline onerror="this.parentElement.innerHTML=..." patterns
 * @param {HTMLImageElement} img - The img element that failed to load
 * @param {string} initials - Fallback initials to display
 */
function handleAvatarError(img, initials) {
  const parent = img.parentElement;
  if (parent) {
    parent.innerHTML = '<span class="text-white font-semibold">' + escapeHTML(initials) + '</span>';
  }
}
