/**
 * Focus Trap Utility for Modals
 * Traps keyboard focus inside open modals for accessibility
 *
 * Usage:
 *   FocusTrap.activate(modalElement)   — call when modal opens
 *   FocusTrap.deactivate()             — call when modal closes
 */
var FocusTrap = (function () {
  var activeModal = null;
  var previousFocus = null;

  var FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';

  function activate(modal) {
    if (!modal) return;
    activeModal = modal;
    previousFocus = document.activeElement;

    // Focus first focusable element inside modal
    var focusable = modal.querySelectorAll(FOCUSABLE);
    if (focusable.length > 0) {
      focusable[0].focus();
    }

    document.addEventListener('keydown', handleKeydown);
  }

  function deactivate() {
    document.removeEventListener('keydown', handleKeydown);

    // Restore focus to the element that opened the modal
    if (previousFocus && typeof previousFocus.focus === 'function') {
      previousFocus.focus();
    }

    activeModal = null;
    previousFocus = null;
  }

  function handleKeydown(e) {
    if (!activeModal) return;

    // ESC key closes modal
    if (e.key === 'Escape') {
      var closeBtn = activeModal.querySelector('[onclick*="close"], [onclick*="Close"], [onclick*="hidden"]');
      if (closeBtn) {
        closeBtn.click();
      } else {
        // Try clicking the modal backdrop itself
        activeModal.classList.add('hidden');
      }
      deactivate();
      return;
    }

    // Tab key trapping
    if (e.key === 'Tab') {
      var focusable = Array.from(activeModal.querySelectorAll(FOCUSABLE)).filter(function (el) {
        return el.offsetParent !== null; // visible only
      });

      if (focusable.length === 0) return;

      var first = focusable[0];
      var last = focusable[focusable.length - 1];

      if (e.shiftKey) {
        // Shift+Tab: wrap from first to last
        if (document.activeElement === first) {
          e.preventDefault();
          last.focus();
        }
      } else {
        // Tab: wrap from last to first
        if (document.activeElement === last) {
          e.preventDefault();
          first.focus();
        }
      }
    }
  }

  return {
    activate: activate,
    deactivate: deactivate
  };
})();
