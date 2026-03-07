# SPMP Reconstructed Sections - Copy-Paste Ready

Below are the sections from the SPMP that need to be replaced. Copy-paste these directly into the SPMP document, replacing the corresponding old sections.

---

## Section: B.3 Technical Feasibility Analysis (Replace the summary and conclusion)

Technology Maturity: All components (Supabase, PostgreSQL, Tailwind CSS, Vanilla JavaScript) are mature and production-ready
Team Capability: Adequate baseline skills; manageable learning gaps
Infrastructure: Supabase free tier and Netlify free tier resources sufficient for pilot deployment
Conclusion: Technically feasible. Proceed with selected technology stack.

---

## Table 10: Technical Requirements (Replace entire table)

| Hardware Requirements | The barangay office requires at least one computer workstation with minimum specifications (Intel Core i3 or equivalent, 8GB RAM, 500GB storage) for system administration and content management. Staff members will need their own workstations or laptops with similar specifications to access and manage content through the web-based interface. All staff computers require a stable internet connection to access the Supabase-hosted backend and Netlify-deployed frontend. A reliable internet service provider (ISP) subscription is essential for daily operations. |
| --- | --- |
| Software Requirements | The system frontend is deployed on Netlify's static hosting CDN, which serves the HTML, CSS, and JavaScript files globally with automatic SSL. The backend uses Supabase, a Backend-as-a-Service platform that provides a managed PostgreSQL database, authentication, file storage, and real-time capabilities. Staff members require a modern web browser (Google Chrome, Mozilla Firefox, or Microsoft Edge - latest versions) installed on their workstations to access the system. File management, content updates, and administrative functions are handled through the web-based interface with secure JWT-based authentication protocols. |
| Network Infrastructure | A stable and reliable internet connection with a minimum bandwidth of 10 Mbps (20 Mbps or higher recommended) is essential for accessing the Netlify-hosted frontend and Supabase backend. The barangay office must have a dependable Internet Service Provider (ISP) subscription to ensure consistent connectivity for all staff members accessing the web-based platform. As for the network setup, the barangay office requires a wireless router with sufficient capacity to support multiple concurrent users (minimum 5-10 devices). Staff members using laptops can connect via Wi-Fi, while desktop workstations may use wired Ethernet connections for more stable connectivity if preferred. |
| Security Requirements | Implementation of SSL/TLS certificates (auto-provisioned by Netlify) for encrypted data transmission, Row Level Security (RLS) policies enforced at the PostgreSQL database level for role-based access control, and Supabase Auth for secure JWT-based session management. Password policies and session management protect sensitive barangay information. Two-factor authentication (2FA) via OTP is implemented for all user accounts using the Gmail API, ensuring compliance with data privacy regulations. User passwords are securely hashed using bcrypt through Supabase Auth, ensuring that even in the event of a database compromise, the actual passwords cannot be reversed or reconstructed by unauthorized parties. Additionally, a `prevent_role_escalation()` database trigger prevents unauthorized role changes by non-SUPERADMIN users. |

---

## Table 11: Technical Feasibility Analysis (Replace relevant rows)

| Development Tools | The development team utilizes Visual Studio Code as the primary Integrated Development Environment (IDE) for efficient coding and debugging. Version control through Git/GitHub manages code changes and enables collaborative development. Netlify CI/CD provides automatic deployments on push to the main branch. The team utilizes Trello for project management and task tracking. |
| --- | --- |
| Programming Languages & Frameworks | Front-end: HTML5, CSS3, and JavaScript with Tailwind CSS for responsive design and modern utility-first styling. Vanilla JavaScript handles dynamic user interactions, form validations, and asynchronous operations for a smooth user experience across desktop and mobile devices. Back-end: Supabase provides the complete backend infrastructure including PostgreSQL database, authentication, file storage, and real-time subscriptions. The Supabase JavaScript client library (`@supabase/supabase-js`) handles all client-server communication via REST API. No custom server-side code is required — all business logic is enforced through PostgreSQL Row Level Security (RLS) policies and database triggers. |
| Database Management System | PostgreSQL (managed by Supabase) handles data storage for barangay records, document metadata, projects, and user information. The Supabase Dashboard provides an intuitive web-based interface for database administration, including a SQL editor, table editor, and real-time logs. The database stores structured data (user records, project details, user accounts, file metadata) while actual document files are stored in Supabase Storage buckets (avatars, project-images, consent-files) with only their metadata and URLs stored in the database. The system implements proper indexing, RLS policies, and query optimization to ensure fast performance as data grows. |
| Content Management System | Integration of file upload/download functionality supporting various formats (PDF, XLSX, JPG, PNG, DOC). Files are stored in Supabase Storage with metadata tracked in the database. Document categorization by type (GENERAL, PROJECT) for easy retrieval. Search functionality with filters for quick access to barangay records and projects. |
| Mobile Responsiveness | Tailwind CSS is utilized to ensure the system is fully responsive and accessible on smartphones and tablets. This allows barangay staff to access information and manage content even when away from their desk, improving operational flexibility and emergency response capabilities. |
| Documentation | The codebase follows a modular structure with separate HTML pages per role-dashboard, inline JavaScript for page-specific logic, and shared utility modules (auth.js, supabase.js, toast.js, NotificationModal.js). A comprehensive CLAUDE.md file documents the database schema, RLS policies, tech stack, and development guidelines. For the front-end design and overall structure of the system, Figma was employed to guarantee coherence and consistency across all website content, layouts, and visual elements. |
| Backup & Recovery Systems | The system utilizes Supabase's automated backup services, which include daily database backups with point-in-time recovery for Pro tier projects. The PostgreSQL database is continuously backed up with WAL archiving. Frontend code is version-controlled through Git/GitHub, providing complete code history and rollback capabilities. Netlify maintains deployment history, allowing instant rollback to any previous deployment. This multi-layered backup strategy ensures data integrity, facilitates disaster recovery, and maintains business continuity in the event of accidental data loss, system corruption, or service disruptions. |

---

## Economic Feasibility Table (Replace "Platform and Tooling Costs" rows)

| Platform and Tooling Costs: | Platform and Tooling Costs: |
| --- | --- |
| Hosting | The system uses Netlify for frontend static hosting (free tier provides 100GB bandwidth/month, automatic SSL, and continuous deployment from GitHub) and Supabase for backend services (free tier provides 500MB database, 1GB file storage, 50,000 monthly active users, and unlimited API requests). Both platforms offer generous free tiers sufficient for pilot deployment with no upfront costs. |
| Domain Name (Optional) | Estimated at ₱350–₱600/year if the barangay opts to register a custom domain name. Netlify provides free subdomain (*.netlify.app) for initial deployment. |
| Free-tier Tools Used | Figma for UI mockups, Google Workspace (Docs, Meet, Drive) for collaboration, Trello for task management, Draw.io / PlantUML for diagrams, Messenger/Email for communication, VS Code for development, Supabase Dashboard for database management |
| Estimated SE2 Development Costs | Personnel: As a student project, no paid labor is involved. All development and QA tasks are fulfilled in-house by team members. |
| Estimated SE2 Development Costs | Training Materials: Digital guides and walkthroughs will be created without external cost. |
| Time Savings → Cost Benefit Estimate | Manual workload: SK officials currently spend ~5–7 hours/week managing volunteer records, files, and project inquiries manually. Post-implementation projection: Estimated reduction to ~1–2 hours/week. Net savings: ~4–6 hours/week or 208–312 hours/year. Assuming an estimated labor value of ₱100/hour (informal sector rate), this yields: ₱20,800–₱31,200/year in equivalent time saved. |

---

## Section 2.3 Project Responsibilities (Add SUPERADMIN role context note)

> **Note for Roles:** The system includes four user roles: SUPERADMIN (system administrator), CAPTAIN (Barangay Captain), SK_OFFICIAL (SK Chairman, Secretary, Treasurer, Kagawads), and YOUTH (Youth Volunteers). The Barangay Captain and SK Chairman are two separate individuals in Philippine local government — the Captain oversees barangay-wide governance while the SK Chairman leads the youth council.

---

## B.3 Technical Feasibility Conclusion (Replace entirely)

In conclusion, the Barangay Information Management System is technically feasible and practical for implementation. The system requires minimal infrastructure investment, with SK Officials needing only basic computer workstations meeting minimum hardware specifications for content management, while youth volunteers and residents require only internet-enabled mobile devices or computers to access and utilize the platform. The development approach using Supabase for backend services and Tailwind CSS for front-end design is well-suited for this project, leveraging modern cloud-native technologies that ensure long-term maintainability, zero server management overhead, and automatic scaling. The static frontend deployed on Netlify CDN ensures fast global delivery with no server configuration required.
