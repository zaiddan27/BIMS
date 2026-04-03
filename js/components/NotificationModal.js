/**
 * Notification Modal Component
 * Reusable notification modal for all dashboards
 *
 * Usage:
 *   import { NotificationModal } from './components/NotificationModal.js';
 *   const modal = new NotificationModal();
 *   modal.render();
 */

export class NotificationModal {
  constructor() {
    this.modalId = "notificationModal";
    this.notifications = [];
  }

  /**
   * Returns the HTML template for the notification modal
   */
  getTemplate() {
    return `
      <!-- Notification Modal -->
      <div
        id="${this.modalId}"
        class="hidden fixed inset-0 md:inset-auto md:top-16 md:right-4 bg-black bg-opacity-40 md:bg-transparent z-50 flex items-center justify-center md:justify-end md:items-start p-4"
        role="dialog"
        aria-modal="true"
        aria-labelledby="notificationModalTitle"
        onclick="window.notificationModal.close()"
      >
        <div
          class="bg-white rounded-xl shadow-2xl max-w-md w-full md:w-96 max-h-[90vh] md:max-h-[85vh] overflow-hidden flex flex-col"
          onclick="event.stopPropagation()"
        >
          <div class="p-4 border-b border-gray-200 flex items-center justify-between flex-shrink-0">
            <h3 id="notificationModalTitle" class="font-bold text-gray-800">Notifications</h3>
            <div class="flex items-center gap-3">
              <button
                onclick="window.notificationModal.markAllAsRead()"
                class="text-xs text-[#2f6e4e] hover:text-[#2f6e4e] font-medium"
              >
                Mark all as read
              </button>
              <button
                onclick="window.notificationModal.close()"
                class="text-gray-400 hover:text-gray-600 transition"
              >
                ✕
              </button>
            </div>
          </div>

          <div id="notificationList" class="overflow-y-auto flex-1">
            <!-- Notifications will be dynamically inserted here -->
          </div>
        </div>
      </div>
    `;
  }

  /**
   * Renders the notification modal into the DOM
   */
  render() {
    // Check if modal already exists
    if (document.getElementById(this.modalId)) {
      return;
    }

    // Insert modal at the end of body
    document.body.insertAdjacentHTML("beforeend", this.getTemplate());

    // Make instance globally accessible
    window.notificationModal = this;
  }

  /**
   * Opens the notification modal
   */
  open() {
    const modal = document.getElementById(this.modalId);
    if (modal) {
      modal.classList.remove("hidden");
      this.loadNotifications();
    }
  }

  /**
   * Closes the notification modal
   */
  close() {
    const modal = document.getElementById(this.modalId);
    if (modal) {
      modal.classList.add("hidden");
    }
  }

  /**
   * Toggles the notification modal
   */
  toggle() {
    const modal = document.getElementById(this.modalId);
    if (modal) {
      modal.classList.toggle("hidden");
      if (!modal.classList.contains("hidden")) {
        this.loadNotifications();
      }
    }
  }

  /**
   * Loads notifications from backend
   */
  async loadNotifications() {
    try {
      // Get current user
      const {
        data: { user },
      } = await supabaseClient.auth.getUser();
      if (!user) return;

      // Fetch notifications from database
      const { data: notifications, error } = await supabaseClient
        .from("Notification_Tbl")
        .select("*")
        .eq("userID", user.id)
        .order("createdAt", { ascending: false })
        .limit(20);

      if (error) throw error;

      this.notifications = notifications || [];
      this.renderNotifications();
      this.updateBadgeCount();
    } catch (error) {
      this.showError("Failed to load notifications");
    }
  }

  /**
   * Renders the list of notifications
   */
  renderNotifications() {
    const container = document.getElementById("notificationList");
    if (!container) return;

    if (this.notifications.length === 0) {
      container.innerHTML = `
        <div class="p-8 text-center text-gray-500">
          <svg class="w-16 h-16 mx-auto mb-3 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path>
          </svg>
          <p class="font-medium">No notifications yet</p>
          <p class="text-sm mt-1">We'll notify you when something happens</p>
        </div>
      `;
      return;
    }

    container.innerHTML = this.notifications
      .map((notif) => this.getNotificationHTML(notif))
      .join("");
  }

  /**
   * Returns HTML for a single notification
   */
  getNotificationHTML(notif) {
    const isUnread = !notif.isRead;
    const bgClass = isUnread
      ? "bg-blue-50 hover:bg-blue-100"
      : "bg-white hover:bg-gray-50";
    const timeAgo = this.formatTimeAgo(notif.createdAt);

    return `
      <div
        class="${bgClass} p-4 border-b border-gray-100 cursor-pointer transition"
        onclick="window.notificationModal.handleNotificationClick(${
          notif.notificationID
        })"
      >
        <div class="flex items-start gap-3">
          ${this.getNotificationIcon(notif.notificationType)}
          <div class="flex-1 min-w-0">
            <div class="flex items-start justify-between gap-2">
              <p class="font-medium text-gray-800 text-sm">
                ${this.escapeHtml(notif.title)}
              </p>
              ${
                isUnread
                  ? '<div class="w-2 h-2 bg-blue-600 rounded-full flex-shrink-0 mt-1"></div>'
                  : ""
              }
            </div>
            <p class="text-xs text-gray-500 mt-1">${timeAgo}</p>
          </div>
        </div>
      </div>
    `;
  }

  /**
   * Returns icon HTML based on notification type
   */
  getNotificationIcon(type) {
    const icons = {
      new_announcement: `
        <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z"></path>
          </svg>
        </div>
      `,
      new_inquiry: `
        <div class="w-10 h-10 bg-yellow-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
      `,
      new_project: `
        <div class="w-10 h-10 bg-[#2f6e4e]/20 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-[#2f6e4e]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
          </svg>
        </div>
      `,
      application_approved: `
        <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
      `,
      application_rejected: `
        <div class="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
      `,
      application_pending: `
        <div class="w-10 h-10 bg-yellow-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
      `,
      new_user_signup: `
        <div class="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path>
          </svg>
        </div>
      `,
      account_status_change: `
        <div class="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
          </svg>
        </div>
      `,
      role_change: `
        <div class="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
          </svg>
        </div>
      `,
      new_project_created: `
        <div class="w-10 h-10 bg-[#2f6e4e]/20 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-[#2f6e4e]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
          </svg>
        </div>
      `,
      default: `
        <div class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path>
          </svg>
        </div>
      `,
    };

    return icons[type] || icons.default;
  }

  /**
   * Handles click on a notification — marks as read and navigates to relevant page
   */
  async handleNotificationClick(notificationId) {
    try {
      // Mark as read
      await this.markAsRead(notificationId);

      // Find notification
      const notif = this.notifications.find(
        (n) => n.notificationID === notificationId
      );
      if (!notif) return;

      // Close the modal
      this.close();

      // Route based on notification type
      const route = this.getRouteForNotification(notif);
      if (!route) return;

      // Determine current page
      const currentPage = window.location.pathname.split("/").pop() || "";

      if (currentPage === route.page) {
        // Already on the correct page — handle locally without full reload
        this.handleLocalNavigation(route);
      } else {
        // Navigate to the target page with query parameters
        const params = new URLSearchParams();
        if (route.projectId) params.set("projectId", route.projectId);
        if (route.tab) params.set("tab", route.tab);

        const queryString = params.toString();
        window.location.href = route.page + (queryString ? "?" + queryString : "");
      }
    } catch (error) {
      // Notification click handling failed silently
    }
  }

  /**
   * Maps notification type to destination page and parameters
   */
  getRouteForNotification(notif) {
    const referenceID = notif.referenceID;

    const routeMap = {
      new_application: {
        page: "sk-projects.html",
        projectId: referenceID,
        tab: "applications",
      },
      project_awaiting_approval: {
        page: "captain-dashboard.html",
        projectId: referenceID,
      },
      project_approved: {
        page: "sk-projects.html",
        projectId: referenceID,
      },
      project_rejected: {
        page: "sk-projects.html",
        projectId: referenceID,
      },
      revision_requested: {
        page: "sk-projects.html",
        projectId: referenceID,
      },
      application_approved: {
        page: "youth-projects.html",
        projectId: referenceID,
      },
      application_pending: {
        page: "youth-projects.html",
        projectId: referenceID,
      },
      application_rejected: {
        page: "youth-projects.html",
        projectId: referenceID,
      },
      inquiry_update: {
        page: "youth-projects.html",
        projectId: referenceID,
        tab: "inquiries",
      },
      new_inquiry: {
        page: "sk-projects.html",
        projectId: referenceID,
        tab: "inquiries",
      },
      new_project: {
        page: "youth-projects.html",
        projectId: referenceID,
      },
      // Superadmin notification types
      new_user_signup: {
        page: "superadmin-user-management.html",
      },
      account_status_change: {
        page: "superadmin-user-management.html",
      },
      role_change: {
        page: "superadmin-user-management.html",
      },
      new_project_created: {
        page: "superadmin-dashboard.html",
      },
    };

    const route = routeMap[notif.notificationType];

    // Types without a route (new_announcement, user_promoted, etc.) — no navigation
    if (!route || !route.page) return null;

    // If referenceID is missing (legacy notification), still navigate to page but skip deep link
    if (!route.projectId) {
      return { page: route.page };
    }

    return route;
  }

  /**
   * Handles navigation when already on the target page (avoids full reload)
   */
  handleLocalNavigation(route) {
    if (!route.projectId) return;

    const currentPage = window.location.pathname.split("/").pop() || "";
    const projectId = parseInt(route.projectId);

    if (currentPage === "sk-projects.html") {
      if (typeof window.viewProject === "function") {
        window.viewProject(projectId);
        if (route.tab) {
          requestAnimationFrame(() => {
            requestAnimationFrame(() => {
              if (typeof window.switchTab === "function") {
                // URL param "applications" maps to internal tab name "applicants"
                const tabMap = { applications: "applicants", inquiries: "inquiries" };
                window.switchTab(tabMap[route.tab] || route.tab);
              }
            });
          });
        }
      }
    } else if (currentPage === "youth-projects.html") {
      if (typeof window.viewProject === "function") {
        window.viewProject(projectId);
        if (route.tab) {
          requestAnimationFrame(() => {
            requestAnimationFrame(() => {
              if (typeof window.switchTab === "function") {
                window.switchTab(route.tab);
              }
            });
          });
        }
      }
    } else if (currentPage === "captain-dashboard.html") {
      if (typeof window.viewProjectDetails === "function") {
        // May need to load approvals section first
        if (typeof window.switchSection === "function") {
          window.switchSection("approvals");
        }
        // Wait for projects to load, then open the specific project
        const waitForLoad = setInterval(() => {
          if (typeof window.viewProjectDetails === "function") {
            clearInterval(waitForLoad);
            setTimeout(() => window.viewProjectDetails(projectId), 300);
          }
        }, 100);
        setTimeout(() => clearInterval(waitForLoad), 5000);
      }
    } else {
      // Fallback: reload with URL parameters
      const params = new URLSearchParams();
      if (route.projectId) params.set("projectId", route.projectId);
      if (route.tab) params.set("tab", route.tab);
      window.location.href = currentPage + "?" + params.toString();
    }
  }

  /**
   * Marks a notification as read
   */
  async markAsRead(notificationId) {
    try {
      const { error } = await supabaseClient
        .from("Notification_Tbl")
        .update({ isRead: true })
        .eq("notificationID", notificationId);

      if (error) throw error;

      // Update local state
      const notif = this.notifications.find(
        (n) => n.notificationID === notificationId
      );
      if (notif) {
        notif.isRead = true;
      }

      this.updateBadgeCount();
    } catch (error) {
      // Mark as read failed silently
    }
  }

  /**
   * Marks all notifications as read
   */
  async markAllAsRead() {
    try {
      const {
        data: { user },
      } = await supabaseClient.auth.getUser();
      if (!user) return;

      const { error } = await supabaseClient
        .from("Notification_Tbl")
        .update({ isRead: true })
        .eq("userID", user.id)
        .eq("isRead", false);

      if (error) throw error;

      // Update local state
      this.notifications.forEach((notif) => (notif.isRead = true));

      this.renderNotifications();
      this.updateBadgeCount();
    } catch (error) {
      // Mark all as read failed silently
    }
  }

  /**
   * Updates the notification badge count
   */
  updateBadgeCount() {
    const badge = document.getElementById("notificationBadge");
    if (!badge) return;

    const unreadCount = this.notifications.filter((n) => !n.isRead).length;

    if (unreadCount > 0) {
      badge.textContent = unreadCount > 99 ? "99+" : unreadCount;
      badge.classList.remove("hidden");
    } else {
      badge.classList.add("hidden");
    }
  }

  // Formats timestamp to relative time

  formatTimeAgo(timestamp) {
    const date = new Date(timestamp);
    const now = new Date();
    const diffMs = now - date;
    const diffSec = Math.floor(diffMs / 1000);
    const diffMin = Math.floor(diffSec / 60);
    const diffHour = Math.floor(diffMin / 60);
    const diffDay = Math.floor(diffHour / 24);

    if (diffSec < 60) return "Just now";
    if (diffMin < 60) return `${diffMin}m ago`;
    if (diffHour < 24) return `${diffHour}h ago`;
    if (diffDay < 7) return `${diffDay}d ago`;
    if (diffDay < 30) return `${Math.floor(diffDay / 7)}w ago`;
    return date.toLocaleDateString();
  }

  //Escapes HTML to prevent XSS

  escapeHtml(text) {
    const div = document.createElement("div");
    div.textContent = text;
    return div.innerHTML;
  }

  //Shows error message

  showError(message) {
    const container = document.getElementById("notificationList");
    if (!container) return;

    container.innerHTML = `
      <div class="p-8 text-center text-red-600">
        <svg class="w-16 h-16 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        <p class="font-medium">${this.escapeHtml(message)}</p>
      </div>
    `;
  }

  /**
   * Destroys the notification modal
   */
  destroy() {
    const modal = document.getElementById(this.modalId);
    if (modal) {
      modal.remove();
    }
    window.notificationModal = null;
  }
}
