/**
 * BIMS Mobile Navigation
 * Creates responsive navigation for tablet and mobile devices
 * Desktop (>= 1024px): No changes, original layout preserved
 * Tablet/Mobile (< 1024px): Hamburger menu with slide-out sidebar
 */

(function() {
  'use strict';

  // Only run on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  function init() {
    // Find the sidebar
    const sidebar = document.querySelector('aside');
    if (!sidebar) return; // No sidebar on this page, exit

    // Add sidebar class for CSS targeting
    sidebar.classList.add('sidebar');

    // Create mobile navigation elements
    createMobileElements(sidebar);

    // Setup all event handlers
    setupEvents(sidebar);

    // Initial check for screen size
    handleResize();
    window.addEventListener('resize', debounce(handleResize, 100));
  }

  function createMobileElements(sidebar) {
    // Don't create if already exists
    if (document.querySelector('.mobile-nav')) return;

    // Try to find logo in sidebar
    const logo = sidebar.querySelector('img[alt*="logo" i], img[src*="logo"]');
    const logoHTML = logo
      ? `<img src="${logo.src}" alt="${logo.alt || 'BIMS'}" class="h-8">`
      : '<span class="font-bold text-lg">BIMS</span>';

    // Create mobile navigation bar
    const mobileNav = document.createElement('div');
    mobileNav.className = 'mobile-nav';
    mobileNav.innerHTML = `
      <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Open menu" type="button">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16"/>
        </svg>
      </button>
      ${logoHTML}
      <div style="width: 44px; opacity: 0;"></div>
    `;

    // Create backdrop overlay
    const overlay = document.createElement('div');
    overlay.className = 'mobile-sidebar-overlay';
    overlay.id = 'mobileOverlay';

    // Insert into DOM
    document.body.insertBefore(mobileNav, document.body.firstChild);
    document.body.appendChild(overlay);
  }

  function setupEvents(sidebar) {
    const menuBtn = document.getElementById('mobileMenuBtn');
    const overlay = document.getElementById('mobileOverlay');

    if (!menuBtn || !overlay) return;

    // Toggle sidebar on menu button click
    menuBtn.addEventListener('click', () => toggleSidebar(sidebar, overlay));

    // Close on overlay click
    overlay.addEventListener('click', () => closeSidebar(sidebar, overlay));

    // Close on ESC key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && sidebar.classList.contains('active')) {
        closeSidebar(sidebar, overlay);
      }
    });

    // Close when clicking navigation links to OTHER pages only (better UX)
    sidebar.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', (e) => {
        if (window.innerWidth < 1024) {
          // Only close if navigating to a different page
          const currentPage = window.location.pathname.split('/').pop();
          const targetPage = link.getAttribute('href');

          // Check if it's an external navigation (different page)
          if (targetPage && !targetPage.startsWith('#') && targetPage !== currentPage) {
            closeSidebar(sidebar, overlay);
          }
        }
      });
    });

    // Swipe to close gesture
    let touchStartX = 0;
    sidebar.addEventListener('touchstart', (e) => {
      touchStartX = e.touches[0].clientX;
    }, { passive: true });

    sidebar.addEventListener('touchend', (e) => {
      const touchEndX = e.changedTouches[0].clientX;
      const swipeDistance = touchEndX - touchStartX;

      // Swipe left to close (more than 60px)
      if (swipeDistance < -60 && sidebar.classList.contains('active')) {
        closeSidebar(sidebar, overlay);
      }
    }, { passive: true });
  }

  function toggleSidebar(sidebar, overlay) {
    if (sidebar.classList.contains('active')) {
      closeSidebar(sidebar, overlay);
    } else {
      openSidebar(sidebar, overlay);
    }
  }

  function openSidebar(sidebar, overlay) {
    sidebar.classList.add('active');
    overlay.classList.add('active');

    // FIX: Only prevent scrolling on the body when sidebar is open
    // This prevents background scroll while keeping page scrollable when sidebar is closed
    document.body.style.overflow = 'hidden';
    document.body.style.position = 'fixed';
    document.body.style.width = '100%';
    document.body.dataset.scrollY = window.scrollY.toString();
    document.body.style.top = `-${window.scrollY}px`;

    // Update button aria
    const btn = document.getElementById('mobileMenuBtn');
    if (btn) btn.setAttribute('aria-label', 'Close menu');
  }

  function closeSidebar(sidebar, overlay) {
    sidebar.classList.remove('active');
    overlay.classList.remove('active');

    // FIX: Restore scrolling and scroll position
    const scrollY = document.body.dataset.scrollY || '0';
    document.body.style.overflow = '';
    document.body.style.position = '';
    document.body.style.width = '';
    document.body.style.top = '';
    window.scrollTo(0, parseInt(scrollY));

    // Update button aria
    const btn = document.getElementById('mobileMenuBtn');
    if (btn) btn.setAttribute('aria-label', 'Open menu');
  }

  function handleResize() {
    const sidebar = document.querySelector('aside.sidebar');
    const overlay = document.getElementById('mobileOverlay');

    if (!sidebar || !overlay) return;

    // Auto-close sidebar when resizing to desktop
    if (window.innerWidth >= 1024 && sidebar.classList.contains('active')) {
      closeSidebar(sidebar, overlay);
    }
  }

  // Utility: Debounce function
  function debounce(func, wait) {
    let timeout;
    return function(...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }

})();
