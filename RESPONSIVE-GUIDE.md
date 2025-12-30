# BIMS Responsive Design Guide

## Overview

BIMS uses a **desktop-first** responsive approach that preserves all existing desktop layouts while adding mobile and tablet optimizations.

**Key Principle:** Desktop view (>= 1024px) is completely untouched. All responsive changes only apply to smaller screens.

---

## Breakpoints

| Device | Width | Behavior |
|--------|-------|----------|
| Desktop/Laptop | >= 1024px | **Original layout preserved** - no changes |
| Tablet | 768px - 1023px | Hamburger menu, 2-column grids, slide-out sidebar |
| Mobile | < 768px | Hamburger menu, single-column grids, optimized spacing |

---

## Files

### `css/responsive.css`

Location: `/css/responsive.css`

**Purpose:** Centralized responsive styles that only activate on tablet/mobile.

**Key Features:**
- Mobile nav bar (hidden on desktop)
- Sidebar transforms to slide-out drawer (only < 1024px)
- Grid adjustments for smaller screens
- Touch target optimizations
- Form input sizing (prevents iOS zoom)

### `js/mobile-nav.js`

Location: `/js/mobile-nav.js`

**Purpose:** Creates hamburger menu and handles sidebar toggle.

**Key Features:**
- Auto-creates mobile navigation bar
- Slide-out sidebar with overlay
- Swipe-to-close gesture
- ESC key support
- Auto-close on navigation

---

## Desktop View (>= 1024px)

**No changes applied.** The desktop view remains exactly as it was before responsive implementation:

- Original sidebar always visible
- Original grid layouts (4-5 columns)
- Original spacing and padding
- No hamburger menu visible
- No overlay elements interfere

---

## Tablet View (768px - 1023px)

**Changes Applied:**
- Hamburger menu appears in fixed header
- Sidebar hidden, accessible via hamburger
- Statistics cards: 2 columns
- Forms: Maintain 2-column layouts
- Touch-friendly sizing

---

## Mobile View (< 768px)

**Changes Applied:**
- Hamburger menu in fixed header
- Sidebar slides in from left
- Statistics cards: Single column
- Forms: Single column
- Reduced padding (1.25rem instead of 2rem)
- 16px font inputs (prevents iOS zoom)
- Toast notifications repositioned

---

## Mobile Navigation Behavior

### How It Works:

1. **On page load:**
   - Detects sidebar element
   - Creates mobile nav bar (hidden on desktop via CSS)
   - Creates overlay element

2. **On tablet/mobile (< 1024px):**
   - Mobile nav bar becomes visible
   - Hamburger button toggles sidebar

3. **Sidebar interactions:**
   - Click hamburger → Sidebar slides in
   - Click overlay → Sidebar closes
   - Press ESC → Sidebar closes
   - Swipe left → Sidebar closes
   - Click nav link → Sidebar closes

4. **On resize to desktop:**
   - Sidebar auto-closes
   - Mobile nav becomes hidden
   - Original desktop layout restored

---

## Utility Classes

```html
<!-- Hide on mobile/tablet, show on desktop -->
<div class="hide-mobile">Desktop only</div>

<!-- Show on mobile/tablet, hide on desktop -->
<div class="show-mobile">Mobile/Tablet only</div>

<!-- Hide only on phone -->
<div class="hide-phone">Tablet and desktop</div>
```

---

## Testing

### Desktop (>= 1024px)
- [ ] No hamburger menu visible
- [ ] Sidebar always visible
- [ ] Original grid layouts (4-5 columns)
- [ ] Original spacing and padding
- [ ] Everything looks exactly as before

### Tablet (768px - 1023px)
- [ ] Hamburger menu visible in green header
- [ ] Sidebar hidden until hamburger clicked
- [ ] 2-column grid layouts
- [ ] Sidebar slides in smoothly

### Mobile (< 768px)
- [ ] Hamburger menu visible
- [ ] Single column layouts
- [ ] Sidebar works with swipe gesture
- [ ] Reduced padding looks good

---

## Implementation Details

### CSS Architecture

```css
/* Mobile nav hidden by default */
.mobile-nav {
  display: none;
}

/* Only show on tablet/mobile */
@media (max-width: 1023px) {
  .mobile-nav {
    display: flex;
  }
}
```

### JavaScript Architecture

```javascript
// Creates elements but CSS controls visibility
function createMobileElements() {
  // Creates .mobile-nav (CSS hides on desktop)
  // Creates .mobile-sidebar-overlay
}
```

---

## Troubleshooting

### Hamburger showing on desktop?
- Check if `responsive.css` is loaded
- Verify CSS has `display: none` for `.mobile-nav`
- Check no conflicting styles override it

### Desktop layout broken?
- All responsive styles should be inside media queries
- No `!important` rules affecting desktop
- Check browser cache (hard refresh: Ctrl+Shift+R)

### Sidebar not sliding on mobile?
- Verify `mobile-nav.js` is loaded
- Check browser console for errors
- Ensure sidebar has `aside` element

---

## Recent Updates

### 2025-12-30: Device-Specific Optimizations (v3.0)
**Major Update:** Complete device-specific responsive design for all 4 target devices.

**Target Devices:**
1. PHONE-BIMS: 375×812
2. PHONE-BIMS-LARGE: 430×932
3. TABLET-BIMS: 768×1024 (portrait)
4. TABLET-BIMS-LANDSCAPE: 1024×768 (landscape)

**Key Fixes:**
- **CRITICAL:** Tablet landscape (1024×768) now shows hamburger menu (was showing desktop sidebar)
- Phone optimizations: Progressive spacing reduction, compact design
- Typography scaling per device
- Grid column strategies per device (1, 2, or 3 columns)

**See:** `DEVICE-RESPONSIVE-GUIDE.md` for comprehensive device-specific documentation.

### 2025-12-30: Mobile Scroll Fix (v2.1)
**Critical Issue Fixed:** Mobile and tablet devices couldn't scroll due to `overflow-hidden` on parent container.

**Changes Made:**
- Removed `overflow-hidden` constraint on mobile/tablet
- Changed `h-screen` to `height: auto` with `min-height: 100vh`
- Added iOS Safari viewport height fix
- Enhanced scroll position preservation in sidebar

**See:** `MOBILE-SCROLL-FIX-GUIDE.md` for scroll troubleshooting.

---

**Last Updated:** 2025-12-30
**Version:** 3.0 (Device-specific optimizations)
