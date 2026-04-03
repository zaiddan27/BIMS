SPMP


SOFTWARE PROJECT MANAGEMENT PLAN


In partial fulfillment of the requirements for the course:
ICS26010
Software Engineering I



## Barangay Information Management System (BIMS)
for SK Malanday, Marikina City





Submitted by:
Ancheta, Jerome N.
Dela Vega, Elijah M.
Espinosa, Ryan Paolo C.
Ledonio, JC Dre Gabriel V.
Nicdao, Kyleen P.
Pelias, Andrea Marie C.
Ralleta, Brian Louis B.
Santos, Gavin Adrian C.
Sergio, Juliana Gabriella A.




Submitted to:
Asst. Prof. Mia V. Eleazar










Table of Contents



















## 1. Introduction
This Software Project Management Plan (SPMP) defines the management framework, organizational structure, processes, and resource allocation for the development of the Barangay Information Management System (BIMS) for the Sangguniang Kabataan (SK) of Barangay Malanday, Marikina City. This document serves as the authoritative guide for project execution throughout the Software Engineering 1 (SE1) phase and establishes the foundation for SE2 implementation.
### 1.1 Project Overview
Project Background
The Sangguniang Kabataan of Barangay Malanday, Marikina City, serves as the primary youth governance body responsible for organizing programs, leading community development initiatives, and facilitating youth participation in local decision-making. SK Malanday oversees various projects such as educational support, community events, youth volunteer work, and public information dissemination. Despite its active role, the council continues to rely on manual processes and fragmented systems, which limit its efficiency and its ability to effectively engage the youth sector.
The Sangguniang Kabataan of Barangay Malanday, Marikina City, currently faces operational inefficiencies in managing youth programs, official documents, and volunteer coordination. Through the initial interview conducted with Ms. Cielo Villaroman (SK Secretary) in September 2025, the project team identified critical pain points: inaccessible public files, manual volunteer registration processes, unclear contact information for projects of SK officials, and inefficient announcement distribution. These problems hinder access to essential documents, disrupt event scheduling, slow down volunteer onboarding, create communication gaps, and cause important updates to reach fewer youth participants.
To address these issues, the Barangay Information Management System (BIMS) was developed as a centralized digital platform that streamlines SK operations. The system features a landing page that showcases the community’s active volunteer base, testimonies, ongoing community projects, and transparency reports, covering everything from project allocation to project success metrics, attendance records and features section. All of this information can be viewed or downloaded, making key details accessible to users without an account. It also features dashboard with an announcement management features to ensure timely and categorized distribution of updates; a Files Management System providing a searchable digital repository for official documents; a Project Volunteer Management features that allows youth to browse opportunities, submit digital applications, and track their application status; an Integrated Calendar System that consolidates all SK project timelines; and an Inquiry and Communication features that enables volunteers to contact relevant SK officials directly and receive official responses to the project. Through these interconnected features, BIMS transforms fragmented manual workflows into efficient digital processes, strengthening transparency, accessibility, and youth engagement within Barangay Malanday.

Project Objectives:
Centralize Information Management
Create a unified and secure digital repository where SK officials can upload, organize, and manage public documents, ensuring consistent access and reducing scattered file storage across multiple platforms.
Streamline Project Tracking and Administration
Provide SK officials with structured tools to create, update, and oversee youth-related projects, while enabling volunteers to view project details, statuses, and relevant information in an organized and accessible manner.
Enhance Communication and Information Flow
Offer an integrated content management feature for posting announcements and responding to inquiries, ensuring clear, timely, and centralized communication between SK officials and youth volunteers.
Facilitate Volunteer Engagement and Participation
Implement an online system that allows youth volunteers to browse available projects, submit digital applications, send inquiries directly to assigned SK officials, and receive updates on their involvement.
Support Basic Scheduling Awareness
Provide users with a simple event- and schedule-viewing feature using a calendar module that reflects upcoming project timelines, while keeping scheduling support as a supplementary function rather than a core system module.
Strengthen System Security and Controlled Access
Implement secure login otp and enforce role-based access control to ensure that administrative functions are restricted to SK officials, while youth volunteers can only view permitted information and submit applications or inquiries.
Archive Projects
Implement an archived files and projects feature to enable the system to store, organize, and retrieve completed or inactive projects for reference and record-keeping purposes.


The following are included in the scope of the Barangay Information Management System (BIMS):
The system will implement role-based access control for three user groups: Barangay Captain (Approval), SK Officials (Administrators), and Youth Volunteers (Users). Each role will have clearly defined permissions and limitations to ensure secure and organized access to system functions.
However, visitors (users without accounts) to the system are welcomed to the BIMs landing page, which showcases the home, features, projects, testimonials, and transparency sections that inspire engagement, build trust, and celebrate the impact of youth-led initiatives.
The Barangay Captain of Barangay Malanday is granted system access for his primary role to evaluate and approve projects submitted by the SK Officials.
Meanwhile, the system is limited to core features that support SK operations, which include:
(1) Login,
(2) Manage Content,
(3) Monitor Projects,
(4) Manage Files.
Moreover, an archive section is seen with the core modules included in the system. This section displays historical project records, volunteers' attendance, and comprehensive reports, which are viewable and can be downloaded in bulk or individually, as needed. The project documents have a shelf-life of one (1) year before archiving them. Additionally, under the archive section, a testimonial section is available from youth volunteers regarding the projects they have participated in, as well as their post-event feedback on the recent project, which also contributes to their certificate of participation.
These core modules support SK operations for youth volunteers by centralizing information, enabling digital documentation, and improving communication with youth volunteers. Additional helpful functions, such as basic scheduling and viewing upcoming projects, are included alongside these modules, but they are not considered major system components.
Administrators have the authority to add, edit, delete, or archive announcements, projects, and files. They may also manage volunteer applications, review inquiries, and oversee project-related information as part of their operational duties.
Youth Volunteers have limited access and may only view announcements, browse files and project details, submit volunteer applications, and send inquiries. Their participation focuses on receiving information and communicating with the SK Officials when needed.
Access to the system requires an active internet connection, as the platform operates completely online. Users can interact with the system only when connected to the internet.
The scope also includes structured data handling processes such as uploading documents, posting updates, maintaining project details, generating reports, and supporting youth engagement through online sign-ups and inquiries. Features outside this boundary, such as advanced analytics, financial management, offline operations, and SMS broadcasting, are not included in the current version of the project.
Major work activities for this phase include requirements engineering, validation through the Javelin Validation Board, feasibility analysis, system modeling, interface mockups, and test planning. Key milestones span the completion of interviews, initial SPMP drafts, validation outputs, SRS and SDD development, the Software Test Plan, and the final prototype for proposal defense.
The SE1 phase requires a nine-member team, productivity tools, client coordination, and a minimal printing budget of ₱350 for defense materials. This project serves as the foundation for Software Engineering 2 (SE2), where the fully functional system will be developed based on the design artifacts produced in SE1. All requirements referenced in this overview are formally defined in the System Requirements Specification (SRS) v1.0.
### 1.1 Project Deliverables
The following table lists all primary deliverables for the SE1 phase, including delivery dates, locations, formats, and quantities required to satisfy the SE Manual Ver2 2021 and course requirements.
Table 1:  SE1 Project Deliverables
## 2. Project Organization
This section outlines the process model and organizational structure used for the BIMS project. It explains how activities are sequenced, how responsibilities are assigned, and how communication and decision-making are managed throughout SE1 to ensure systematic and efficient project execution aligned with course and client requirements.
### 2.1 Process Model
The BIMS project uses the early phases of the Waterfall lifecycle, focusing on requirements gathering, requirements analysis, and system design, which form the full scope of SE1. These phases define the activities, roles, entry criteria, and exit criteria needed for project initiation and product development. Project initiation includes forming the team, preparing tools, and conducting initial client interviews, while product development involves validating requirements, analyzing workflows, producing the SRS, creating system designs, UML diagrams, and developing the high-fidelity prototype.
The product release stage in SE1 corresponds to completing all required documents and preparing for the proposal defense, and project termination involves addressing panel feedback and producing the final approved versions of the SPMP, SRS, SDD, and STP. Since SE1 does not include coding or system implementation, only the documentation-related phases of the Waterfall model are executed.

Figure P-1: Project Process Model
## 2.2 Organizational Structure
The BIMS project team operates under a functional organizational structure that defines clear reporting relationships, authority lines, and communication pathways. This structure ensures that responsibilities are properly assigned, progress is effectively monitored, and decisions are made in an organized and traceable manner throughout the SE1 phase. At the organizational level, the project relates directly to the SE1 Course Coordinator and Adviser, who provide academic oversight, guidance, and approval of major deliverables. The team also maintains regular coordination with the client, represented by the SK Secretary of Barangay Malanday, for requirement validation and workflow clarification.
Internally, the Project Manager serves as the central coordinating role and is responsible for planning, scheduling, communication, and overall project direction. Under the Project Manager’s supervision, the Business Analyst leads requirements gathering and feasibility work, while the Systems Analyst manages system architecture, UML modeling, and design specifications. The Development Team supports the project by producing the high-fidelity UI prototypes and assisting with diagram development. The QA Team performs document reviews, ensures SE Manual compliance, and leads test planning activities. This hierarchy enables structured collaboration and smooth progression through all Waterfall phases relevant to SE1.

Figure P-2: Project Group Organizational Chart
The organization chart illustrates the vertical reporting relationships within the project. The Project Manager reports to the SE1 Adviser and communicates externally with the client. All team roles, Business Analyst, Systems Analyst, Developers, and QA Officers, report to the Project Manager according to their functional responsibilities. Horizontal collaboration occurs between Analysts, Developers, and QA Officers to ensure consistency across requirements, design artifacts, prototypes, and documentation.

The project follows structured reporting routines to maintain clarity and alignment. Externally, the Project Manager provides updates to the SE1 Adviser and manages communication with the client, including interviews, validation sessions, and requirement clarifications. Internally, the Systems Analyst reports design progress and technical concerns, the Business Analyst updates the team on requirements and feasibility work, Developers coordinate design and prototype tasks with the Systems Analyst, and QA Officers provide documentation review results and test-planning feedback. This approach supports clear vertical reporting and consistent horizontal coordination across all team members.

The project uses a combination of formal and informal communication channels to ensure coordination and timely progress across all team members. Weekly meetings provide structured updates and task alignment, while client interviews and adviser check-ins support requirement validation and guidance. Document reviews, defense rehearsals, and daily Trello updates maintain quality and track progress, and ad-hoc messaging allows quick resolution of issues. These channels ensure consistent information flow and effective collaboration throughout the project.



Figure P-2.1: SK Malanday Organizational Chart

The Sangguniang Kabataan (SK) of Barangay Malanday operates under a straightforward leadership structure. The SK Chairman, Ezekiel John S. Mata, leads the council, supported by eight elected SK Kagawads who oversee youth programs and community initiatives. The SK Secretary, Cielo DG. Villaroman, manages documentation, communication, and scheduling duties. Financial matters and fund management are handled by the SK Treasurer, Dharyl Kate Bongcasan. This simple but functional structure enables effective planning and execution of youth development projects.
### 2.3 Project Responsibilities
The table below identifies the major project roles, their responsibilities, and the team members assigned to each function. This structure ensures clear accountability and proper distribution of tasks throughout the SE1 phase.


Table 2: Project Responsibilities
## 3. Managerial Process
This section of the SPMP specifies the management process for this project.
### 3.1 Management Objectives and Priorities
The BIMS project follows a client-centered and documentation-driven management philosophy. The team prioritizes accurately addressing SK Malanday’s operational challenges, specifically related to youth volunteer coordination, information access, and project visibility, while meeting SE Manual standards and producing complete, consistent deliverables that will serve as the foundation for SE2 development. Emphasis is placed on clarity, correctness, traceability, and alignment with validated problems.

The management goals of the BIMS project center on producing accurate, validated, and well-structured documentation that reflects the needs of SK Malanday and supports future system development. A primary goal is ensuring requirement accuracy by thoroughly validating all functional and non-functional requirements through client interviews and the Validation Board. The team also prioritizes documentation quality, aiming to deliver SE Manual, compliant SPMP, SRS, SDD, and STP documents with complete sections and consistent diagrams. Defense readiness is another key objective, requiring structured rehearsals, aligned content, and documents that meet panel expectations. Continuous client engagement is maintained to validate workflows and assumptions, ensuring that all outputs remain grounded in actual SK operations involving youth volunteers. Team efficiency is supported by clear role assignments, peer reviews, and coordinated task tracking, enabling all nine members to contribute meaningfully. Finally, the project commits to strict schedule adherence, completing SE1 milestones according to the Waterfall timeline, SPMP by Week 5, SRS by Week 8, SDD by Week 12, STP by Week 13, and defense preparation during Weeks 14 to 15.



Figure P-3: Validation Board
### 3.2 Assumptions, Dependencies, and Constraints
The project is based on several key assumptions, including the continued availability of the SK Secretary for interviews and validations, the willingness of SK officials and youth volunteers to adopt the system once implemented, and the reliability of existing equipment and internet connectivity within Barangay Malanday. It is also assumed that all team members will remain active throughout SE1 and SE2, and that client requirements will remain stable after validation and approval during the proposal defense.
Project success depends on timely cooperation from the client, adviser approval of communications and major deliverables, panel availability for the defense schedule, and uninterrupted access to collaboration tools such as Google Workspace and Trello. Internally, progress relies on the sequential completion of documents, SRS before SDD, and SDD before STP, as well as consistent updates and handoffs across all roles.
The project operates under several constraints, including the fixed SE1 academic timeline, limited client availability, strict adherence to SE Manual formatting and UML standards, and the requirement that all SE1 outputs remain within the scope of documentation and mockups. Only the four validated core functions, Login, Manage Content, Monitor Projects, Manage Files, and basic schedule viewing, may be included in the scope. The team is restricted to using free or university-provided tools and must ensure full compliance with academic integrity, data privacy policies, and defense presentation guidelines.
When trade-offs arise, the project prioritizes functionality over schedule, and schedule over budget. Ensuring complete and accurate documentation that reflects validated client needs is the highest priority; timelines may be adjusted with adviser approval if necessary. Budget is not a limiting factor, as SE1 requires no financial expenditures beyond printing.
In accordance with SE Manual requirements, the project’s operational, technical, and economic feasibility assessments are not included in this section but are instead consolidated in Appendix A - Feasibility Studies.
### 3.3 Risk Management
Table 4 summarizes the primary risks that may affect the completion and performance of the BIMS project during the SE1 phase. These risks reflect issues related to client communication, requirements accuracy, documentation quality, schedule adherence, and team availability. Detailed descriptions, mitigation and contingency plans, and the full Probability–Impact Matrix are provided in Appendix B.

Table 3:  Summary of Risks
Risk Conditions
As part of the project’s risk management plan, Table 5 presents the broader risk conditions that may influence integration, scope, time, quality, communication, and team performance.


Table 3.1  Risks Conditions

A detailed Risk Register, including full mitigation strategies, contingency plans, and the Probability–Impact Matrix, is provided in Appendix B – Full Risk Matrix and Detailed Risk Register
### 3.4 Monitoring and Controlling Mechanisms
The project uses Trello as its primary monitoring and control tool, allowing the team to track progress at the work-package and task level. All activities from the Work Breakdown Structure are organized into lists such as To Do, Requirements, Diagrams, Doing, and Done, enabling clear visibility of task status throughout the SE1 lifecycle. Each card is assigned to specific team members and includes deadlines, attachments, checklists, and progress indicators to support timely completion and accountability.
Work progress is monitored through daily Trello updates and weekly meetings, where the Project Manager reviews card statuses, identifies blockers, and reallocates tasks when necessary. Quality assurance activities are also integrated into Trello, with document drafts (SPMP, SRS, SDD, STP) progressing through the board as they are reviewed and completed. The platform additionally supports configuration management through version-controlled attachments and activity logs, ensuring changes are traceable and coordinated.
Trello’s structure reinforces the project’s communication plan by providing a centralized space for collaboration, task ownership, and milestone tracking. This system ensures that monitoring, reporting, and quality control occur consistently and are aligned with the standards outlined in the SPMP.


Figure P-4: Trello Board

4. Work Packages, Schedule, and Budget
This section presents the work breakdown structure, task dependencies, resource requirements, resource allocations, and the project schedule for the BIMS SE1 phase. The contents describe how the team organizes, sequences, and manages all activities necessary to complete the required deliverables for Software Engineering 1.
## 4.1 Work Packages
The project tasks are decomposed into major work packages, each representing a cluster of related activities required to satisfy SE1 deliverables. These work packages form the basis for scheduling, resource assignment, and progress tracking.
Project Planning covers the initial activities required to organize the team, establish communication channels, and prepare the tools needed for SE1. This phase includes forming the team, coordinating with the client, and setting up Trello, Google Drive, and other project resources to support all subsequent work packages.

Figure P-5.1: Work Breakdown Schedule for Project Planning

Requirements Gathering is the first step in understanding client needs and system expectations. The team conducted initial and follow-up interviews with the SK Secretary to document current processes, identify pain points, and collect information that will guide the system’s core features and scope for youth volunteers.

Figure P-5.2: Work Breakdown Schedule for Requirements Gathering

Requirements Analysis involves organizing, validating, and refining the information collected from the client. This phase includes preparing the Validation Board, identifying assumptions, defining the problem statements, and creating diagrams that clarify workflows and system interactions based on verified information.



Figure P-5.3: Work Breakdown Schedule for Requirements Analysis

System Design translates validated requirements into structured models and visual representations of the system. This includes creating UML diagrams, the database design, and user interface mockups that outline how the system will function and how youth volunteers and SK officials will interact with each module.


Figure P-5.4: Work Breakdown Schedule for System Design

Requirements Specification formalizes all functional and non-functional requirements into the System Requirements Specification (SRS). This phase documents detailed use cases, constraints, user characteristics, and testable requirements that will guide later design and testing. It also includes developing initial test cases aligned with system features.


Figure P-5.4: Work Breakdown Schedule for Requirements Specification
## 4.2 Dependencies
The project follows a sequential flow where each work package depends on the completion of earlier tasks. Project Initiation must be completed before requirements can be gathered, and all gathered data must be validated before requirements are formalized in the SRS. System Design can only begin once the SRS is stable and approved, followed by the preparation of the Software Test Plan and prototype, both of which rely on the completed design. Defense preparation depends on the completion of all major SE1 documents, while the proposal defense must occur before revisions can be made. These dependencies ensure orderly progression, reduce rework, and maintain alignment with the Waterfall methodology.


Figure P-6: Dependency Diagrams

4.3 Resources Requirements
The BIMS project requires a combination of human, technical, and client resources to complete all SE1 deliverables. The project team consists of nine members with defined roles, Project Manager, Systems Analyst, Business Analyst, Developers, and QA Officers, whose coordinated effort supports planning, requirements analysis, system design, test planning, and documentation. The team relies on free or university-provided tools, including Google Workspace for collaboration, Trello for task management, ProjectLibre for scheduling, Draw.io and PlantUML for diagramming, and Figma for prototype development.
All members use personal laptops and stable internet connectivity to participate in meetings, produce documents, and collaborate asynchronously. Client resources include the SK Secretary’s availability for interviews and validation, which is essential for clarifying requirements and confirming assumptions. Together, these resources ensure the team can complete the required SE1 documents within the academic schedule and maintain alignment with the approved project scope
### Human Resources




Table 4: Human Resources Allocation
### Hardware Resources
Table 4.1: Hardware Resources Allocation
### Software Resources

Table 4: Software Resources Allocation
## 4.5 Schedule
The project schedule was developed using ProjectLibre, which allowed the team to plot all work packages, dependencies, and milestone dates based on the Waterfall model. Each activity was assigned a duration and linked to its predecessor tasks, ensuring that the schedule reflects the correct sequence from project initiation through documentation, design, test planning, and defense preparation. The resulting Gantt Chart provides a clear visual timeline of the project’s progression across Weeks 1 to 17, highlighting major SE1 deliverables and critical milestones



Table 7:  Gantt Chart
## 4.5 Additional Components
This section identifies additional documents that support the completeness of the Software Project Management Plan (SPMP). These supplementary components provide extended detail on risks, feasibility, and technical considerations essential for managing the BIMS project. The full documents are included in the Appendices and serve as reference materials to support decision-making, validation, and planning throughout the SE1 phase.
The appendices included in this SPMP are as follows:
Appendix A –  Feasibility Studies
Appendix B  – Full Risk Matrix and Detailed Risk Register
These appendices contain analyses and documentation that extend beyond the main body of the SPMP but are critical for ensuring the project’s viability, preparedness, and alignment with SE Manual standards.
APPENDIX A: FEASIBILITY STUDIES

This appendix presents the feasibility analyses used to evaluate whether the BIMS project is viable in its intended environment. It includes Economic Feasibility, Operational Feasibility, and Technical Feasibility.
B.1 Economic Feasibility Analysis
Cost Overview:
The project incurred minimal direct costs during SE1. The only financial expense was ₱350 for printing proposal documents required for the academic defense. This is considered an academic expense and not directly associated with system implementation.
Conclusion:
	The Barangay Information Management System (BIMS) is economically feasible. It requires only minimal recurring costs for web hosting and optional domain services, with all tools and development conducted using student resources and open-source platforms. The projected labor savings for SK officials and volunteers justify the investment, and the system promises long-term efficiency with very low operating costs.


Table 8: Economic Feasibility Analysis
B.2 Operational Feasibility Analysis
User Acceptance: High - Client and volunteers motivated by current pain points
Organizational Readiness: Adequate - Wi-Fi, PCs available; leadership supportive
Time Savings: ~70% reduction (5-7 hrs/week → 1-2 hrs/week)
Conclusion: Operationally feasible. Strong user motivation, adequate resources.
The team considered whether the proposed system could be applied to the client’s existing operation. Operational feasibility is based on the following:

Table 9: Operational Feasibility Analysis
In conclusion, the proposed Barangay Information and Management System is operationally feasible as the barangay has adequate equipment and strong user motivation. The system securely handles data, and sustainability support ensures viability.
B.3 Technical Feasibility Analysis
Technology Maturity: All components (Next.js, NestJS, PostgreSQL, OAuth2) are mature and production-ready
Team Capability: Adequate baseline skills; manageable learning gaps
Infrastructure: Free tier resources sufficient for pilot deployment
Conclusion: Technically feasible. Proceed with selected technology stack.

Table 10: Technical  Requirements


Table 11 : Technical Feasibility Analysis
In conclusion, the Barangay Information Management System is technically feasible and practical for implementation. The system requires minimal infrastructure investment, with SK Officials needing only basic computer workstations meeting minimum hardware specifications for content management, while youth volunteers and residents require only internet-enabled mobile devices or computers to access and utilize the platform. The development approach using PHP for back-end logic and Tailwind CSS for front-end design is well-suited for this project, leveraging existing technical knowledge and widely-supported technologies that ensure long-term maintainability.
APPENDIX B: Full Risk Matrix and Detailed Risk Register

This appendix contains the complete risk evaluation documents used in the project, including the Probability–Impact Matrix and the detailed Risk Register for all identified risks.

B.1 Probability–Impact Matrix
The Probability–Impact (PI) Matrix evaluates each risk based on its likelihood and potential effect on the project. Scores are calculated as:

Risk Score = Probability × Impact


Table 12: Impact Matrix
Risk Rating Interpretation:
1–3 = Low Risk
4–6 = Medium Risk
7–9 = High Risk
B.2 Detailed Risk Register
The following table contains the full detailed descriptions, mitigation strategies, contingency plans, and owners for each identified risk.

Table 13: Detailed Risk Register








Javelin Board
Login

File
P1.1
Problem: “We can’t trust our trackers, public files are scattered, and reporting is slow.”
Solution: File Management Module - A central repository where public files are uploaded by category and stored in a unified database.

P1.2
Problem: “We can’t trust our trackers, public files are scattered.”
Solution: A file repository that is  searchable  by project name
Riskiest Assumption: No shared naming/version rules → duplicate or outdated copies.

Project
P4.1
Problem: “Limited tools/budget/manpower slow execution.”
Solution: Lightweight System Build — Host web system using free tools (Firebase Hosting).

Dashboard
2.1
Problem: “Youth engagement is lower than expected; posts don’t convert to sign-ups.”
Solution: Event Sharing Module — Admin can post announcements directly on the web portal

Calendar
2.2
Problem: “Signing up is inconvenient.
Solution: Notifier System — Sends event confirmation emails or reminders generated from the system


| Deliverable | Description | Due Week | Delivery Location | Quantity |
| --- | --- | --- | --- | --- |
| SPMP | Project plan covering methodology, schedule, risks, feasibility, and resource allocation | Week 5 | Google Drive – Presentation Folder | 1 |
| SRS | Functional/non-functional requirements with use cases and process models | Week 8 | Google Drive – Presentation Folder | 1 |
| SDD | System architecture, diagrams, and design specifications for all core modules | Week 12 | Google Drive – Presentation Folder | 1 |
| STP | Test strategy, coverage, and detailed test cases | Week 13 | Google Drive – Presentation Folder | 1 |
| Prototype (Mockups) | High-fidelity UI mockups of system screens | Week 14 | Google Drive – Appendices Folder | 1 |


| Role | Primary Responsibilities | Assigned To |
| --- | --- | --- |
| Project Manager | Leads project planning and scheduling, monitors task progress, manages communication with adviser and client, oversees risk management, and coordinates defense preparation. | Jerome Ancheta |
| Systems Analyst | Defines system architecture, develops UML diagrams (use case, class, sequence, activity, swimlane), designs the database (ERD and schema), and provides technical guidance to the team. | Juliana Gabriella Sergio |
| Business Analyst | Conducts client interviews, gathers and analyzes requirements, documents workflows, performs feasibility studies, validates requirements, and leads preparation of the SRS. | Andrea Marie Pelias |
| Developers (x3) | Create high-fidelity Figma prototypes, design UI/UX layouts, support UML diagram preparation, and assist with technical sections of documentation. | Kyleen Nicdao, Gavin Adrian Santos, Elijah Dela Vega |
| QA Officers (x3) | Lead test planning activities, write test cases, conduct document reviews, ensure SE Manual compliance, and verify consistency across SPMP, SRS, SDD, and STP. | Ryan Paolo Espinosa, Brian Louis Ralleta, JC Ledonio |


| Potential Risk | Impact | Likelihood | Owner | Mitigation Strategy |
| --- | --- | --- | --- | --- |
| Client becomes unavailable for interviews or validation sessions | High | Moderate | Project Manager | Schedule meetings in advance; prepare structured questions; identify backup SK contact. |
| Incomplete or ambiguous requirements due to miscommunication | High | Moderate | Business Analyst & Systems Analyst | Conduct ≥3 interviews; validate through the Validation Board; walkthrough SRS with client. |
| Delays in completing documentation deliverables | High | Low–Moderate | Project Manager & All Members | Follow the Waterfall schedule; use Trello updates; redistribute tasks when needed. |
| Documentation inconsistencies across SPMP, SRS, SDD, and STP | Medium | Moderate | QA Team | Conduct cross-document reviews; use SE Manual templates; check terminology consistency. |
| Team member unavailability due to academic load or emergencies | Medium | Moderate | Project Manager | Cross-train members; maintain documentation; define backup responsibilities. |
| Limited digital access for youth volunteers affecting requirements accuracy | Medium | Moderate | Business Analyst | Ensure mobile-friendly UI in mockups; validate assumptions with client. |
| Low usability from complex workflows or unclear UI | Medium | Low | Systems Analyst & Developers | Apply user-centered design principles; make mockups simple and intuitive. |
| Tool or platform downtime (Google Drive, Trello, Google Meet) | Medium | Low | Systems Analyst | Maintain offline backups; use alternative communication tools if needed. |


| Area | Risk Condition |
| --- | --- |
| Integration | Misalignment between documented workflows and actual SK processes may require revisions. |
| Scope | Client expectations may expand beyond validated features, leading to scope creep. |
| Time | Tight academic deadlines and client availability may delay document completion. |
| Quality | Insufficient reviews may result in inconsistencies or incomplete documentation. |
| Communication | Remote communication may cause delays in clarifications or missed feedback. |
| Human Resources | Skill gaps or team member absences may slow documentation progress. |
| Overall Project Risk | No guarantee that all requirements will be fully validated before defense. |


| Hardware Resource | Description / Purpose | Users |
| --- | --- | --- |
| Personal Laptops / PCs | Used for writing documents, designing diagrams, creating mockups, and attending online meetings. Minimum specs: i3/Ryzen 3, 8GB RAM, stable OS. | All Team Members |
| Barangay Office Workstation | Used by the client during interview and validation sessions; contains existing SK documents and workflows. | SK Secretary |
| Mobile Devices (Smartphones) | Used by team members for communication and by SK officials during requirement validation. Also used to verify mobile responsiveness of mockups. | Team & Client |
| Internet Connectivity (Wi-Fi / Data) | Required for Trello, Google Workspace, Meet calls, file sync, PlantUML rendering, and Figma collaboration. | Team & Client |


| Software Resource | Purpose / Usage | Type |
| --- | --- | --- |
| Google Workspace (Docs, Drive, Slides, Meet) | Central repository for all SE1 documents, real-time collaboration, online interviews, and defense deck preparation. | Collaboration Platform |
| Trello | Task management, progress tracking, work package monitoring, and role assignments. | Project Management Tool |
| ProjectLibre | Gantt chart creation and schedule planning for Section 4.5. | Scheduling Tool |
| Draw.io / diagrams.net | Creation of UML diagrams (Use Case, Activity, Sequence, Class). | Diagramming Tool |
| Figma | Creation of high-fidelity UI mockups for Login, Manage Files, Manage Content, Manage Projects, and Calendar viewing. | UI/UX Prototyping |
| Google Chrome | Browser required to access Trello, Figma, Google Workspace, and mockups. | Productivity Software |
| Messenger / Email | Quick communication among members and with the client. | Communication Tool |
| PDF Reader / Export Tools | Converting final documents (SPMP, SRS, SDD, STP) into PDF format for submission. | Documentation Utility |


| Platform and Tooling Costs: | Platform and Tooling Costs: |
| --- | --- |
| Hosting | The team plans to use Hostinger Shared Hosting, a cost-efficient platform. The lowest plan suitable for PHP and MySQL-based systems is approximately ₱89–₱159/month (as of 2025), offering sufficient bandwidth and storage for pilot deployment. |
| Domain Name (Optional) | Estimated at ₱350–₱600/year if the barangay opts to register a custom domain name. |
| Free-tier Tools Used | Figma for UI mockups Google Workspace (Docs, Meet, Drive) for collaboration Trello for task management Draw.io / PlantUML for diagrams Messenger/Email for communication |
| Estimated SE2 Development Costs | Personnel: As a student project, no paid labor is involved. All development and QA tasks are fulfilled in-house by team members. |
| Estimated SE2 Development Costs | Training Materials: Digital guides and walkthroughs will be created without external cost. |
| Time Savings → Cost Benefit Estimate | Manual workload: SK officials currently spend ~5–7 hours/week managing volunteer records, files, and project inquiries manually.  Post-implementation projection: Estimated reduction to ~1–2 hours/week.  Net savings: ~4–6 hours/week or 208–312 hours/year.  Assuming an estimated labor value of ₱100/hour (informal sector rate), this yields: ₱20,800–₱31,200/year in equivalent time saved. |


| Equipment | The proposed Barangay Information Management System is flexible and responsive on laptops, computers, and mobile phones. The SK officials and youth volunteers of Barangay Malanday can both use this interface as their designated access is predefined in their login credentials. Both of these are accessible and feasible for the SK officials and youth volunteers. |
| --- | --- |
| User Acceptance | The proposed system will streamline information dissemination, record management, and inquiry processes for youth volunteers. Both the SK officials and volunteers are expected to adapt efficiently, as only minimal adjustments are required. |
| Process Integration | The proposed system will replace the manual record-keeping and integrate with existing barangay workflows, reducing duplication and errors. |
| Security and Privacy | The proposed system prioritizes the security and privacy of its clients; therefore, user data for both privileged and regular users is protected through secure login credentials and encryption. |
| Maintenance and Sustainability | After the proper turnover of the proposed system, with the right guidance, barangay IT staff will ensure regular updates and technical support to sustain operations. |


| Hardware Requirements | The barangay office requires at least one computer workstation with minimum specifications (Intel Core i3 or equivalent, 8GB RAM, 500GB storage) for system administration and content management  Staff members will need their own workstations or laptops with similar specifications to access and manage content through the web-based interface. All staff computers require a stable internet connection to access the Hostinger-hosted website and database. A reliable internet service provider (ISP) subscription is essential for daily operations. |
| --- | --- |
| Software Requirements | The system will be hosted on Hostinger's shared web hosting infrastructure, which provides pre-configured web server technology (LiteSpeed/Apache) and MySQL database management system for storing barangay records, project information, and document metadata. The database has a 3GB size limit per database, which is sufficient for text-based records as actual document files (PDFs, images, Word documents) will be stored in the file system with only their metadata and file paths stored in the database.  Staff members require a modern web browser (Google Chrome, Mozilla Firefox, or Microsoft Edge - latest versions) installed on their workstations to access the system. File management, content updates, and administrative functions will be handled through the web-based interface with secure authentication protocols |
| Network Infrastructure | A stable and reliable internet connection with a minimum bandwidth of 10 Mbps (20 Mbps or higher recommended) is essential for accessing the Hostinger-hosted system. The barangay office must have a dependable Internet Service Provider (ISP) subscription to ensure consistent connectivity for all staff members accessing the web-based platform.  As for the network setup, The barangay office requires a wireless router with sufficient capacity to support multiple concurrent users (minimum 5-10 devices). Staff members using laptops can connect via Wi-Fi, while desktop workstations may use wired Ethernet connections for more stable connectivity if preferred. |
| Security Requirements | Implementation of SSL/TLS certificates for encrypted data transmission, role-based access control (RBAC) for different user levels (admin, staff, volunteers), and regular automated backups. Password policies and session management will protect sensitive barangay information. Two-factor authentication (2FA) can be implemented for administrative accounts, as well as the youth volunteers, ensuring compliance with data privacy regulations.  Furthermore, user passwords are securely hashed using bcrypt, ensuring that even in the event of a database compromise, the actual passwords cannot be reversed or reconstructed by unauthorized parties. |


| Development Tools | The development team will utilize an Integrated Development Environment (IDE) such as Visual Studio Code for efficient coding and debugging. Version control through Git/GitHub will manage code changes and enable collaborative development. To be able to track the team’s progress, the team would be utilizing Project management tools like Trello for real-time information in regards to marking accomplished tasks and even the pending tasks to be done. |
| --- | --- |
| Programming Languages & Frameworks | Front-end: HTML5, CSS3, and JavaScript with Next.js and Tailwind CSS for responsive design and modern styling. JavaScript will handle dynamic user interactions, form validations, and asynchronous operations for a smooth user experience across desktop and mobile devices.  Back-end: PHP 8.x for server-side logic, handling database operations, user authentication, and business logic. PHP integrates seamlessly with MySQL databases and is fully supported by Hostinger's shared hosting environment. These technologies provide excellent documentation, active community support, and proven reliability, making development and maintenance feasible for the barangay system. |
| Database Management System | MySQL 8.0 (included with Hostinger) will handle data storage for barangay records, document metadata, projects, and user information. phpMyAdmin (accessible through Hostinger's hPanel) provides an intuitive web-based interface for database administration.  The database stores structured data (user’s logs, project details, user accounts, file metadata) while actual document files are stored in the file system to optimize the 3GB database limit. The system will implement proper indexing and query optimization to ensure fast performance as data grows. |
| Content Management System | Integration of file upload/download functionality supporting various formats (PDF, DOCX, XLSX, images). Document categorization and tagging system for easy retrieval. Version control for document updates and an audit trail for tracking changes. It would also provide Search functionality with filters for quick access to barangay records and projects. |
| Mobile Responsiveness | Tailwind CSS would be utilized to ensure the system is fully responsive and accessible on smartphones and tablets. This allows barangay staff to access information and manage content even when away from their desk, improving operational flexibility and emergency response capabilities. |
| Documentation | To ensure thorough code documentation and maintain consistency across the development process, the team will utilize PHPDoc for annotating the codebase, supplemented by a README.md file to clearly define the project’s scope and objectives. For the front-end design and overall structure of the system, Figma will be employed to guarantee coherence and consistency across all website content, layouts, and visual elements |
| Backup & Recovery Systems | The system utilizes automated backup services provided by Hostinger's hosting infrastructure to maintain regular backup copies of website files and database content.   However, to ensure comprehensive data protection, the barangay shall implement supplementary local backup procedures through periodic database exports via phpMyAdmin, with backup files stored on dedicated external storage devices. This dual-backup strategy ensures data integrity, facilitates disaster recovery, and maintains business continuity in the event of accidental data loss, system corruption, or service disruptions. |


| Impact ↓ / Probability → | Low (1) | Medium (2) | High (3) |
| --- | --- | --- | --- |
| High (3) | 3 | 6 | 9 |
| Medium (2) | 2 | 4 | 6 |
| Low (1) | 1 | 2 | 3 |


| Risk ID | Detailed Description | Impact | Probability | Score | Mitigation Strategy | Contingency Plan | Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| R01 | SK files are scattered across multiple storage locations, causing inconsistent records and migration difficulty. | High | High | 9 | Standardize file naming and folder structure; conduct pre-migration data cleanup. | Verify using existing SK backups. | Systems Analyst |
| R02 | Some youth volunteers may have limited mobile data or devices, reducing access to project information. | Medium | High | 8 | Use mobile-optimized UI; keep pages lightweight. | Provide printed project lists if needed. | Business Analyst |
| R03 | SK officials may delay updating project information due to workload or limited manpower. | High | Medium | 8 | Require mandatory fields; add structured update reminders. | Assign alternate officials to update records. | Project Manager |
| R04 | Volunteer sign-ups rely on Facebook or in-person registration, leading to incomplete volunteer records. | High | Medium | 8 | Implement digital volunteer forms in the system design. | Allow manual encoding by SK admin. | Developers |
| R05 | Files may be incorrectly deleted or overwritten, causing missing project or public documents. | High | Medium | 8 | Restrict delete access; require confirmation prompts. | Recover files from local drives or request reupload. | QA Team |
| R06 | Weak passwords or shared accounts may lead to unauthorized system access. | High | Medium | 8 | Enforce strong password rules; enable session timeouts. | Reset compromised credentials; audit activity logs. | Developers |
| R07 | Documentation or mockup reviews may be disrupted due to internet or tool downtime. | Medium | Medium | 6 | Maintain offline backups; identify alternative tools. | Continue work offline and sync when restored. | Developers |
| R08 | Incorrect or outdated project schedules may cause confusion for youth volunteers. | Medium | Medium | 6 | Apply date-range validation; allow admins to edit entries easily. | Freeze incorrect entries and notify client. | Systems Analyst |
| R09 | Attendance or beneficiary data may contain errors due to manual encoding. | Medium | Medium | 6 | Require mandatory fields; provide clear UI instructions. | Conduct manual checking and correction. | QA Team |
| R10 | SK officials may struggle to learn the new admin dashboard and modules. | Low | Medium | 4 | Provide walkthroughs and simple training materials. | Assign support personnel during early use. | Business Analyst |
