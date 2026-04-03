# Tab 1



Software Design Document




In partial fulfillment of the requirements for the course:
ICS26010
Software Engineering I



Barangay Information Management System (BIMS)
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


## System Overview

The Barangay Information Management System (BIMS) is a website portal designed for the Sangguniang Kabataan (SK) officials and youth volunteers for Barangay Malanday, Marikina City. These youth leaders are responsible for organizing youth development projects, managing files, and communicating with barangay constituents. In response to the challenges identified during the interview, the function was designed to address the critical assumptions and validated operational needs. The function development team identified four main functions based on the client's current problems. These include: (1) Login, (2) Manage Content, (3) Manage Files, and (4) Monitor Projects.

The functional requirements are included to support the workflow of the SK official and the youth volunteers, ensuring security, efficiency, usability, reliability, maintainability, and performance.

The Login function ensures system security by allowing only authorized users to access system features and data. It distinguishes user roles, Barangay Captain, SK Official, and Youth Volunteer, and provides corresponding access privileges. This function includes a sign-up subfunction, enabling the youth of Barangay Malanday to register as Youth Volunteers through the system. A Forgot Password feature is also provided, allowing users to reset their credentials securely. To enhance account protection, the system implements email-based two-factor authentication (OTP verification) to confirm that the registered email address is active and to add an additional security layer in case of account compromise.

The Manage Content function supports usability, maintainability, and performance by facilitating the dissemination of announcements from SK Officials to barangay constituents. SK Officials are authorized to create, edit, delete, and view announcements, while Youth Volunteers are limited to viewing published content. This function ensures timely information delivery, wider reach, and consistent communication regarding barangay activities and updates.

The Manage Files function enhances usability, maintainability, and performance by providing a centralized repository for public documents accessible to all users of the system. These files are intended for transparency and information dissemination, such as official announcements, reports, and budget allocation documents. The function addresses the issue of storing official files on personal drives by organizing and securely storing public files within the system. SK Officials are permitted to upload, delete, view, search, download, and feature files, while Youth Volunteers may view, search, and download available public documents. Additionally, SK Officials may designate selected files as featured, allowing them to be highlighted and displayed on the system’s homepage for increased visibility and easier access by barangay constituents. This function promotes transparency, improves accessibility to public information, and ensures proper document management within the barangay.

The Monitor Projects function emphasizes performance and reliability by supporting structured project management and monitoring. It enables the dissemination of project details, including project title, purpose, location, and timeline, to Youth Volunteers, while also allowing barangay constituents to view approved projects on the public homepage. This public visibility encourages interested residents to sign up for an account as Youth Volunteers in order to participate in ongoing projects. SK Officials are authorized to create, edit, delete, view, filter, and search projects, manage volunteer applications, and respond to project-related inquiries. Upon submission of a project proposal, the system automatically forwards the proposal to the Barangay Captain for review. The Barangay Captain may view project details, assess the project’s current status, and approve or reject proposals accordingly. Youth Volunteers may browse and search approved projects, submit inquiries and discussion threads, register for specific projects, and view or edit their applications. This function ensures systematic project monitoring while increasing public awareness, transparency, and participation in youth development initiatives.
The external interface requirements define how the system interacts with users and external services to ensure usability, security, and performance. The system must provide a user-friendly graphical interface that enables seamless interaction with its four main functional areas through intuitive navigation, responsive design, and clear feedback mechanisms. To strengthen security, the system integrates email-based verification using the Gmail API to support two-factor authentication, combining standard login credentials with OTP verification. Additionally, a web server HTTP interface is required to manage client–server communication, supporting standard HTTP methods, secure HTTPS connections, and proper request–response handling with error management. Finally, the system must include a robust database interface to store and manage all system data, supporting reliable CRUD operations and enforcing role-based access control to protect sensitive information. Together, these external interfaces ensure a secure, efficient, and user-centered system experience.

## System Architecture
### Architectural design

Login

Figure D2.1.1 showcases the subfunctions of the login function. The login function is structured as a dedicated component responsible for authentication and user account management for Barangay Captain, SK Barangay Officials, and SK Youth Volunteers.. This function handles user registration, login, and password recovery, ensuring secure access to the barangay management function. Login, registration, and password recovery receive OTP verification in their email to confirm that the right user is performing these functions.

This login function collaborates closely with other functions by verifying user credentials and passing authorized user roles to enforce appropriate permissions across the function. For example, once a user logs in, their role (official, volunteer, or barangay captain) is communicated to the different management functions to determine access levels.

This partitioning allows the login function to focus solely on security and identity management, while other functions handle domain-specific functions like file management, content management, project management, and calendar management. Together, these functions integrate seamlessly to provide a secure, role-aware, and functional function that meets the needs of its users.


#### Figure D2.1.1 Detailed Use Case Diagram: Login


File Management

Figure D2.1.2 illustrates the relationship among the subfunctions of the Manage Files function. This function provides a centralized repository for public documents intended for transparency and information dissemination.

The Manage Files function includes the subfunctions viewing, searching and filtering, uploading, deleting, and downloading files. SK Barangay Officials have full access to all subfunctions, allowing them to comprehensively manage public files. SK Youth Volunteers have limited access and are restricted to viewing, searching, filtering, and downloading files only.

This function operates in coordination with the Login function. Based on the authenticated user role, the system enforces role-based access control to enable or restrict specific file-related actions. This ensures that only authorized users can perform sensitive operations such as uploading or deleting files, while all users can securely access public documents.




#### Figure D2.1.2 Detailed Use Case Diagram: Manage Files

Content Management

Figure D2.1.3 indicates the relationship of the subfunctions of managing content. The content management function includes subfunctions such as creating, deleting, editing, and viewing announcements. SK Barangay Officials have full access to all these subfunctions, allowing them to manage announcements comprehensively. In contrast, SK Youth Volunteers are limited to viewing announcements only, ensuring they stay informed without modifying content.

This function works in coordination with the login function, which authenticates users and assigns roles. Based on the user’s role, the content management function enforces access control, enabling or restricting certain subfunctions accordingly. This ensures that only authorized users can perform sensitive operations like creating or deleting announcements, while others can still access necessary information securely.


#### Figure D2.1.4 Detailed Use Case Diagram: Manage Content for Youth


#### Figure D2.1.5 Detailed Use Case Diagram: Manage Content for SK Officials


Project Management

Figure D2.1.4 illustrates the relationship among the subfunctions of the Manage Project function. This function supports structured project management and monitoring and is divided according to user roles.

SK Barangay Officials are authorized to create, edit, delete, view, search, and filter projects, review volunteer applications, and respond to project-related inquiries. Upon submission of a project proposal, the system automatically forwards the proposal to the Barangay Captain for review. The Barangay Captain may view project details, assess the project’s status, and approve or reject the proposal accordingly.

SK Youth Volunteers are permitted to view, search, and filter approved projects, submit and reply to inquiries, register for upcoming projects, and view or edit their applications. Both roles share common capabilities such as viewing, searching, and filtering project information.

The Manage Project function works in coordination with the Login function to enforce role-based access control. By restricting project-related subfunctions based on user roles, the system ensures secure, organized, and reliable project monitoring.


#### Figure D2.1.6 Detailed Use Case Diagram: Manage Project for Sk Officials




#### Figure D2.1.7 Detailed Use Case Diagram: Manage Project for Youth Volunteers



#### Figure D2.1.7 Detailed Use Case Diagram: Manage Project for Barangay Captain

Login
Figure D2.2.1 presents the login process and the interactions among system components. The diagram consists of three swimlanes: Gmail API, System, and User (Barangay Captain / SK Barangay Official / SK Youth Volunteer). The user is responsible for providing all required inputs during authentication-related processes.
During login, the user inputs a valid email address and password. Upon successful credential verification, the system generates a One-Time Password (OTP) and sends it to the user’s registered email address. The user must enter the correct OTP to complete authentication and gain access to the system.
During sign-up, applicable to Youth Volunteers, the user inputs their personal information, email address, and password. The system then sends an OTP to the provided email address to verify that the email is active. Account creation is completed only after successful OTP verification.
For password recovery, the user inputs their registered email address and verifies their identity by entering the OTP sent to their email. Once verification is successful, the user is allowed to reset their password.
The System is responsible for validating all user inputs by checking them against stored database records, including email addresses and encrypted passwords. For two-factor authentication, the system generates a time-limited OTP and delivers it through integration with the Gmail API. This process ensures secure authentication, prevents unauthorized access, and protects user accounts across all roles.

#### Figure D2.2.1 Swimlane diagram: Login
File Management
Figure D2.2.2 presents the File Management process and its interactions among system actors. The swimlane diagram consists of three lanes: SK Barangay Official, SK Youth Volunteer, and System.
The SK Barangay Official is responsible for managing public files within the system. This includes uploading files by providing a file name, selecting a file category, and choosing a file from the local device. SK Barangay Officials may also delete files by selecting the delete option and confirming the action through a system prompt.
Both SK Barangay Officials and SK Youth Volunteers are allowed to view, search, filter, and download public files. Searching and filtering are performed by selecting file categories or types and entering relevant keywords.
The System is responsible for validating all file-related actions. During file upload, the system verifies the file type and ensures that the file size does not exceed 10 MB. If the file meets all validation requirements, the upload is completed successfully; otherwise, the system rejects the upload and displays an appropriate error message. For file deletion, the system displays a confirmation prompt asking the user to confirm the action (e.g., “Do you want to delete this file?”).
During search operations, the system checks for files that match the specified criteria and displays the corresponding results. If no matching files are found, the system displays a message indicating that no files are available (e.g., “No files found”).
This process ensures secure file handling, controlled access based on user roles, and reliable retrieval of public documents within the system.

#### Figure D2.2.2 Swimlane diagram: File Management
Content Management
Figure D2.2.3 illustrates the Content Management process and its interactions among system actors. The swimlane diagram consists of three lanes: SK Barangay Official, SK Youth Volunteer, and System.
The SK Barangay Official is responsible for managing announcements within the system. This includes creating announcements by selecting a category, entering the announcement title and description, and optionally uploading an image. SK Barangay Officials may also edit existing announcements by modifying their details and submitting the updated content. Announcements can be deleted by selecting the delete option and confirming the action through a system prompt.
SK Youth Volunteers are limited to viewing published announcements only, allowing them to stay informed without the ability to modify content.

-The System is responsible for validating all announcement-related inputs. During announcement creation or editing, the system checks required fields and validates uploaded images, ensuring that the image file size does not exceed 5 MB. If all inputs are valid, the system displays a confirmation prompt (e.g., “Do you want to post this announcement?”) before publishing the content. If validation fails, the system prevents submission and displays an appropriate error message. This process ensures controlled content management, data validation, and secure dissemination of information to barangay constituents.

#### Figure D2.2.3 Swimlane diagram: Content Management
Project Management
Figure D2.2.4 presents the updated swimlane diagram for the Manage Projects function. The diagram illustrates the step-by-step interactions among SK Barangay Officials, SK Youth Volunteers, the System, and the Barangay Captain throughout the project lifecycle.
The process begins with the SK Barangay Officials, who are responsible for creating and managing projects. They create project entries by providing required details such as project title, category, description, location, schedule, target volunteers, and budget information. SK Barangay Officials may also edit or delete projects prior to approval, review volunteer applications, and respond to project-related inquiries submitted by volunteers.
Once a project proposal is submitted, the System automatically forwards the proposal to the Barangay Captain for review. The Barangay Captain may view the complete project details and decide to approve or reject the proposal. The system updates the project status accordingly based on the Captain’s decision.
After project execution, SK Barangay Officials mark the project as Completed. Upon completion, the system requires the submission of a post-project evaluation and survey, capturing performance metrics and feedback. Only after the evaluation process is finalized may SK Barangay Officials archive the project, transferring it from the active project listings to the Project Archive section. All project-related records are preserved for historical reference, reporting, and transparency.
Throughout the process, the System enforces role-based access control, manages data validation, handles project status transitions (e.g., pending, approved, completed, evaluated, archived), and maintains accurate record tracking to ensure consistency and reliability across all project management activities.

#### Figure D2.2.4 Swimlane diagram: Project Management


## B. Decomposition Description
Login



#### Figure D2.3.1 System sequence diagram: Login

In Figure D2.3.1 when logging in, the user needs to provide their password and email address. The function will send a One-Time Password (OTP) to the user's Gmail account if the password is correct. The OTP is then entered by the users, and if it is accurate, the function will establish a session and grant access. The user will have the option to register if the account does not already exist. If the password is incorrect, the user has five chances to enter it correctly before being locked for fifteen minutes.







File Management



#### Figure D2.3.2 System sequence diagram: File Management

In Figure D2.3.2, SK Officials can upload, download, view, filter, search, and delete public files while Youth Volunteers can view, download, filter, and search files. The function validates the file size and prompts confirmation for deletion.








Content Management



#### Figure D2.3.3 System sequence diagram: Content Management

In Figure D2.3.3, SK Officials can create, view, delete, and edit content. Both Youth Volunteers and the SK Officials can view content. The function validates the size of the image (maximum of 5MB) and prompts confirmation for editing and deletion.













Project Management







#### Figure D2.3.4 System sequence diagram: Project Management

Figure D2.3.4 illustrates the system sequence for the Project Management process and the interactions among system actors. SK Barangay Officials are authorized to create, edit, delete, view, search, and filter project records. They may also respond to project-related inquiries and manage volunteer applications by reviewing applications and updating their status (e.g., approved or rejected).
SK Youth Volunteers are permitted to view, search, and filter approved projects and may register for selected projects. During registration, the system validates volunteer eligibility; if the applicant is under 18 years old, the system requires the upload of a parental consent document before allowing the application to proceed. Youth Volunteers may also submit project inquiries and view or edit their application details.
After project execution, SK Barangay Officials mark the project as Completed. Upon completion, the System requires the submission of a post-project evaluation and survey, capturing key performance indicators such as volunteer participation, budget utilization, timeline adherence, community impact, and volunteer feedback. The system validates all evaluation inputs and stores the results as part of the project record.
Once the evaluation process is finalized, SK Barangay Officials may archive the project, transferring it from the active project listings to the Project Archive section. All associated records, including project details, volunteer applications, attendance data, evaluation results, and survey responses, are preserved for historical reference, reporting, and transparency. Archived projects remain view-only and are no longer open for registration or modification.
Throughout the sequence, the System enforces role-based access control, performs input validation, manages project status transitions (e.g., pending, approved, completed, evaluated, archived), and updates project and application records in real time. This ensures secure project handling, accurate data tracking, reliable reporting, and a structured end-to-end project lifecycle within the system.

## Data Design

### Data Description
The data design outlines how the function’s information domain is represented and managed through structured data models. The SK Management System handles several categories of information, such as users, projects, announcements, files,  and inquiries. Each of these items is transformed into a corresponding data structure that is stored and maintained in a relational database.

Real-world objects are mapped into database entities that contain attributes describing their characteristics. Relationships between entities are implemented through primary keys and foreign keys to maintain consistency across the function. For example, when a youth volunteer registers for a project, a new record is created in the ProjectRegistration entity that links a user to a specific project. Similarly, files uploaded by SK officials are associated with the File entity, while announcements, inquiries, and calendar events reference related users and projects.

Data is handled through common operations such as creating and deleting records. These operations are executed according to the user’s role. SK Officials are permitted to create or modify projects, announcements, and calendar events, while youth volunteers primarily perform viewing and inquiry-related functions.






# Figure D3: E-R diagram
### Data Dictionary

#### Table 3.1: Data dictionary of  Announcmenet Table

#### Table 3.2: Data dictionary of  Annual Budget Table

#### Table 3.3: Data dictionary of Application Table

#### Table 3.4: Data dictionary of Budget Breakdown Table

#### Table 3.5: Data dictionary of Certificate Table

#### Table 3.6: Data dictionary of Expenses Table

#### Table 3.7: Data dictionary of Evaluation Table

#### Table 3.8: Data dictionary of  File Table

#### Table 3.9: Data dictionary of  Inquiry Table

#### Table 3.10: Data dictionary of  Logs Table

#### Table 3.11: Data dictionary of  Notifications Table


#### Table 3.12: Data dictionary of  OTP Table

#### Table 3.13: Data dictionary of  Report Table


#### Table 3.14: Data dictionary of  SK Table

#### Table 3.15: Data dictionary of  Pre-Project Table

#### Table 3.16: Data dictionary of  Post-Project Table

#### Table 3.17: Data dictionary of  Reply Table

#### Table 3.18: Data dictionary of  Reply Table

#### Table 3.19: Data dictionary of User Table
## 4. Component Design

Class diagrams visually represent a system's classes, attributes, and methods as they illustrate their relationships and interactions. Figure D4 is a class diagram that represents a comprehensive system for managing projects, files, contents, and user data. The diagram illustrates the structure and relationships between various entities.

At the core of the system is the user, since it serves as the central actor in the system. It holds the user data and credentials. And has the ability to log in, forget password, and sign up. This class is the connector of all other classes and distinguishes the permissions of each user.

The project class contains detailed information such as projectID, creator details, title, description, category, status, start and end dates, location, and image path. Before any application or inquiry can be made, a project must be created first. And if there is an inquiry, the user may reply. It holds the attributes replyID, inquiryID, userID, message, and timeStamp.

The content class is for managing announcements for the timely dissemination of information. It has the methods of creating, editing,  deleting, and viewing.

The file class allows the management of public files of the SK official. It has the ability to upload, delete, filter, and search for files. This is for the transparency of the files to the public.


#### Figure D4: Class diagram


## 5. Human Interface Design
### 5.1 Overview of User Interface
The system provides role-based access to barangay information and project monitoring features for the Barangay Captain, SK Barangay Officials, and Youth Volunteers. Users must first authenticate by entering a valid email address and password. If the entered credentials are incorrect, the system displays an appropriate error message. New users may register by providing their name, email address, and password, followed by email verification through a One-Time Password (OTP) sent by the system. Users may also reset their password through the Forgot Password feature, which sends a verification OTP to the registered email address.
After successful authentication, users are redirected to their respective dashboards based on their assigned roles.
Upon login, the Barangay Captain is directed to the Barangay Captain Dashboard, which provides an overview of project monitoring activities. The dashboard displays summary analytics such as projects awaiting approval, approved projects, rejected projects, and the total allocated budget of approved projects. The Barangay Captain may review submitted project proposals from SK Barangay Officials and decide whether to approve, reject, or request revisions. When rejecting or requesting revisions, the Barangay Captain is required to enter feedback in a comment field to clearly communicate the reason for the decision to the SK Officials.
After logging in, SK Barangay Officials are redirected to the SK Officials Dashboard, where they can view recent announcements and access key system functions through quick navigation buttons. SK Officials may upload public files by selecting the Upload File option, choosing a document, and receiving a success notification once the upload is completed. Files may be searched using keywords or filtered by category, and unnecessary files can be ar energized removed by selecting the delete option and confirming the action.
SK Officials may also manage announcements by selecting the Create Announcement option, entering the announcement title and description, and optionally uploading an image. Published announcements are displayed to users and may be edited or deleted as needed.
For project monitoring, SK Officials can select Create Project and enter project details such as title, category, schedule, location, and description. Created projects appear in the project list and may be edited prior to approval. To manage volunteer participation, SK Officials can access the View Details & Applications option on each project card to review pending applications, approve or reject applicants, and read or respond to inquiries submitted by Youth Volunteers.
SK Officials may also view project-related events in a calendar interface presented in a monthly grid format. Notifications may be sent to selected volunteers by choosing an event from the calendar and specifying the target recipients, allowing volunteers to be reminded of upcoming activities.
Youth Volunteers are provided with a simplified interface containing limited access based on their role. Their dashboard highlights available projects and relevant announcements. Youth Volunteers may browse public files and view documents but are not permitted to upload or delete files.
When interested in a project, Youth Volunteers may search or filter the project list, view project details, and select the Apply Now option. This redirects them to the application form, where applicants below 18 years old are required to upload a parental consent document before submission. Upon successful application, the system displays a confirmation message, and volunteers may track their application status through the My Applications section.
Youth Volunteers may also submit questions related to projects using the Send Inquiry feature and view project schedules and deadlines through the calendar interface.

### 5.2. Screen Mockups

The homepage serves as the public entry point of the Barangay Information Management System, introducing users to SK Malanday’s youth programs, volunteer opportunities, and ongoing community projects. It highlights key system features, promotes transparency, and provides clear calls to action for users to sign up, log in, or browse projects.















#### Figure D5.2.1:  Homepage Mockup

The login page allows registered users to securely access the Barangay Information Management System using their email and password. Upon successful authentication, users are redirected to their respective dashboards based on their roles: Barangay Captain, SK Officials, or Youth Volunteers.


#### Figure D5.2.2:  Login Mockup













The sign-up page enables new users to create an account by providing basic personal information, email address, and password. It supports account verification to ensure secure registration and automatically assigns users to the appropriate role, primarily Youth Volunteers, before granting access to the system.


#### Figure D5.2.3: Sign-Up Mockup

This page allows youth volunteers to view published announcements and updates from SK Officials in an organized, card-based layout. It also enables volunteers to submit their testimonies and feedback based on their project experiences, supporting transparency and community engagement.


#### Figure D5.2.4: Manage Content Mockup (Youth Volunteers)

The dashboard provides SK Officials with an overview of barangay activities, including key statistics on files, announcements, active projects, and youth volunteers. It also allows officials to manage announcements and edit transparency reports such as budget allocation and project success metrics for monitoring performance and accountability.


#### Figure D5.2.5: Manage Content Mockup (SK Officials)


























This modal allows youth volunteers to view the full details of an announcement, including its title, description, category, and date. It ensures that volunteers clearly understand important updates and project-related information shared by SK Officials.


#### Figure D5.2.6: Manage Content Mockup View Announcement Modal (Youth Volunteers)

This interface enables SK Officials to create new announcements by entering the title, description, category, and optional banner elements. It supports efficient information dissemination to ensure timely communication with youth volunteers and the community.


#### Figure D5.2.7: Manage Content Mockup Create Announcement (SK Officials)






This modal allows SK Officials to view announcement details in full, including content and publication information.


#### Figure D5.2.8: Manage Content Mockup View Announcement Modal (SK Volunteers)

This modal allows SK Officials to update existing announcements by modifying their content, category, or other details. It ensures that corrections and updates can be made easily without removing the original announcement.


#### Figure D5.2.9: Manage Content Mockup Edit Announcement Modal (SK Volunteers)














This confirmation modal allows SK Officials to permanently remove an announcement from the system. It helps prevent accidental deletion by requiring user confirmation before the announcement is removed.


#### Figure D5.2.10: Manage Content Mockup Delete Announcement Modal (SK Volunteers)

This confirmation modal allows SK Officials to permanently remove an announcement from the system. It helps prevent accidental deletion by requiring user confirmation before the announcement is removed.


#### Figure D5.2.11: Manage File Mockup (Youth Volunteers)











This confirmation modal allows SK Officials to permanently remove an announcement from the system. It helps prevent accidental deletion by requiring user confirmation before the announcement is removed.



#### Figure D5.2.12: Manage File Mockup (SK Officials)

This confirmation modal allows SK Officials to permanently remove an announcement from the system. It helps prevent accidental deletion by requiring user confirmation before the announcement is removed.


#### Figure D5.2.13: Manage File Mockup View File Modal (Youth Volunteers)









This confirmation modal allows SK Officials to permanently remove an announcement from the system. It helps prevent accidental deletion by requiring user confirmation before the announcement is removed.


#### Figure D5.2.14: Manage File Mockup Upload File Modal (SK Officials)

This confirmation modal allows SK Officials to permanently remove an announcement from the system. It helps prevent accidental deletion by requiring user confirmation before the announcement is removed.


#### Figure D5.2.15: Manage File Mockup View File Modal (SK Officials)











This confirmation modal allows SK Officials to permanently remove an announcement from the system. It helps prevent accidental deletion by requiring user confirmation before the announcement is removed.


#### Figure D5.2.16: Manage File Mockup Archived File Modal (SK Officials)

The Manage Project module for Youth Volunteers provides a structured interface for discovering and participating in barangay projects that have been approved by SK Officials. Volunteers can browse projects using search and category filters, view comprehensive project details through a modal interface, and submit applications by completing a standardized form. The system enforces data accuracy through required fields and automatically applies parental consent requirements for applicants under 18 years old. Youth volunteers may track their submitted applications, edit pending applications, and monitor application status updates. Additionally, the module supports project-specific inquiries, enabling two-way communication between volunteers and SK Officials through threaded inquiry discussions and notifications.




#### Figure D5.2.17: Manage Project Mockup (Youth Volunteers)

The Manage Project module for SK Officials supports the complete project lifecycle, from proposal creation to post-implementation evaluation. SK Officials can create and edit project proposals by defining project details, schedules, locations, volunteer targets, and budget-related information before submitting them for Barangay Captain approval. Once approved, projects become visible to youth volunteers and allow officials to monitor applications, review applicant profiles, and manage participation decisions. The module also includes an inquiry management feature that consolidates volunteer questions into organized threads for efficient response handling. After project completion, SK Officials conduct structured project evaluations using predefined performance criteria, enabling systematic assessment, transparency, and data-driven reporting of project outcomes.


#### Figure D5.2.18: Manage Project Mockup (SK Officials)

This modal presents complete project information to youth volunteers, including project title, category, status, duration, location, assigned project heads, and a detailed project description. The information is organized into structured sections to help volunteers clearly understand the project scope before applying or submitting inquiries. Tab-based navigation separates project details from inquiry discussions for improved usability.


#### Figure D5.2.19: Manage Project Mockup View Project Details Modal (Youth Volunteers)

This modal enables youth volunteers to submit questions related to a specific project and view ongoing inquiry threads. Volunteers can track replies from SK Officials and continue conversations through a threaded messaging interface. Inquiry notifications ensure that volunteers are promptly informed when responses are posted.


#### Figure D5.2.20: Manage Project Mockup Project Inquiries Modal (Youth Volunteers)
This modal allows youth volunteers to modify previously submitted project applications while the application status remains pending. Volunteers can update personal information, preferred roles, and required documents, with validation rules enforced by the system. Parental consent requirements are automatically applied or disabled based on the applicant’s age to maintain compliance and data accuracy.

#### Figure D5.2.21: Manage Project Mockup Edit Project Application Modal (Youth Volunteers)










This modal allows SK Officials to create new project proposals by entering comprehensive project details, including objectives, category, location, schedule, volunteer targets, and budget-related information. The system structures inputs to ensure completeness before submission. Created proposals are automatically routed for Barangay Captain review and approval.


#### Figure D5.2.22: Manage Project Mockup Create Project Proposal Modal (SK Officials)















This modal enables SK Officials to revise existing project proposals, particularly those requiring modification or clarification prior to approval. Officials can update project details, schedules, and resource allocations while preserving previously entered data. This ensures accurate and up-to-date project information throughout the approval process.


#### Figure D5.2.23: Manage Project Mockup Edit Project Proposal Modal (SK Officials)














This modal displays the full details of an approved project, including its current status, assigned project heads, and implementation timeline. It allows SK Officials to review finalized project information and monitor progress during execution. The interface ensures transparency and consistency between approved proposals and publicly visible project listings.


#### Figure D5.2.24: Manage Project Mockup View Project Details Modal - Approved  (SK Officials)

This modal provides SK Officials with a consolidated list of all volunteer applications submitted for a specific project. Applications are presented with status indicators to support efficient screening and decision-making. Filtering and selection features help officials manage large numbers of applicants effectively.


#### Figure D5.2.25: Manage Project Mockup View Project Applicants Modal (SK Officials)

This view displays detailed information for an individual volunteer applicant, including personal details, preferred role, submitted documents, and application status. It allows SK Officials to evaluate applicant eligibility and readiness before approval or rejection. This ensures informed and accountable volunteer selection.


#### Figure D5.2.26: Manage Project Mockup View Project Applicants Details (SK Officials)
This modal consolidates all volunteer inquiries related to a project into organized discussion threads. SK Officials can review questions, post responses, and monitor communication history. The feature promotes transparent and timely interaction between officials and youth volunteers.

#### Figure D5.2.27: Manage Project Mockup View Project Inquiries Modal (SK Officials)

This modal allows SK Officials to assess completed projects using predefined evaluation criteria with assigned weight percentages to ensure objective scoring. Budget Efficiency (25%) evaluates how effectively the planned budget was utilized compared to actual expenses, while Volunteer Participation (20%) measures the percentage of actual volunteers against the target number. Timeline Adherence (20%) assesses whether the project was completed on time, early, or delayed, Community Impact (20%) measures how well the project achieved its intended outcomes or beneficiary targets, and Volunteer Feedback (15%) reflects participant satisfaction based on submitted evaluations. The system computes a weighted total score from these percentages to generate the overall project performance result, supporting transparency, accountability, and data-driven improvements for future barangay projects.


#### Figure D5.2.28: Manage Project Mockup Project Evaluation Modal (SK Officials)




The monthly calendar view allows youth volunteers to see all approved projects, events, and deadlines plotted across an entire month. Each calendar entry represents a project or activity created by SK Officials and synchronized from the project management module. This view helps volunteers plan participation in advance and identify overlapping schedules or upcoming commitments.

#### Figure D5.2.29: Calendar Mockup Monthly View (Youth Volunteers)

The weekly view provides a more detailed breakdown of scheduled projects and activities within a specific week. It displays exact dates and time ranges, allowing volunteers to better manage short-term availability. This view is particularly useful for monitoring closely scheduled or time-sensitive projects.


#### Figure D5.2.30: Calendar Mockup Weekly View(Youth Volunteers)


The daily view focuses on a single day’s activities, showing precise start and end times for each project or event. It enables volunteers to clearly see their commitments for the day and prepare accordingly. This view supports better time management and reduces the risk of missed project activities.


#### Figure D5.2.31: Calendar Mockup Daily View (Youth Volunteers)




















When a calendar entry is selected, the project view modal displays detailed project information such as description, location, project head, and current status. Youth volunteers can use this view to send project inquiries or proceed with application actions when available. This ensures that volunteers can transition seamlessly from schedule viewing to project engagement.



#### Figure D5.2.32: Calendar Mockup Project View (Youth Volunteers)


The calendar module for SK Officials provides a comprehensive overview of all project schedules, deadlines, and key events across monthly, weekly, and daily views. In addition to viewing schedules, SK Officials can access detailed project information, monitor inquiries, and initiate volunteer notifications directly from calendar entries. The module also includes an upcoming events list and notification tools to support proactive project coordination and volunteer communication.

#### Figure D5.2.33 : Calendar Mockup (SK Officials)








This feature allows SK Officials to create and send custom in-app notifications to volunteers directly from the calendar module. Officials can select a specific project or event, define the target group (such as all volunteers, approved applicants, or project-specific participants), and compose a message using predefined templates or custom text. This functionality ensures timely communication of reminders, schedule changes, urgent updates, and acknowledgments, supporting effective coordination and volunteer engagement.



#### Figure D5.2.34 : Calendar Mockup Custom Notification (SK Officials)

This module allows youth volunteers to access certificates generated after successful participation in completed projects. Certificates become available only once project completion and evaluation requirements are met, ensuring validity and credibility. The interface provides a clear list of earned certificates linked to corresponding projects.


#### Figure D5.2.35: Certificate Mockup (Youth Volunteers)



This modal enables youth volunteers to submit a satisfaction survey after completing a project. Volunteers provide ratings and written feedback reflecting their experience, which are used as inputs for project evaluation and improvement. Submission of the survey is required before certificate generation to ensure feedback completeness.


#### Figure D5.2.36: Certificate Mockup Volunteer Satisfaction Survey Modal (Youth Volunteers)

This modal allows youth volunteers to preview their issued certificates, displaying key details such as volunteer name, project title, participation date, and issuing authority. Volunteers can download the certificate in a digital format for personal records or external use. This feature supports recognition of volunteer contributions and encourages continued participation.

#### Figure D5.2.37: Certificate Mockup Volunteer View and Download Certificate Modal (Youth Volunteers)




This module allows SK Officials to manage testimonies submitted by youth volunteers after project participation. Officials can review testimony content, satisfaction ratings, and submission status, as well as feature selected testimonies for public viewing. The module supports approval, deletion, and highlighting of testimonies to promote transparency and community engagement.


#### Figure D5.2.38 : Testimonies Mockup (SK Officials)




















The archive module provides SK Officials with access to completed and inactive projects and records. Archived items are removed from active operational views but are stored for a retention period of one (1) year, during which SK Officials can generate reports in PDF, spreadsheet, and text document formats for documentation, auditing, and reporting purposes. This ensures long-term data integrity, flexible data extraction, and an organized active system environment.



#### Figure D5.2.39: Archive Mockup (Sk Officials)

















This view allows SK Officials to access full details of archived projects, including project descriptions, schedules, budgets, volunteer data, and evaluation results. It also enables officials to generate and download comprehensive project reports in PDF, spreadsheet, and text document formats using the archived data. This supports post-project analysis, auditing, and future planning by preserving and exporting complete project records.


#### Figure D5.2.40: Archive Mockup View Details of Archived Projects (Sk Officials)












This interface displays files associated with archived projects, such as reports, attendance sheets, and supporting documents. SK Officials can review, download, or permanently remove archived files as needed. The feature ensures organized retention of historical documents while maintaining system performance and clarity.



#### Figure D5.2.41: Archive Mockup Archived files  (Sk Officials)









#### Figure D5.2.42: Archive Mockup Project Report Generated (Sk Officials)







#### Figure D5.2.43: Project Monitoring Mockup Attendance Generated (Sk Officials)


This notification panel informs SK Officials about custom announcements, newly posted announcements, new volunteer applications, newly posted projects, and incoming inquiries with corresponding replies. It also provides real-time project status updates, including approved (ongoing), pending for revision, and rejected projects, supporting effective project monitoring and coordination.


#### Figure D5.2.44: Notification for SK








This notification interface keeps youth volunteers informed about custom announcements from SK Officials, inquiry updates, and newly posted projects. It also notifies volunteers of changes in their application status to ensure they remain updated on their participation.

#### Figure D5.2.45:Notification for Youth Volunteers


























This notification interface alerts the Barangay Captain of project approval requests submitted by SK Officials. It supports timely review and decision-making for approving, rejecting, or requesting revisions on proposed projects.


#### Figure D5.2.46:Notification for Barangay Chairman















This is the Barangay Captain Dashboard of Barangay Malanday wherein they can see the number of pending approvals, approved projects, rejected projects, and total budget of approved projects. Also, the list of projects that can be viewed in different tabs.



#### Figure D5.2.47: Barangay Captain Dashboard

This is the modal for reviewing SK projects proposal in which the captain could reject project, request revision, and approve project. Additionally, the Barangay Captain is required to provide comments or notes when rejecting or requesting revision for a project.


#### Figure D5.2.48: Project Approval Modal of Barangay Captain





# Copy of Tab 1



Software Design Document




In partial fulfillment of the requirements for the course:
ICS26010
Software Engineering I



Barangay Information Management System (BIMS)
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


## System Overview

The Barangay Information Management System (BIMS) is a website portal designed for the Sangguniang Kabataan (SK) Officials and youth volunteers for Barangay Malanday, Marikina City. These youth leaders are responsible for organizing youth development projects, managing files, and communicating with barangay constituents. In response to the challenges identified during the interview, the function was designed to address the critical assumptions and validated operational needs. The function development team identified four main functions based on the client's current problems. These include: (1) Login, (2) Manage Content, (3) Manage Files, and (4) Monitor Projects.

The functional requirements are included to support the workflow of the SK official and the youth volunteers, ensuring security, efficiency, usability, reliability, maintainability, and performance.

The login function ensures security, allowing only authorized users to access website features and data. It is used to distinguish user roles and provide privileges.  It includes sign-up subfunctions, allowing the youth of Barangay Malanday to create an account as youth volunteers. It also has a 'Forgot Password' function that allows users to change their passwords if they have forgotten them. It also requires two-factor account authentication to ensure that the email address used is active and for added security in the event that the account is compromised.

The manage content function enables usability, maintainability, and performance. It facilitates the communication of announcements from SK officials to their constituents in the barangay. SK officials may create, delete, edit, and view content. Youth volunteers are only allowed to view content. This function ensures the timely dissemination of information and a larger reach.

The manage files function supports usability, maintainability, and performance for files uploaded into the function. It organizes and stores public files needed by the SK official, resolving their problem of storing public files on personal drives.  The SK officials may upload, delete, view, and search for files. While the youth volunteers may only view and search for files. This function enables transparency in files, such as budget allocation among barangay constituents, and maintains a file repository among officials.

The monitor projects function provides performance and reliability. This enables the proper dissemination of the SK projects to their constituents, including the project title, purpose, location, and timeline. SK officials can create, edit, delete, view, filter, search projects, review applications, and respond to inquiries. Moreover, upon submission of a project proposal from the SK Officials’ end, the system automatically forwards the proposal to the Barangay Captain for review. The Barangay Captain may view the proposal details, including its description and current status, and may approve or reject the proposal accordingly.  For youth volunteers, they may view, search projects, inquire and create threads, register for a specific project, and view and edit applications. This functionality enables barangay constituents to be informed about various youth development projects and to attract more participants while also allowing the SK Officials to have a systemized .process of project monitoring.

The external interface requirements of the function encompass several critical components that ensure usability, security, and performance. First, the function must provide a user-friendly interface that allows seamless interaction with its five main functional requirements, offering intuitive navigation, responsive design, and clear feedback mechanisms. To strengthen security, the function integrates the Gmail API to enable double authentication of all users, combining traditional login credentials with Gmail-based verification for enhanced protection. Additionally, a web server HTTP interface is required to handle client-server communication, supporting standard HTTP methods, secure HTTPS connections, and proper request-response management with error handling. Finally, the function must include a robust database to store and manage all information, supporting reliable CRUD operations, as well as role-based access control to safeguard sensitive data. Together, these external interfaces define how the function interacts with users and external services, ensuring a secure, efficient, and user-centered experience.
## System Architecture
### Architectural design

Login

Figure D2.1.1 showcases the subfunctions of the login function. The login function is structured as a dedicated function that manages authentication and user account processes for both SK Barangay Officials and SK Youth Volunteers. This function handles user registration, login, and password recovery, ensuring secure access to the barangay management function. Login, registration, and password recovery receive OTP verification in their email to confirm that the right user is performing these functions.

This login function collaborates closely with other functions by verifying user credentials and passing authorized user roles to enforce appropriate permissions across the function. For example, once a user logs in, their role (official or volunteer) is communicated to the different management functions to determine access levels.

This partitioning allows the login function to focus solely on security and identity management, while other functions handle domain-specific functions like file management, content management, project management, and calendar management. Together, these functions integrate seamlessly to provide a secure, role-aware, and functional function that meets the needs of its users.

#### Figure D2.1.1 Detailed Use Case Diagram: Login


File Management

Figure D2.1.2 indicates the relationship of the subfunctions of managing files. The file management function consists of four subfunctions: viewing, searching and filtering, uploading, and deleting files within the repository. SK Barangay Officials have full access to all these subfunctions, allowing them to manage files comprehensively. Meanwhile, SK Youth Volunteers have limited access, restricted to viewing, searching, and filtering files only.

This function works in coordination with the login function, which authenticates users and assigns roles. Based on the user’s role, the file management function enforces access control, enabling or restricting certain subfunctions accordingly. This ensures that only authorized users can perform sensitive operations like uploading or deleting files, while others can still access necessary information securely.




#### Figure D2.1.2 Detailed Use Case Diagram: Manage Files

Content Management

Figure D2.1.3 indicates the relationship of the subfunctions of managing content. The content management function includes subfunctions such as creating, deleting, editing, and viewing announcements. SK Barangay Officials have full access to all these subfunctions, allowing them to manage announcements comprehensively. In contrast, SK Youth Volunteers are limited to viewing announcements only, ensuring they stay informed without modifying content.

This function works in coordination with the login function, which authenticates users and assigns roles. Based on the user’s role, the content management function enforces access control, enabling or restricting certain subfunctions accordingly. This ensures that only authorized users can perform sensitive operations like creating or deleting announcements, while others can still access necessary information securely.


#### Figure D2.1.3 Detailed Use Case Diagram: Manage Content

Project Management

Figure D2.1.3 indicates the relationship of the subfunctions of managing projects. The Manage Project function includes several subfunctions divided by user roles. SK Barangay Officials can create, edit, delete projects, respond to inquiries, and review applications. Youth Volunteers can view, search, filter projects, register for upcoming projects, and submit and reply to inquiries. Both roles share viewing, filtering, and searching capabilities.

This function works in coordination with the login function, which authenticates users and assigns roles. Based on the user’s role, the project management function enforces access control, enabling or restricting subfunctions accordingly. This ensures secure and appropriate access to project-related features.

#### Figure D2.1.4 Detailed Use Case Diagram: Manage Project

Login
The D2.2.1 diagram presents the login process and the interactions with other actors. There are three lanes: Gmail API, System, and SK Official/Volunteer. The SK Official/Volunteer is responsible for all user input. In login, they must input a correct email address, password, and OTP. As for sign-up, they must input their full name, email, password, and verify their email address is active by inputting OTP. Lastly, to reset their password, they must input their email address and verify their identity by inputting OTP. After confirming, they are now allowed to reset the password.
The function is the one responsible for validating all user input, whether it matches the fields in the database, such as email address and password. And for double authentication, the function would generate an OTP with expiry. And through the help of the Gmail API, the OTP will be sent to their respective Gmail accounts







#### Figure D2.2.1 Swimlane diagram: Login
File Management
The diagram D2.2.2 shows the file management process and its interactions with the other actors. There are three lanes: SK Official/Volunteer, System, and SK Official. SK Official is the one responsible for uploading the files through file name input, file category selection, and choosing a file. The SK Official can also delete the files by clicking delete and confirming the action. Moving on, the SK Officials/Volunteer can both search and filter files by selecting the type and inputting the keywords.
The function is responsible for the validation such as validation file uploads and whether the uploaded file size is less than or equal to 10MB. If the file is valid, it would be uploaded successfully. If not, the function would reject it. The function would prompt a confirmation message for deletion, showing “Do you want to delete?”. For searching, the function checks if there is a matching file and displays the result, if there are no matches it prompts a message “No Files Founds”.

#### Figure D2.2.2 Swimlane diagram: File Management
Content Management
The Diagram at Figure D2.2.3 shows the content management process and how it interacts with the other actors. It has three lanes which are: SK Officials, System, and SK Official/Youth Volunteer. SK Officials is the one responsible for the creation of announcements. The SK Officials can create by selecting a category, inputting the content title and descriptions, and uploading a picture. Additionally, they can also edit the existing announcements through modifying the details and submitting it. SK Officials are able to delete announcements by clicking the delete button and confirming. Youth Volunteers can only view the announcements.

The function is the one responsible for the validation of all inputs such as checking the size of the picture. If it is less than or equal to 5MB, there will be a function prompting “Do you want to post announcements?”

#### Figure D2.2.3 Swimlane diagram: Content Management
Project Management
The Diagram at Figure D2.2.4 shows the updated swimlane diagram for the Manage Projects function. It illustrates the step-by-step interactions between the SK Officials, SK Officials/Youth Volunteers, the System, and the SK Volunteers. The diagram tracks how the projects are created and edited by the officials, how the volunteers submit the applications and inquiries, and how the system validation works through checking the age and parental consent requirements of the volunteers. It also updates the application records throughout the process.





#### Figure D2.2.4 Swimlane diagram: Project Management










## B. Decomposition Description
Login



#### Figure D2.3.1 System sequence diagram: Login

In Figure D2.3.1 when logging in, the user needs to provide their password and email address. The function will send a One-Time Password (OTP) to the user's Gmail account if the password is correct. The OTP is then entered by the users, and if it is accurate, the function will establish a session and grant access. The user will have the option to register if the account does not already exist. If the password is incorrect, the user has five chances to enter it correctly before being locked for fifteen minutes.







File Management



#### Figure D2.3.2 System sequence diagram: File Management

In Figure D2.3.2, SK Officials can upload, download, view, filter, search, and delete files while Youth Volunteers can view, download, filter, and search files. The function validates the file size and prompts confirmation for deletion.








Content Management



#### Figure D2.3.3 System sequence diagram: Content Management

In Figure D2.3.3, SK Officials can create, view, delete, and edit content. Both Youth Volunteers and the SK Officials can view content. The function validates the size of the image (maximum of 5MB) and prompts confirmation for editing and deletion.













Project Management







#### Figure D2.3.4 System sequence diagram: Project Management

In Figure D2.3.4, SK Officials can create, edit, delete, view, search, and filter projects. They can also reply to inquiries and manage applications by approving, rejecting, or viewing their status. Youth Volunteers can view, search, filter, and register for projects. If under 18, they must upload a parental consent file. They can also submit inquiries and edit their applications.





## Data Design

### Data Description
The data design outlines how the function’s information domain is represented and managed through structured data models. The SK Management System handles several categories of information, such as users, projects, announcements, files,  and inquiries. Each of these items is transformed into a corresponding data structure that is stored and maintained in a relational database.

Real-world objects are mapped into database entities that contain attributes describing their characteristics. Relationships between entities are implemented through primary keys and foreign keys to maintain consistency across the function. For example, when a youth volunteer registers for a project, a new record is created in the ProjectRegistration entity that links a user to a specific project. Similarly, files uploaded by SK officials are associated with the File entity, while announcements, inquiries, and calendar events reference related users and projects.

Data is handled through common operations such as creating and deleting records. These operations are executed according to the user’s role. SK Officials are permitted to create or modify projects, announcements, and calendar events, while youth volunteers primarily perform viewing and inquiry-related functions.

# Figure D3: E-R diagram
### Data Dictionary

#### Table 3.1: Data dictionary of  Application Table

#### Table 3.2: Data dictionary of  Content Table

#### Table 3.3: Data dictionary of  File Table

#### Table 3.4: Data dictionary of  Inquiry Table

#### Table 3.5: Data dictionary of  OTP Table

#### Table 3.6: Data dictionary of  SK Table

#### Table 3.7: Data dictionary of  Project Table


#### Table 3.8: Data dictionary of  Reply Table

#### Table 3.9: Data dictionary of User Table

## 4. Component Design

Class diagrams visually represent a system's classes, attributes, and methods as they illustrate their relationships and interactions. Figure D4 is a class diagram that represents a comprehensive system for managing projects, files, contents, and user data. The diagram illustrates the structure and relationships between various entities.

At the core of the system is the user, since it serves as the central actor in the system. It holds the user data and credentials. And has the ability to log in, forget password, and sign up. This class is the connector of all other classes and distinguishes the permissions of each user.

The project class contains detailed information such as projectID, creator details, title, description, category, status, start and end dates, location, and image path. Before any application or inquiry can be made, a project must be created first. And if there is an inquiry, the user may reply. It holds the attributes replyID, inquiryID, userID, message, and timeStamp.

The content class is for managing announcements for the timely dissemination of information. It has the methods of creating, editing,  deleting, and viewing.

The file class allows the management of public files of the SK official. It has the ability to upload, delete, filter, and search for files. This is for the transparency of the files to the public.


#### Figure D4: Class diagram


## 5. Human Interface Design

### 5.1 Overview of User Interface
The function gives Barangay Captain, SK Officials, as well as the Youth Volunteers the  access to the barangay information and monitor projects depending on their roles. The user must first log in by entering their email and password. If the details do not match, it would display an error message. New users can sign up by giving their name, email address, password, and verifying their email through OTP sent by the function.  The user can also be able to reset their password in case they forgot and is sent to the user’s email.
The Barangay Captain is directed through their dashboard after successfully logging  in. Inside the Barangay Captain’s dashboard is the overview of the project monitoring. The Barangay Captain could view the summary of the project analytics, such as those projects that are waiting for approval, the approved and rejected projects as well as the running total budget. Furthermore, the Barangay Captain is able to approve the submitted project proposal of the SK Officials. For instances that the project proposal is to be rejected or to be revised, the Barangay Captain is initially required to input their feedback on the comment field to be able to provide feedback to the SK Official to inform them of the grounds of disapproval.
SK Officials is sent through the SK Officials dashboard once logged in. They can see recent announcements and quick access buttons. From here, they can upload files by clicking the “Upload File”, choose a document, or receive a success notification once it is saved. Files can be searched using keywords or filtered by category. Unnecessary files are deleted by clicking the Delete and pressing the confirmation button. SK Officials can also create announcements by clicking the create new announcement button. Once clicked, the user must fill in the title and description and an option to add an image. Once done it is published in the announcements and can later be edited or deleted.

For project monitoring, SK Officials can click “Create Project” and enter the project details such as the title, category, dates, location, and description. After filling up the project details, the project appears in the project list and can be edited if desired. For managing the applications, SK Officials can open the “View Details & Applications” on the project card to see whether there are pending applicants. They have the option to choose whether to approve or reject each one and can read and reply to inquiries submitted by the volunteers. We can see the events in the calendar view and it is in a monthly grid. The SK Officials can send the notifications by selecting the event in the calendar, and the target volunteers, reminding the volunteers for the upcoming activities.

Youth Volunteers have a similar interface but with only limited options. First, their dashboard only highlights the available projects and announcements relevant to them. They can still browse files and open any document by clicking “View”, but they cannot upload or delete the files unlike the SK Officials. If the Volunteers have a project that interests them, they can search or filter the project list, open its details, and click the “Apply Now” button. This will redirect them to the application form where Volunteers below 18 years old are asked to upload a parental consent file before submitting. After applying, Youth Volunteers can see the confirmation message and can review their status of applications in the “My applications" section. They can also send questions about the project by clicking the “Send Inquiry” and view the project deadlines/scheduled events in the calendar.




### 5.2. Screen Mockups


#### Figure D5.2.1:  Login Mockup


#### Figure D5.2.2: Sign-Up Mockup



#### Figure D5.2.3: Manage Content Mockup (Youth Volunteers)



#### Figure D5.2.4: Manage Content Mockup (SK Officials)











#### Figure D5.2.3: Manage Content Mockup Create Announcement (SK Volunteers)


#### Figure D5.2.3: Manage Content Mockup View Announcement Modal (Youth Volunteers)


#### Figure D5.2.3: Manage Content Mockup View Announcement Modal (SK Volunteers)


#### Figure D5.2.3: Manage Content Mockup Edit Announcement Modal (SK Volunteers)


#### Figure D5.2.3: Manage Content Mockup Delete Announcement Modal (SK Volunteers)




#### Figure D5.2.5: Manage File Mockup (Youth Volunteers)



#### Figure D5.2.6: Manage File Mockup (SK Officials)









#### Figure D5.2.5: Manage File Mockup View File Modal (Youth Volunteers)


#### Figure D5.2.6: Manage File Mockup Upload File Modal (SK Officials)


#### Figure D5.2.6: Manage File Mockup View File Modal (SK Officials)


#### Figure D5.2.6: Manage File Mockup Archived File Modal (SK Officials)


#### Figure D5.2.7: Manage Project Mockup (Youth Volunteers)




#### Figure D5.2.8: Manage Project Mockup (SK Officials)






#### Figure D5.2.7: Manage Project Mockup View Project Details Modal (Youth Volunteers)


#### Figure D5.2.7: Manage Project Mockup Project Inquiries Modal (Youth Volunteers)



#### Figure D5.2.7: Manage Project Mockup Edit Project Application Modal (Youth Volunteers)























#### Figure D5.2.8: Manage Project Mockup Create Project Proposal Modal (SK Officials)






#### Figure D5.2.8: Manage Project Mockup Edit Project Proposal Modal (SK Officials)



#### Figure D5.2.8: Manage Project Mockup View Project Details Modal - Approved  (SK Officials)




#### Figure D5.2.8: Manage Project Mockup View Project Applicants Modal (SK Officials)



#### Figure D5.2.8: Manage Project Mockup View Project Applicants Details (SK Officials)




#### Figure D5.2.8: Manage Project Mockup View Project Inquiries Modal (SK Officials)



#### Figure D5.2.8: Manage Project Mockup Project Evaluation Modal (SK Officials)







#### Figure D5.2.9: Calendar Mockup Monthly View (Youth Volunteers)


#### Figure D5.2.9: Calendar Mockup Weekly View(Youth Volunteers)





#### Figure D5.2.9: Calendar Mockup Daily View (Youth Volunteers)




#### Figure D5.2.9: Calendar Mockup Project View (Youth Volunteers)



#### Figure D5.2.10 : Calendar Mockup (SK Officials)







#### Figure D5.2.11: Certificate Mockup (Youth Volunteers)




#### Figure D5.2.11: Certificate Mockup Volunteer Satisfaction Survey Modal (Youth Volunteers)


#### Figure D5.2.11: Certificate Mockup Volunteer View and Download Certificate Modal (Youth Volunteers)





#### Figure D5.2.10 : Calendar Mockup Custom Notify Volunteers (SK Officials)










#### Figure D5.2.12 : Testimonies Mockup (SK Officials)







#### Figure D5.2.13: Archive Mockup (Sk Officials)





#### Figure D5.2.13: Archive Mockup View Details of Archived Projects (Sk Officials)




#### Figure D5.2.13: Archive Mockup Archived files  (Sk Officials)





| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Announcement_Tbl | announcementID | INTEGER | PRIMARY KEY | Unique identifier for content |
| Announcement_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Dictates author of the content |
| Announcement_Tbl | title | VARCHAR(255) | NOT NULL | Title of the content |
| Announcement_Tbl | category | ENUM(URGENT, UPDATE, GENERAL) | NOT NULL | Type or classification of content |
| Announcement_Tbl | contentStatus | ENUM(ACTIVE,  ARCHIVED) | DEFAULT: ACTIVE | Status of content |
| Announcement_Tbl | description | VARCHAR(255) | NULLABLE | Describes content |
| Announcement_Tbl | imagePathURL | VARCHAR(255) | NULLABLE | Links to image |
| Announcement_Tbl | publishedDate | DATE | NOT NULL | Date published |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Anual_Budget_Tbl | annualBudgetID | INT | PRIMARY KEY | Unique Id for Annual Budget |
| Anual_Budget_Tbl | expenseCategory | VARCHAR | NULLABLE | The expense category |
| Anual_Budget_Tbl | budget | LONG | NULLABLE | Allocated budget |
| Anual_Budget_Tbl | FiscalYear | INT | NOT NULL | Year of the budget allocation |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Application_Tbl | applicationID | INTEGER | PRIMARY KEY | Unique Identifier for each application |
| Application_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Linked Applicant |
| Application_Tbl | preProjectID | INTEGER | FOREIGN KEY | Linked Project |
| Application_Tbl | preferredRole | VARCHAR(255) | NOT NULL | Desired role for the project |
| Application_Tbl | parentConsentFile | VARCHAR(255) | NOT NULL | Link to consent form |
| Application_Tbl | applicationStatus | ENUM(PENDING, APPROVIED, REJECTED) | DEFAULT: PENDING | Status of application |
| Application_Tbl | appliedDate | DATE | DEFAULT: CURRENT | Date of application |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| BudgetBreakdown_Tbl | breakdownID | INT | PRIMARY KEY | Unique key for budget |
| BudgetBreakdown_Tbl | preProjectID | INT | FOREIGN KEY | The connected project |
| BudgetBreakdown_Tbl | description | VARCHAR(255) | NOT NULL | The item for a budget |
| BudgetBreakdown_Tbl | cost | LONG | NOT NULL | The allocated budget |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Certificate_Tbl | certificationID | INT | PRIMARY KEY | Unique certificate ID |
| Certificate_Tbl | postProjectID | INT | FOREIGN KEY | The project the certificate for |
| Certificate_Tbl | applicationID | INT | FOREIGN KEY | The user who receives the certificate |
| Certificate_Tbl | certificateFileURL | VARCHAR(255) | NOT NULL | template |
| Certificate_Tbl | userID | VARCHAR(255) | FOREIGN KEY | The user who had given the certificate |
| Certificate_Tbl | timeStamp | DATETIME | NOT NULL | The date and time that the certificate was given |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Expenses_Tbl | expenseID | INTEGER | PRIMARY KEY | Unique identifier for each expense record |
| Expenses_Tbl | breakdownID | INTEGER | FOREIGN KEY | References BreakdownBreakdown_Tbl(breakdownID) – Associated budget breakdown |
| Expenses_Tbl | actualCost | DECIMAL(15,2) | NOT NULL | Actual amount spent for this expense |
| Expenses_Tbl | receiptSet | VARCHAR(255) | Nullable | Path or URL to receipt/invoice document |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Evaluation_Tbl | evaluationID | INT | PRIMARY KEY | Unique ID evaluation |
| Evaluation_Tbl | projectID | INT | FOREIGN KEY | The connected project |
| Evaluation_Tbl | applicationID | INT | FOREIGHN KEY | Connected applicant |
| Evaluation_Tbl | q1 | INT | NOT NULL | Question 1 |
| Evaluation_Tbl | q2 | INT | NOT NULL | Question 2 |
| Evaluation_Tbl | q3 | INT | NOT NULL | Question 3 |
| Evaluation_Tbl | q4 | INT | NOT NULL | Question 4 |
| Evaluation_Tbl | q5 | INT | NOT NULL | Question 5 |
| Evaluation_Tbl | message | VARCHAR(255) | NULLABLE | Suggestion and opinions |
| Evaluation_Tbl | timeStamp | DATETIME | NOT NULL | Date time an evaluation was completed |
| Evaluation_Tbl | hasCertificate | BOOL | DEFAULT: FALSE | If the applicant is able to have a certificate |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| File_Tbl | fileID | INTEGER | PRIMARY KEY | Unique file identifier |
| File_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Owner of the file |
| File_Tbl | fileName | VARCHAR(255) | NOT NULL | Name of the file |
| File_Tbl | fileType | ENUM(PDF, XLSX, JPG,PNG, DOC) | NOT NULL | Format or extension of the file (PDF, JPG) |
| File_Tbl | fileStatus | ENUM(ACTIVE, ARCHIVED) | DEFAULT: ACTIVE | Availability status of the file. |
| File_Tbl | filePath | VARCHAR(255) | NOT NULL | File Location in the local function |
| File_Tbl | fileCategory | ENUM(GENERAL, PROJECT) | NOT NULL | Type or classification of file |
| File_Tbl | dateUploaded | DATE | DEFAULT: CURRENT | Upload timestamp |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Inquiry_Tbl | inquiryID | INTEGER | PRIMARY KEY | Unique inquiry identifier |
| Inquiry_Tbl | preProjectID | INTEGER | FOREIGN KEY | Linked project |
| Inquiry_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Linked user |
| Inquiry_Tbl | message | VARCHAR(255) | NOT NULL | Content of the inquiry |
| Inquiry_Tbl | isReplied | BOOLEAN | DEFAULT:” FALSE | Indication if a reply has been made |
| Inquiry_Tbl | timeStamp | DATETIME | DEFAULT: CURRENT | Time when inquiry is submitted |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Logs_Tbl | logID | INTEGER | PRIMARY KEY | Unique identifier for each log entry |
| Logs_Tbl | userID | INTEGER | FOREIGN KEY | User performing the action |
| Logs_Tbl | action | VARCHAR(255) | NOT NULL | Description of the action taken (e.g., 'Created Project', 'Updated Application') |
| Logs_Tbl | replyID | INTEGER | FOREIGN KEY, Nullable | If action relates to a reply |
| Logs_Tbl | postProjectID | INTEGER | FOREIGN KEY, Nullable | If action relates to post-project activity |
| Logs_Tbl | applicationID | INTEGER | FOREIGN KEY, Nullable | If action relates to an application |
| Logs_Tbl | inquiryID | INTEGER | FOREIGN KEY, Nullable | If action relates to an inquiry |
| Logs_Tbl | notificationID | INTEGER | FOREIGN KEY, Nullable | If action triggered a notification |
| Logs_Tbl | fileID | INTEGER | FOREIGN KEY, Nullable | If action involves file operations |
| Logs_Tbl | testimonyID | INTEGER | FOREIGN KEY, Nullable | If action relates to a testimony |
| Logs_Tbl | timestamp | DATETIME | DEFAULT: CURRENT_TIMESTAMP | Date and time when the action was logged |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Notification_Tbl | notificationID | INTEGER | PRIMARY KEY | Unique file identifier |
| Notification_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Owner of the file |
| Notification_Tbl | notificationType | ENUM(“new announcement”, “inquiry update”, “new project”, “application approved”, “application pending”, “project approved”, “project rejected”, “revision requested”, “new inquiry”, “new application”, “project awaiting approval”) | NOT NULL | Type of Notification |
| Notification_Tbl | title | VARCHAR(255) | NOT NULL | Title of the Notification |
| Notification_Tbl | isRead | BOOLEAN | DEFAULT: “FALSE” | Indicates if the notification has been read |
| Notification_Tbl | createdAt | DATETIME | NOT NULL | Date that the notification has created |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| OTP | otpID | INTEGER | PRIMARY KEY | Unique identifier for each OTP entry |
| OTP | userID | VARCHAR(255) | FOREIGN KEY | User associated with the OTP |
| OTP | otpCode | VARCHAR(6) | NOT NULL | One-time password code |
| OTP | expiresAt | DATETIME | NOT NULL | OTP expiration |
| OTP | isUsed | BOOLEAN | DEFAULT: FALSE | Indicates if the OTP has been used |
| OTP | purpose | ENUM(LOGIN, FORGET, SIGN-UP) | NOT NULL | Purpose of request |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Report_Tbl | reportID | INTEGER | PRIMARY KEY | Unique identifier for each report |
| Report_Tbl | postProjectID | INTEGER | FOREIGN KEY | References Post_Project_Tbl(postProjectID) – Report linked to post-project phase |
| Report_Tbl | applicationID | INTEGER | FOREIGN KEY | References Application_Tbl(applicationID) – Report tied to a participant application |
| Report_Tbl | evaluationID | INTEGER | FOREIGN KEY | References Evaluation_Tbl(evaluationID) – Evaluation metrics included in report |
| Report_Tbl | reportStatus | ENUM('DRAFT','SUBMITTED','APPROVED','REJECTED') | DEFAULT: 'DRAFT' | Current status of the report |
| Report_Tbl | requestedAN | DATETIME | Nullable | Date and time when report submission was requested |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| SK_Tbl | skID | INTEGER | PRIMARY KEY | Assigned project |
| SK_Tbl | userID | VARCHAR(255) | FOREIGN KEY | User assigned as project head |
| SK_Tbl | position | ENUM(SK_CHAIRMAN, SK_SECRETARY, SK_TREASURER, SK_AUDITOR, SK_KAGAWAD) | NOT NULL | Position within the barangay |
| SK_Tbl | termStart | DATE | NOT NULL | SK term Start |
| SK_Tbl | termEnd | DATE | NOT NULL | SK term end |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Pre_Project_Tbl | preProjectID | INTEGER | PRIMARY KEY | Unique project identifier |
| Pre_Project_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Project creator |
| Pre_Project_Tbl | skID | INT | FOREIGN KEY | Project heads |
| Pre_Project_Tbl | title | VARCHAR(255) | NOT NULL | Name of project |
| Pre_Project_Tbl | description | VARCHAR(255) | NOT NULL | Overview of the project |
| Pre_Project_Tbl | category | VARCHAR(255) | NOT NULL | Type or classification of project |
| Pre_Project_Tbl | budget | LONG | NOT NULL | Allocated budget |
| Pre_Project_Tbl | volunteers | INT | NOT NULL | Volunteers expected |
| Pre_Project_Tbl | beneficiaries | INT | NOT NULL | Expected benefeciaries |
| Pre_Project_Tbl | status | ENUM(ONGOING, COMPLETED, CANCELLED) | DEFAULT: ONGOING | Status of the project |
| Pre_Project_Tbl | startDateTime | DATETIME | NOT NULL | Start date and time |
| Pre_Project_Tbl | endDateTime | DATETIME | NOT NULL | End date and time |
| Pre_Project_Tbl | location | VARCHAR(255) | NOT NULL | Location of Project |
| Pre_Project_Tbl | imagePathURL | VARCHAR(255) | NULLABLE | Visual reference of projects |
| Pre_Project_Tbl | submittedDate | DATE | NOT NULL | Date a project was submitted |
| Pre_Project_Tbl | approvalStatus | ENUM(REVISION, PENDING, APPROVE, REJECT) | DEFAULT:PENDING | Approval status of a project |
| Pre_Project_Tbl | approvalDate | DATE | NULLABLE | Date a project was approved |
| Pre_Project_Tbl | approvalnotes | VARCHAR(255) | NULLABLE | Notes for revision or rejection of a project |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Post_Project_Tbl | postProjectID | INTEGER | PRIMARY KEY | Unique project identifier |
| Post_Project_Tbl | preProjectID | INTEGER | FOREIGN KEY | The project is to be compared to see if it met |
| Post_Project_Tbl | breakdownID | INTEGER | FOREIGN KEY | The expenses of the breakdown were met |
| Post_Project_Tbl | actualVolunteer | INTEGER | NOT NULL | The actual volunteer |
| Post_Project_Tbl | timelineAdherance | ENUM(Completed_On_Time, Slightly_Delayed,Delayed, Significantly Delayed | NOT NULL | If the timeline adhered to a timeline |
| Post_Project_Tbl | beneficiariesReached | INT | NOT NULL | Total beneficiaries after the project |
| Post_Project_Tbl | projectAchievement | VARCHAR | NOT NULL | Check if the project have achievements |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Reply_Tbl | replyID | INTEGER | PRIMARY KEY | Unique identifier for each reply |
| Reply_Tbl | inquiryID | INTEGER | FOREIGN KEY | Inquiry being replied into |
| Reply_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Responder |
| Reply_Tbl | message | VARCHAR(255) | NOT NULL | Content of reply |
| Reply_Tbl | timeStamp | DATETIME | DEFAULT: CURRENT | Time of reply was sent |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Testimonies_Tbl | testimonyID | INTEGER | PRIMARY KEY | Unique identifier for each testimony record |
| Testimonies_Tbl | userID | INTEGER | FOREIGN KEY | User providing the testimony |
| Testimonies_Tbl | message | TEXT | NOT NULL | Content of the testimony or feedback |
| Testimonies_Tbl | isFiltered | BOOLEAN | DEFAULT: FALSE | Indicates if testimony has been reviewed/moderated |
| Testimonies_Tbl | timeStamp | DATETIME | DEFAULT: CURRENT_TIMESTAMP | Date and time the testimony was submitted |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| User_Tbl | userID | VARCHAR(255) | PRIMARY KEY | Unique user identifier |
| User_Tbl | password | VARCHAR(255) | NOT NULL | Password for authentication |
| User_Tbl | email | VARCHAR(255) | UNIQUE, NOT NULL | Email address of the user |
| User_Tbl | firstName | VARCHAR(255) | NOT NULL | User’s first name |
| User_Tbl | lastName | VARCHAR(255) | NOT NULL | User’s last name |
| User_Tbl | middleName | VARCHAR(255) | NOT NULL | User’s middle name |
| User_Tbl | role | ENUM(SK_OFFICIAL, YOUTH_VOLUNTEER) | NOT NULL | Role of the user |
| User_Tbl | birthday | DATE | NOT NULL | User’s date of birth |
| User_Tbl | contactNumber | VARCHAR(13) | NOT NULL | User’s contact number |
| User_Tbl | address | VARCHAR(255) | NOT NULL | User’s home address |
| User_Tbl | imagePathURL | VARCHAR(255) | NULLABLE | Profile picture of user |
| User_Tbl | termsConditions | BOOLEAN | NOT NULL | Agreement to the terms and conditions of the function |
| User_Tbl | accountStatus | ENUM(ACTIVE, INACTIVE, PENDING) | DEFAULT: PENDING | Status of the account (active, inactive, or pending) |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Application_Tbl | applicationID | INTEGER | PRIMARY KEY | Unique Identifier for each application |
| Application_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Linked Applicant |
| Application_Tbl | projectID | INTEGER | FOREIGN KEY | Linked Project |
| Application_Tbl | preferredRole | VARCHAR(255) | NOT NULL | Desired role for the project |
| Application_Tbl | parentConsentFile | VARCHAR(255) | NOT NULL | Link to consent form |
| Application_Tbl | applicationStatus | ENUM(PENDING, APPROVIED, REJECTED) | DEFAULT: PENDING | Status of application |
| Application_Tbl | appliedDate | DATE | DEFAULT: CURRENT | Date of application |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Content_Tbl | announcementID | INTEGER | PRIMARY KEY | Unique identifier for content |
| Content_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Dictates author of the content |
| Content_Tbl | title | VARCHAR(255) | NOT NULL | Title of the content |
| Content_Tbl | category | ENUM(URGENT, UPDATE, GENERAL) | NOT NULL | Type or classification of content |
| Content_Tbl | contentStatus | ENUM(ACTIVE,  ARCHIVED) | DEFAULT: ACTIVE | Status of content |
| Content_Tbl | description | VARCHAR(255) | NULLABLE | Describes content |
| Content_Tbl | imagePathURL | VARCHAR(255) | NULLABLE | Links to image |
| Content_Tbl | publishedDate | DATE | DEFAULT:CURRENT | Date of publication |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| File_Tbl | fileID | INTEGER | PRIMARY KEY | Unique file identifier |
| File_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Owner of the file |
| File_Tbl | fileName | VARCHAR(255) | NOT NULL | Name of the file |
| File_Tbl | fileType | ENUM(PDF, XLSX, JPG,PNG, DOC) | NOT NULL | Format or extension of the file (PDF, JPG) |
| File_Tbl | fileStatus | ENUM(ACTIVE, ARCHIVED) | DEFAULT: ACTIVE |  |
| File_Tbl | filePath | VARCHAR(255) | NOT NULL | File Location in the local function |
| File_Tbl | fileCategory | ENUM(GENRAL, PROJECT) | NOT NULL | Type or classification of file |
| File_Tbl | dateUploaded | DATE | DEFAULT: CURRENT | Upload timestamp |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Inquiry_Tbl | inquiryID | INTEGER | PRIMARY KEY | Unique inquiry identifier |
| Inquiry_Tbl | projectID | INTEGER | FOREIGN KEY | Linked project |
| Inquiry_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Linked user |
| Inquiry_Tbl | message | STRING | NOT NULL | Content of the inquiry |
| Inquiry_Tbl | isReplied | BOOLEAN | DEFAULT:” FALSE | Indication if a reply has been made |
| Inquiry_Tbl | timeStamp | DATETIME | DEFAULT: CURRENT | Time when inquiry is submitted |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| OTP | otpID | INTEGER | PRIMARY KEY | Unique identifier for each OTP entry |
| OTP | userID | VARCHAR(255) | FOREIGN KEY | User associated with the OTP |
| OTP | otpCode | VARCHAR(6) | NOT NULL | One-time password code |
| OTP | email | VARCHAR(255) | NOT NULL | Email associated with OTP |
| OTP | expiresAt | DATETIME | NOT NULL | OTP expiration |
| OTP | isUsed | BOOLEAN | DEFAULT: FALSE | Indicates if the OTP has been used |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| SK_Tbl | projectID | INTEGER | PRIMARY KEY | Assigned project |
| SK_Tbl | userID | VARCHAR(255) | FOREIGN KEY | User assigned as project head |
| SK_Tbl | position | ENUM(SK_CHAIRMAN, SK_SECRETARY, SK_TREASURER, SK_AUDITOR, SK_KAGAWAD) | NOT NULL | Position within the barangay |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Project_Tbl | projectID | INTEGER | PRIMARY KEY | Unique project identifier |
| Project_Tbl | createdBy | VARCHAR(255) | FOREIGN KEY | Project creator |
| Project_Tbl | skID | VARCHAR(255) | FOREIGN KEY | Project heads |
| Project_Tbl | title | VARCHAR(255) | NOT NULL | Name of project |
| Project_Tbl | description | VARCHAR(255) | NOT NULL | Overview of the project |
| Project_Tbl | category | VARCHAR(255) | NOT NULL | Type or classification of project |
| Project_Tbl | status | ENUM(ONGOING, COMPLETED, CANCELLED) | DEFAULT: ONGOING | Status of the project |
| Project_Tbl | startDateTime | DATETIME | NOT NULL | Start date and time |
| Project_Tbl | endDateTime | DATETIME | NOT NULL | End date and time |
| Project_Tbl | location | VARCHAR(255) | NOT NULL | Location of Project |
| Project_Tbl | imagePathURL | VARCHAR(255) | NULLABLE | Visual reference of projects |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Reply_Tbl | replyID | INTEGER | PRIMARY KEY | Unique identifier for each reply |
| Reply_Tbl | inquiryID | INTEGER | FOREIGN KEY | Inquiry being replied into |
| Reply_Tbl | userID | VARCHAR(255) | FOREIGN KEY | Responder |
| Reply_Tbl | message | VARCHAR(255) | NOT NULL | Content of reply |
| Reply_Tbl | timeStamp | DATETIME | DEFAULT: CURRENT | Time of reply was sent |


| Entity | Field Name | Data Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| User_Tbl | userID | VARCHAR(255) | PRIMARY KEY | Unique user identifier |
| User_Tbl | password | VARCHAR(255) | NOT NULL | Password for authentication |
| User_Tbl | email | VARCHAR(255) | UNIQUE, NOT NULL | Email address of the user |
| User_Tbl | firstName | VARCHAR(255) | NOT NULL | User’s first name |
| User_Tbl | lastName | VARCHAR(255) | NOT NULL | User’s last name |
| User_Tbl | middleName | VARCHAR(255) | NOT NULL | User’s middle name |
| User_Tbl | role | ENUM(SK_OFFICIAL, YOUTH_VOLUNTEER) | NOT NULL | Role of the user |
| User_Tbl | birthday | DATE | NOT NULL | User’s date of birth |
| User_Tbl | contactNumber | VARCHAR(13) | NOT NULL | User’s contact number |
| User_Tbl | address | VARCHAR(255) | NOT NULL | User’s home address |
| User_Tbl | imagePathURL | VARCHAR(255) | NULLABLE | Profile picture of user |
| User_Tbl | termsConditions | BOOLEAN | NOT NULL | Agreement to the terms and conditions of the function |
| User_Tbl | accountStatus | ENUM(ACTIVE, INACTIVE, PENDING) | DEFAULT: PENDING | Status of the account (active, inactive, or pending) |
