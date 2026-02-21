/**
 * Shared Sidebar Component
 * Renders navigation sidebar based on user role
 * Usage: <aside class="w-64 bg-white shadow-lg flex-shrink-0 h-screen flex flex-col" data-role="sk"></aside>
 *        <script src="js/components/sidebar.js"></script>
 */
(function () {
  var sidebar = document.querySelector('aside[data-role]');
  if (!sidebar) return;

  var role = sidebar.dataset.role;
  var currentPage = window.location.pathname.split('/').pop() || 'index.html';

  // SVG icon paths (d attributes)
  var ICONS = {
    dashboard: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3',
    files: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
    projects: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2',
    calendar: 'M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z',
    testimonies: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z',
    archive: 'M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4',
    certificates: 'M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z',
    announcements: 'M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z',
    approvals: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4',
    overview: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z',
    users: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z',
    logout: 'M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1'
  };

  // Navigation config per role
  var NAV_CONFIG = {
    sk: [
      { href: 'sk-dashboard.html', label: 'Dashboard', icon: 'dashboard', hoverBg: 'group-hover:bg-[#2f6e4e]/30', hoverIcon: '', strokeWidth: '2.5' },
      { href: 'sk-files.html', label: 'Manage Files', icon: 'files', hoverBg: 'group-hover:bg-blue-50', hoverIcon: 'group-hover:text-blue-600' },
      { href: 'sk-projects.html', label: 'Project Monitoring', icon: 'projects', hoverBg: 'group-hover:bg-purple-50', hoverIcon: 'group-hover:text-purple-600' },
      { href: 'sk-calendar.html', label: 'Calendar', icon: 'calendar', hoverBg: 'group-hover:bg-orange-50', hoverIcon: 'group-hover:text-orange-600' },
      { href: 'sk-testimonies.html', label: 'Testimonies', icon: 'testimonies', hoverBg: 'group-hover:bg-indigo-50', hoverIcon: 'group-hover:text-indigo-600' },
      { href: 'sk-archive.html', label: 'Archives', icon: 'archive', hoverBg: 'group-hover:bg-gray-200', hoverIcon: 'group-hover:text-gray-700' }
    ],
    youth: [
      { href: 'youth-dashboard.html', label: 'Dashboard', icon: 'dashboard', strokeWidth: '2.5' },
      { href: 'youth-files.html', label: 'Files', icon: 'files' },
      { href: 'youth-projects.html', label: 'Projects', icon: 'projects' },
      { href: 'youth-calendar.html', label: 'Calendar', icon: 'calendar' },
      { href: 'youth-certificates.html', label: 'Certificates', icon: 'certificates' }
    ],
    captain: [
      { action: "switchSection('dashboard')", label: 'Announcements', icon: 'announcements', strokeWidth: '2.5' },
      { action: "switchSection('approvals')", label: 'Project Approvals', icon: 'approvals' },
      { action: "switchSection('archives')", label: 'Archives', icon: 'archive' }
    ],
    superadmin: [
      { href: 'superadmin-dashboard.html', label: 'System Overview', icon: 'overview', strokeWidth: '2.5' },
      { href: 'superadmin-user-management.html', label: 'User Management', icon: 'users' },
      { href: 'superadmin-activity-logs.html', label: 'Activity Logs', icon: 'files' }
    ]
  };

  var items = NAV_CONFIG[role];
  if (!items) return;

  // Determine which style variant to use
  var isYouthOrCaptainOrAdmin = (role === 'youth' || role === 'captain' || role === 'superadmin');

  // Build navigation items HTML
  var navHTML = items.map(function (item) {
    var isActive = item.href ? (item.href === currentPage) : false;
    var sw = item.strokeWidth || '2';
    var iconPath = ICONS[item.icon] || '';

    if (isActive) {
      // Active state
      var activeIconBg = 'bg-[#2f6e4e]/20 ' + (item.hoverBg || 'group-hover:bg-[#2f6e4e]/30');
      var tag = item.action ? 'button' : 'a';
      var attr = item.action ? ' onclick="' + item.action + '"' : ' href="' + item.href + '"';
      var extraClass = item.action ? ' active-nav' : '';

      return '<' + tag + attr + ' class="nav-link' + extraClass + ' flex items-center space-x-3 px-4 py-3 bg-[#2f6e4e]/10 text-[#2f6e4e] rounded-lg font-medium group transition w-full' + (item.action ? ' text-left' : '') + '">' +
        '<div class="w-9 h-9 ' + activeIconBg + ' rounded-lg flex items-center justify-center transition">' +
        '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="' + sw + '">' +
        '<path stroke-linecap="round" stroke-linejoin="round" d="' + iconPath + '"></path></svg></div>' +
        '<span>' + item.label + '</span></' + tag + '>';
    } else {
      // Inactive state
      var inactiveLinkClass, inactiveIconBg, inactiveIconHover;

      if (role === 'sk') {
        inactiveLinkClass = 'text-gray-600 hover:bg-gray-50';
        inactiveIconBg = 'bg-gray-100';
        inactiveIconHover = item.hoverBg || 'group-hover:bg-gray-200';
        var iconHoverColor = item.hoverIcon || '';
      } else {
        inactiveLinkClass = 'text-gray-700 hover:bg-[#2f6e4e]/10 hover:text-[#2f6e4e]';
        inactiveIconBg = 'bg-gray-100';
        inactiveIconHover = 'group-hover:bg-[#2f6e4e]/20';
        var iconHoverColor = '';
      }

      var tag = item.action ? 'button' : 'a';
      var attr = item.action ? ' onclick="' + item.action + '"' : ' href="' + item.href + '"';

      return '<' + tag + attr + ' class="nav-link flex items-center space-x-3 px-4 py-3 ' + inactiveLinkClass + ' rounded-lg font-medium group transition w-full' + (item.action ? ' text-left' : '') + '">' +
        '<div class="w-9 h-9 ' + inactiveIconBg + ' rounded-lg flex items-center justify-center ' + inactiveIconHover + ' transition">' +
        '<svg class="w-5 h-5' + (iconHoverColor ? ' ' + iconHoverColor + ' transition' : '') + '" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="' + sw + '">' +
        '<path stroke-linecap="round" stroke-linejoin="round" d="' + iconPath + '"></path></svg></div>' +
        '<span>' + item.label + '</span></' + tag + '>';
    }
  }).join('');

  // Render full sidebar content
  sidebar.innerHTML =
    '<div class="p-6 flex-1 flex flex-col">' +
    '<div class="flex items-center space-x-4 mb-8">' +
    '<div class="w-12 h-12 bg-white rounded-xl flex items-center justify-center shadow-lg icon-badge overflow-hidden">' +
    '<img src="asset/logo.svg" alt="BIMS Logo" class="w-full h-full object-contain p-1">' +
    '</div><div><h1 class="text-xl font-black text-gray-800">BIMS</h1>' +
    '<p class="text-sm text-gray-600 font-medium">SK Malanday</p></div></div>' +
    '<nav class="space-y-2">' + navHTML + '</nav>' +
    '<div class="flex-1"></div>' +
    '<div class="mt-8 pt-8 border-t border-gray-200">' +
    '<button onclick="handleLogout()" class="nav-link flex items-center space-x-3 px-4 py-3 text-red-600 hover:bg-red-50 rounded-lg transition w-full group">' +
    '<div class="w-9 h-9 bg-red-50 rounded-lg flex items-center justify-center group-hover:bg-red-100 transition">' +
    '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">' +
    '<path stroke-linecap="round" stroke-linejoin="round" d="' + ICONS.logout + '"></path></svg></div>' +
    '<span class="font-medium">Logout</span></button></div></div>';

  // Captain sidebar: expose function to update active nav on section switch
  if (role === 'captain') {
    window.updateSidebarActive = function (section) {
      var btns = sidebar.querySelectorAll('nav .nav-link');
      btns.forEach(function (btn) {
        var isTarget = btn.getAttribute('onclick') === "switchSection('" + section + "')";
        if (isTarget) {
          btn.classList.add('active-nav', 'bg-[#2f6e4e]/10', 'text-[#2f6e4e]');
          btn.classList.remove('text-gray-700');
          var iconDiv = btn.querySelector('div');
          if (iconDiv) {
            iconDiv.classList.add('bg-[#2f6e4e]/20');
            iconDiv.classList.remove('bg-gray-100');
          }
        } else {
          btn.classList.remove('active-nav', 'bg-[#2f6e4e]/10', 'text-[#2f6e4e]');
          btn.classList.add('text-gray-700');
          var iconDiv = btn.querySelector('div');
          if (iconDiv) {
            iconDiv.classList.remove('bg-[#2f6e4e]/20');
            iconDiv.classList.add('bg-gray-100');
          }
        }
      });
    };
  }
})();
