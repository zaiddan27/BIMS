<a id="_74z1q54cv4ox"></a>working draft

__System Requirements Specification__

## <a id="_6ggayimjcmnm"></a>

## <a id="_4z2bsxg666gf"></a>

In partial fulfillment of the requirements for the course:

ICS26010

Software Engineering I

## <a id="_rn7ak9jsooj3"></a>

## <a id="_h8le2gu01g8s"></a>

## <a id="_xq58gqujixe8"></a>

__Barangay Information Management System \(BIMS\)__

__for SK Malanday, Marikina City__

__Submitted by:__

Ancheta, Jerome N\.

Dela Vega, Elijah M\.

Espinosa, Ryan Paolo C\.

Ledonio, JC Dre Gabriel V\.

Nicdao, Kyleen P\.

Pelias, Andrea Marie C\.

Ralleta, Brian Louis B\.

Santos, Gavin Adrian C\.

Sergio, Juliana Gabriella A\.

__Submitted to:__

Asst\. Prof\. Mia V\. Eleazar

__Table of Contents__

[__1\. Introduction	4__](#_h01lxheoe76p)

[1\.1 Project Purpose	4](#_qhleoe5yl96j)

[Figure R\-1: Fishbone Diagram	5](#_4jpeglo7nl10)

[1\.2 Project Scope	5](#_ocpwzz7ecrg5)

[2\. Overall Description	7](#_fxj7nq6c7jot)

[2\.1 Project Perspective	8](#_vp1ypgkdnosr)

[Figure R\-3: Use case diagram	9](#_7h0a0ytcqdd2)

[2\.2 User Accounts and Characteristics	10](#_cu8x672hc8ov)

[2\.3 Project Functions	10](#_aazaalcjsxbv)

[2\.3\.1 Login and Authentication	11](#_ee73x7p7n05k)

[Figure R\-5\.1: Login Activity diagram	12](#_xbala4qr0xbq)

[2\.3\.2 Monitor Project	13](#_47i9z7p74235)

[Figure R\-5\.4\.1: Monitoring Project \(Youth Volunteer side\) Activity diagram	15](#_vh4psb38qmej)

[2\.3\.3 File Management	15](#_4qwn9ndb6axb)

[Figure R\-5\.2\.1: Manage Files \(SK Official side\) Activity diagram	17](#_u6jji5xd71jy)

[Figure R\-5\.2\.2: Manage Files \(Youth Volunteer side\) Activity diagram	17](#_e4uchy5nnjk0)

[2\.3\.4 Manage Content	17](#_oitfq0nemg9r)

[Figure R\-5\.3\.1: Manage Content \(SK Official side\) Activity diagram	19](#_9pkp69vmd3jv)

[Figure R\-5\.3\.2: Manage Content \(Youth Volunteer side\) Activity diagram	20](#_hpvjgwjplycj)

[2\.4 Operating Environment	20](#_9rrnuoxpz1e5)

[Table R\-1: Functional Requirements	21](#_27uu3h50yivu)

[Table R\-2: Non\-Functional Requirements	22](#_ol9owh8hwe9c)

[2\.5 Design and Implementation Constraints	22](#_q8llbrdlxtri)

[2\.5\.1 Risk Assessment	22](#_pu7bp9i2r7ip)

[2\.5\.2 Assumptions and Dependencies	23](#_lhn07qq2x29q)

[2\.6 User Documentation	24](#_i73j09s7tufe)

[2\.6\.1 Need for User Experience	24](#_dsln9xfm9ffc)

[2\.6\.2 Documentation Plan	24](#_i268q7iffs0q)

[2\.6\.3 Implementation Strategy	25](#_4dc0rwxjey7h)

[__3\. External Interface Requirements	26__](#_gh4gipx7nw8n)

[3\.1 User Interfaces	26](#_wg8zeylgs7ez)

[3\.2 Hardware Interfaces	26](#_pxoetkkjhyou)

[3\.3 Software Interfaces	27](#_v6fv9n28irll)

[3\.4 Communication Interfaces	27](#_u1tc5t2lgdth)

[__4\. System Features	27__](#_hfpvr724nn0j)

[4\.1 Login and User Authentication	28](#_kb1pl9vnq6fx)

[4\.1\.1 Sub\-functions	28](#_wlnhzxdd0ve)

[4\.1\.2 Non\-Functional Requirements	28](#_qtlju6r8sovy)

[4\.2\. Monitor Project	28](#_w1u0og3jh9ag)

[4\.2\.2 Non\-Functional Requirements	29](#_3kho04m2rlsn)

[4\.3 File Management	29](#_23580rs7rjb)

[4\.3\.2 Non\-Functional Requirements	30](#_stkhm4edwab5)

[4\.4\. Content Management	30](#_wqurlts5rah)

[5\. Business Rules	31](#_d6ghb2s0kkzm)

[Primary Users	31](#_d3c10h58an1r)

[Secondary Users	32](#_yrlvvrucr8h3)

[System Administrators	32](#_d4f09vmwlwdu)

[Barangay Captain	32](#_ri2ede6cyko3)

[SK Officials	32](#_qunkt7se8107)

[Youth Volunteers	33](#_2kta2qc7svcb)

[__6\. Appendices	34__](#_la8vd1s0co5h)

[6\.1 Initial  Interview Transcripts	34](#_2m5t0kl2tyn0)

[6\.2 Second Interview	38](#_ytx0cu7to6wh)

[6\.2 Google Form Interview	39](#_3x1ztuy48269)

[6\.2\.1 Barangay Malanday \(SK Officials\) \- Scattered Files	40](#_o9ezsgm5vaqm)

[6\.2\.2 Barangay Malanday \(SK Officials\) \- Scattered Files	41](#_vru4vscr29ex)

[6\.2\.2 Barangay Malanday \(SK Officials\) \- Scattered Files	42](#_hxdtrlsnb6hj)

[6\.3\.1\. Barangay Malanday \(Youth Volunteers\) \- No Calendar	43](#_kp88ah8ts8ee)

[6\.3\.2\. Barangay Malanday \(Youth Volunteers\) \- No Calendar	44](#_itd9t98eacmw)

[6\.3\.2\. Barangay Malanday \(Youth Volunteers\) \- No Calendar	45](#_ntbq4219djhd)

[6\.4\.1\. Follow\-up Interview: SK Officials & Youth Volunteers \- FAQ	46](#_aqfwuzxm4sfn)

[6\.4\.2\. Follow\-up Interview: SK Officials & Youth Volunteers \- FAQ	47](#_rjg1l32r2ctn)

[6\.5\.1\. SK Officials \- Post don't convert to sign ups	48](#_yhxsoawk2485)

[6\.5\.3\. SK Officials \- Post don't convert to sign ups	50](#_unme34cg41id)

[6\.5\.4\. SK Officials \- Post don't convert to sign ups	51](#_3hmkr43wghm5)

[6\.5\.5\. SK Officials \- Post don't convert to sign ups	52](#_v6by0ig77sk8)

[6\.6\.1\. SK Officials \- Current Status Metrics	52](#_svsieyp4mzji)

[6\.6\.2\. SK Officials \- Current Status Metrics	53](#_j11ihdgiuhto)

## <a id="_h01lxheoe76p"></a>__Introduction__

To enhance operational efficiency, transparency, and coordination among Sanggunian Kabataan \(SK\) officials and youth volunteers in Barangay Malanday, Marikina City, this project aims to create a centralized information management and project monitoring system\.

The system will feature document organizing, project monitoring\. The barangay captain will evaluate and approve project submissions, while SK officials would oversee the records, announcements, and approve youth volunteer project applications\. At the same time, the youth volunteers would be able to view the projects, register for the projects, stay informed about the latest schedules, and view and download certifications of participation\.

The system will address recurring problems with project records handling, disintegrated public files, and inefficient reporting process\. Furthermore, the system also aims to enhance immediate interaction between SK Officials and volunteers\. Security will be a top priority, with access granted on a limited basis based on roles and user identity verification\.

### <a id="_qhleoe5yl96j"></a>	__1\.1 Project Purpose__

The group identified the need to enhance the efficiency and organization of the current file management and project monitoring system used by the SK Officials and Youth Volunteers of Barangay Malanday\. Based on the Fishbone Analysis, several root causes of data inefficiency were identified\. To begin with, youth volunteers experience significant difficulty when applying for barangay projects due to the barangay’s predominantly manual, paper\-based, and unstructured application process\. This results in delays, lost submissions, and a lack of clear visibility regarding application status\.

Additionally, the internal processes of the barangay further contribute to inefficiency\. Files are stored in scattered locations, and there is no standardized method for file sharing or version tracking\. This fragmented workflow leads to inconsistent information flow, frequent errors, and disorganized data management\.

____

#### <a id="_4jpeglo7nl10"></a>*Figure R\-1: Fishbone Diagram*

The design objectives of the project include the development of a centralized information management system that provides a secure and unified repository for documents\. This system will facilitate efficient retrieval, structured organization, and streamlined management of files, thereby minimizing redundancy and improving overall data systemization\.

In addition, the system will enable the Barangay Captain to approve and oversee the system of barangay projects\. The SK Officials to create, update, and archive project records with ease\. This ensures a more efficient workflow for SK Officials while also encouraging Youth Volunteers to participate in and register for ongoing barangay projects through a more accessible and user\-friendly platform\.

The beneficiaries of this system are the Barangay Captain, SK Officials, and the Youth Volunteers who actively support the barangay’s initiatives\.

To gain a clearer understanding of the client’s requirements, the group conducted an interview with Ms\. Cielo Villaroman, the SK Secretary of Barangay Malanday\. During the discussion, Ms\. Villaroman highlighted recurring challenges in managing announcements, managing files, monitoring projects, and the approval process for Youth Volunteers’ project applications\. She also expressed the need for a system that enables efficient retrieval, improved search functionality, and proper access control to support organized and secure information management\.

A full transcript of this interview is accessible in __Appendix A__\.

### <a id="_ocpwzz7ecrg5"></a>	__1\.2 Project Scope__

This project aims to enhance both the internal and external operations of the Sangguniang Kabataan \(SK\) of Barangay Malanday, Marikina by developing a comprehensive information management and project monitoring system\. The system is intended to improve efficiency, transparency, and coordination among SK officials and youth volunteers\. Furthermore, the system supports the complete project life cycle, beginning with project proposal submission, followed by project application and review, Barangay Captain evaluation with project approval, rejection, or pending\-for\-revision status, project implementation and monitoring, project evaluation, and finally project archiving\. This end\-to\-end lifecycle approach ensures that all SK projects are systematically documented, tracked, assessed, and stored for future reference and accountability\.

Given the established time constraints and defined project limitations, the system will focus primarily on file management, project monitoring, and content management, ensuring that these essential services remain accessible and functional for SK officials and youth volunteers\. Moreover, tables of testimonies and archives are seen below the four \(4\) main functional requirements\. The table for testimonies features the testimonials from youth volunteers of the previous projects that generate the youth volunteers certification\. The table for archives showcases historical project records and comprehensive reports that can be downloaded in bulk or individually\. The files are immediately archived after the one \(1\) year shelf life of the document\.

Additionally, the scope of this project is strictly limited to the features and accessibility of the web\-based system itself\. It explicitly excludes any responsibility for addressing barangay\-level connectivity issues, including Wi\-Fi, internet reliability, or related infrastructure concerns\.

The main goal of this project is to transition from manual record\-keeping to a centralized digital platform for managing SK files, projects, and announcements, as well as for assessing and approving youth volunteers’ application forms for eligible projects\. Currently, the barangay maintains only two official documents, which are stored manually\. This manual handling limits accessibility, causes delays, and increases the risk of disorganization, issues the system aims to resolve through structured digital storage and proper documentation workflows\.

By implementing this digital system, the operational workload of SK officials is expected to become more efficient and less time\-consuming, as repetitive manual tasks will be streamlined and digitally organized\.

The project’s objective is to develop a reliable web\-based system that enables Barangay Captain to approve and evaluate project submissions and SK officials to create, update, and delete project records\. The system will also allow SK officials to upload, manage, and systematically store the barangay’s official public documents\. Additionally, it will support efficient publication of announcements and testimonials of the youth volunteer\. On the part of the volunteers, the system will allow them to view upcoming projects and register for specific activities through a dedicated project registration form linked to each project’s details\.

Lastly, to ensure system integrity and confidentiality, data security will be prioritized through the implementation of role\-based access control and user authentication across all system modules\.



*Figure R\-2: Validation Board*

### <a id="_fxj7nq6c7jot"></a>__Overall Description__

The Barangay Information Management System \(BIMS\) provides a centralized web platform that enables Barangay Captain to approve and evaluate project submission and SK officials to efficiently monitor projects, manage content, and manage files\. It also strengthens engagement with youth volunteers and visitors of the system \(without user accounts\) by ensuring transparency reports and accessible information\.

The system offers youth volunteers a convenient platform where they can participate in events or projects organized by the SK officials and garner multiple certificates of participation regarding the projects they have participated in\. The volunteers post\-event feedback is crucial with the project success metrics with a weight of 15%\. The youth volunteers certificate is part of their personal endeavors and self\-fulfillment\. They can view available content and projects, and submit inquiries for additional information\.

The system has minimal hardware requirements, users only need a desktop or mobile device with an internet connection\. For software requirements, the system must run on a web browser with an active server\. Furthermore, to reduce hosting costs while ensuring accessibility, BIMS will operate through a shared hosting environment, with its cloud storage and built\-in database for storing the details gathered from the users\.

For the overall process flow, users begin by logging into the system, after which their assigned role is validated\. The system then grants access to the appropriate modules and records all actions in the system logs while updating the database accordingly\.

### <a id="_vp1ypgkdnosr"></a>__2\.1 Project Perspective__

The Barangay Information Management System \(BIMS\) is a website portal designed to cater to the needs of the SK officials and youth volunteers of Barangay Malanday, Marikina City\. Barangay Captain has an only role to approve project documents, while SK officials have administrative rights, allowing them to create, edit, archive, and view data\. On the other hand, youth volunteers have regular user permissions, which only grant them the right to view, register, and inquire\. The software development team was able to decide to create four \(4\) main functionalities based on the analysis of the validation board\. 

The login function provides security to the system, ensuring that only authorized personnel can access and perform actions on the data and files\. This function has two subfunctions of forget password and sign up\. The regular user can create their own account by using the sign\-up function, which requires registering their  email, password, full name, and agreeing to terms and conditions\. And the forgot password function may be used when a user has forgotten their password\. 

The manage file function enables SK officials to store their files on the system, while also allowing the youth volunteers to view these files for transparency\. The subfunctions of this function are: upload, view, archive, filter, and search for files\. SK officials may upload files and archive them\. Both users can view and search for the files they need\.

The manage content function allows SK officials to share announcements with their barangay constituents\. It has subfunctions for creating, viewing, editing, and archiving announcements\. The SK official has the ability to create, edit, and archive these announcements\. Both the SK official and the youth volunteer can view announcements\. 

The monitor project function allows SK officials to create projects and enables youth volunteers to join these projects\. It also enables its barangay constituents to be informed of its monthly projects\. It has subfunctions for creating, archiving, editing, viewing, filtering, searching, registering projects, reviewing applications, inquiring about projects, and replying to project inquiries\. The SK official has the ability to create, archive, edit, filter, view, search projects, approve applications, and reply to project inquiries\. While the youth volunteers have the ability to view, search, filter projects, and register when interested, and may also inquire and reply  with the project heads for further clarifications\.



#### <a id="_7h0a0ytcqdd2"></a>*Figure R\-3: Use case diagram*

Moreover, a table that includes testimonies and archive reports are seen below the four \(4\) main functional requirements\. The testimonies table includes the various testimonies feedback by the youth volunteer which has a weight with the project success metrics\. The archive table showcases historical project records and comprehensive reports\. Files with a shelf\-life of one \(1\) year will automatically be archived and seen at the archived table\. However, documents can be permanently deleted manually and the SK officials have the power to do so\.

### <a id="_cu8x672hc8ov"></a>__                   2\.2 User Accounts and Characteristics__

The system is designed for three primary user roles: Barangay Captain, SK Officials, and Youth Volunteers, each with distinct access levels and system functionalities based on their responsibilities\.

The Barangay Captain is granted limited but critical access to the system, primarily focused on project oversight and decision\-making\. This role is responsible for reviewing and evaluating project proposals submitted by SK Officials and issuing approval, rejection, or pending\-for\-revision decisions within the SK Barangay Information Management System \(BIMS\)\. The Barangay Captain may also provide feedback or comments to guide revisions, ensuring that all projects align with barangay policies, objectives, and resource constraints\.

SK Officials are the primary administrative users of the system and are expected to possess a basic level of technical proficiency\. They are responsible for creating, managing, editing, submitting, and archiving project proposals and related documents\. SK Officials oversee the full project workflow,  from proposal preparation and submission to implementation tracking and post\-project evaluation\. The system enables them to monitor project status, track document progress, respond to volunteer inquiries, and maintain organized and secure records\. Their main objective is to ensure compliance with council requirements while efficiently managing SK projects through a centralized and reliable platform\.

Youth Volunteers are end users of the system with access tailored to participation and information retrieval\. They are considered beginner users and primarily perform tasks such as account registration, authentication, viewing announcements and project details, filtering and searching project files, and submitting inquiries related to SK\-led initiatives\. Youth Volunteers may also apply or register for community projects, track application status, and engage with project information through project cards and inquiry modals, enabling direct communication with SK Officials\.

SK Officials and Youth Volunteers interact collaboratively within the system\. SK Officials initiate and manage projects, while Youth Volunteers participate by registering, monitoring project updates, and providing support during implementation\. This structured interaction promotes transparency, collaboration, and efficient coordination, contributing to smoother operations and improved project execution within the SK council\.

### <a id="_aazaalcjsxbv"></a>	      __2\.3 Project Functions__

The system features a straightforward and user\-friendly structure, showing how barangay officials and residents navigate through different processes from beginning to end\. Through activity diagrams, these visualizations clearly show how the barangay system's different modules work together smoothly on its step\-by\-step process as performed by the assigned user role\.

__ 2\.3\.1 Login and Authentication__

Before accessing the login process, these preconditions must be met: The user must have accessed the BIMS, the database must be operational, and the user must input correct credentials\. The login process is initiated when the user inputs their login credentials, including email address and password\. Then, the system receives the request and checks its database to see if there is a registered account, which is represented through a decision node\.

Once it is confirmed that a user exists, the system verifies if the retrieved data matches the provided credentials\. If yes, the user receives a One\-Time\-Pin \(OTP\) code via email and is required to enter it\. If the OTP is correct, the user is logged into the system\.

If no user is found in the database, they will not have any access to the system\. A maximum of 5 incorrect attempts is allowed before the user is removed from access to the system for 15 minutes\. Before the fifth incorrect attempt, the user may register for an account by entering their email, password, first name, last name, middle name, and accepting the terms and conditions\. The user receives an OTP through Google Mail to ensure that the email used is active\. If the OTP is correct, they may proceed to log in\.

If the email is correct but the password is incorrect, the system logs the attempt into the database and allows a maximum of 5 attempts before removing access to login for 15 minutes\. Before the fifth failed attempt, the user may change their password by first entering their email address\. The user receives an OTP to ensure that the user changing the password is the intended user\. Once the OTP is correct, the user may input the new password and proceed to the login process\. If the OTP is incorrect, the user may request another OTP or re\-enter the OTP, provided it has not expired\.

After the user has logged in, the system must meet the post\-conditions: the user must have been authenticated, a session is created, the login is accounted for, and authorization is granted\.



#### <a id="_xbala4qr0xbq"></a>*Figure R\-5\.1: Login Activity diagram*

### <a id="_47i9z7p74235"></a>__       2\.3\.2 Monitor Project__

As system permissions vary by user role, the Monitor Project function is divided into two primary perspectives: the SK Official’s end and the Youth Volunteer’s end\. Regardless of role, the function requires the same preconditions: the user must have an active account with authorized system access, the system database must be operational, the user’s role must be correctly identified, and the project must already exist for actions such as viewing, editing, archiving, registration, and inquiry\.

The SK Official’s Monitor Project function includes role\-exclusive subfunctions related to project administration and management\. First, SK Officials can create new project proposals by providing required project details, including the project title, category, proposed budget \(which is reflected in the budget breakdown\), expected number of volunteers, start and end dates and times, location, project heads, optional banner image, target beneficiaries, and project description\. Upon submission, the project is automatically marked as subject for Barangay Captain approval\. Uploaded banner images must not exceed 5 MB; otherwise, the system prompts the user to reupload a compliant file\.

Once a project proposal is approved by the Barangay Captain, the project status is updated to Ongoing, and the Barangay Captain’s decision and remarks are displayed in the decision section of the project modal for transparency\.

SK Officials may edit existing projects, provided that any modification is again subject to review and approval by the Barangay Captain\. This ensures accountability and prevents unauthorized changes to approved project details\.

SK Officials may also archive projects after the project has been marked as Completed\. Archiving may be performed manually through a confirmation prompt or automatically through the system after a defined document shelf\-life of one year\. Archived documents may later be permanently deleted through a manual administrative action\.

In addition, SK Officials can manage youth volunteer applications by updating their status to Approved, Rejected, or Pending within the project record\. They may also generate and download attendance sheets for approved volunteers\.

From the Barangay Captain’s dashboard, the primary function is project review and approval monitoring\. The Barangay Captain can evaluate submitted project proposals and issue one of three decisions: Approve Project, Request Revision, or Reject Project\. The Captain may also provide written feedback or comments to guide SK Officials during revisions\.

The dashboard additionally provides an overview of pending, approved, and rejected projects, as well as the total approved budget utilized across all SK projects\.

The Youth Volunteer’s Monitor Project function focuses on participation and engagement\. Youth Volunteers may view available projects, filter and search projects, and submit inquiries using the built\-in inquiry modal associated with each project\. Once an inquiry is submitted, the system generates a dashboard notification for SK Officials\. Volunteers are likewise notified when a response has been posted\.

SK Officials and Youth Volunteers share common subfunctions, including viewing projects, searching, filtering project listings, and message\-based interaction\. Both roles can browse existing projects and locate specific entries using search functionality\.

As postconditions, the system must successfully store all updates in the database, record SK Official actions in the system log, and trigger appropriate notifications, particularly informing Youth Volunteers when inquiries receive responses\.

  
*Figure R\-5\.4\.0: Monitoring Project \(SK Official side\) Activity diagram*

Youth Volunteers are provided with three primary subfunctions within the system: Project Registration, Inquiry Submission, and Inquiry Reply Participation\.

For the Project Registration subfunction, youth volunteers may apply to participate in approved and ongoing projects through a dedicated application form accessible from the selected project’s details page\. The volunteer is required to provide essential information, including full name, birthday, contact number, email address, complete address, and preferred role in the project\. If the applicant is below 18 years old, the system automatically requires the upload of a parental consent form\. Once all mandatory fields are completed and validated, the volunteer may proceed with the submission of their application\.

For the Inquiry Submission subfunction, youth volunteers may raise questions or request clarifications regarding a project through the built\-in inquiry modal located under the *Inquiries* tab within the project’s *View Details and Application* section\. Upon confirmation, the system records the inquiry, forwards it to the designated project head, and triggers a real\-time dashboard notification to ensure prompt visibility and response by the responsible SK Official\.

Lastly, under the Inquiry Reply Participation subfunction, youth volunteers are allowed to post follow\-up questions or replies within the same inquiry thread, particularly in response to answers provided by SK Officials\. This threaded communication mechanism supports continuous and transparent discussion between volunteers and project administrators\. All inquiry messages and replies are stored by the system and associated with the corresponding project and project head\.

Upon completion of these processes, the system’s postconditions include the successful recording and storage of the youth volunteer’s application data, inquiry details, and related personal information in the system database for reference, monitoring, and further processing\.

**

#### <a id="_vh4psb38qmej"></a>*Figure R\-5\.4\.1: Monitoring Project \(Youth Volunteer side\) Activity diagram*

### <a id="_4qwn9ndb6axb"></a>__         2\.3\.3 File Management__

The file management system includes important preconditions to ensure smooth and secure operation: SK Barangay Officials must be logged into the system and have the necessary permissions to upload and delete\. Files must be within the allowed size limit of 10MB, and at least one file must be available in the repository for viewing\. The file repository and database must be active and accessible, with sufficient storage space for new uploads\. When uploading, the file must exist locally on the SK Official’s device\. These preconditions help maintain system integrity and ensure that file operations are performed reliably and securely according to user roles\.

The subfunctions of the file management feature are organized into distinct, user\-friendly sequences to ensure smooth operation\. When viewing files, users simply select a file in the repository to open and view its contents\. When searching, users click the search bar and enter keywords; if matches are found, all relevant files are displayed\. Otherwise, a “No file found” message prompts users to try new keywords\.

Moreover, in the privileged side of the system, uploading involves choosing a file and then submitting it\. Otherwise, if the file size exceeds 10MB, users receive a prompt "File too large" and must select a different file that is only within the bounds of the given file size of 10MB\. Archiving a file requires selecting a file and confirming the deletion through a prompt, "Do you want to delete?”, ensuring accidental deletions are avoided\. Providing intuitive workflows while enforcing necessary validations for file size and user confirmation\.

Post\-conditions ensure that files are uploaded securely and linked to their respective folders or projects\. Metadata such as file name, upload date, and uploader information is updated accordingly\. The repository automatically refreshes to display the latest files, search indexing updates to reflect new or deleted files, and all actions are recorded in audit logs to maintain accountability and traceability\. These post\-conditions collectively uphold system integrity and align file management capabilities with user roles and security requirements\.

____

#### <a id="_u6jji5xd71jy"></a>__ __*Figure R\-5\.2\.1: Manage Files \(SK Official side\) Activity diagram*

As for the preconditions of the Youth Volunteers, it is essential that preconditions such as the type of user account \(including viewing and searching permissions\) are established in order to ensure proper accountability and authorization for those who manage the file system repository\. The subfunctions of the youth volunteers are similar to the barangay officials; however, it is only limited to viewing, searching, and filtering files within the repository\. Post conditions of the youth volunteer’s file management must ensure the system will render files and also search results\.

**

#### <a id="_e4uchy5nnjk0"></a>*Figure R\-5\.2\.2: Manage Files \(Youth Volunteer side\) Activity diagram*

### <a id="_oitfq0nemg9r"></a>__       2\.3\.4 Manage Content__

The Manage Content function enables SK Officials to create, edit, and delete announcements to ensure timely and accurate dissemination of information within the system\. The preconditions for this function include: the SK Official must be authenticated and logged in with administrative privileges, the system database must be operational, and relevant announcement records must exist in the system for modification or deletion actions\.

SK Officials may create announcements by providing a title, category, description, and an optional image\. Upon submission, the system validates all required inputs and stores the announcement in the database, making it immediately visible to all authorized users\. Editing an announcement is performed by selecting the edit action, which opens an edit modal pre\-filled with the existing announcement details, allowing SK Officials to update the information as needed\.

For deletion, SK Officials may select the delete action on an announcement\. The system then displays a confirmation prompt to prevent accidental removal\. Once confirmed, the announcement is permanently removed from the database, and a system pop\-up notification is displayed to confirm the successful deletion of the content\.

Within the SK Official Dashboard, users are provided with full transparency through access to budget reports, historical records, and editable project\-related information\. The dashboard also presents an overview of project performance metrics based on a five\-factor evaluation system, where the overall project success rate is computed using the following weighted criteria:

- Budget Efficiency \(25%\)
- Volunteer Participation \(20%\)
- Community Impact \(20%\)
- Timeline Adherence \(20%\)
- Volunteer Feedback \(15%\)  


Meanwhile, in the Youth Volunteer Dashboard, volunteers are allowed to submit post\-event feedback by rating their experience on a scale of one \(1\) to five \(5\) and providing written testimonials related to the completed project\. Upon successful submission of the testimonial and feedback, the system generates and awards a Certificate of Participation to the youth volunteer\.

The postconditions of the Manage Content function include the accurate reflection of all created, edited, or deleted announcements in the system database\. Additionally, all content\-related actions are recorded in the system audit log with corresponding timestamps to support traceability and accountability\.



#### <a id="_9pkp69vmd3jv"></a>*Figure R\-5\.3\.1: Manage Content \(SK Official side\) Activity diagram*

From the perspective of __Youth Volunteers__, the __Manage Content__ function allows them to view announcements published by SK Officials\. The preconditions for this function include: the youth volunteer must be authenticated and logged into the system, and the system database connection must be active\.

Upon successful login, youth volunteers are automatically redirected to the main dashboard page, where all published announcements are displayed\. From this interface, they can scroll through and browse the complete list of announcements, as well as view approved youth volunteer testimonials associated with completed projects\. The content is presented in a read\-only format, ensuring that youth volunteers can access information without modifying it\.

Both SK Officials and Youth Volunteers have visibility over published announcements; however, only SK Officials are granted content management privileges\. The postconditions of this function ensure that all announcements and testimonials remain visible, accurate, and up\-to\-date for youth volunteers\. Additionally, system access and content retrieval activities are properly logged to maintain system reliability and support usage monitoring\.

**

#### <a id="_hpvjgwjplycj"></a>*Figure R\-5\.3\.2: Manage Content \(Youth Volunteer side\) Activity diagram*

### <a id="_9rrnuoxpz1e5"></a>__2\.4 Operating Environment__

__Module__

__Functional Requirement__

Login

The system provides two\-factor authentication before granting access to system functionalities\.

The system verifies that user credentials match stored records before granting access\.

The system allows users to recover and reset their passwords\.

The system allows new user registration and verifies accounts through email verification\.

File Management

The system allows both SK Officials and Youth Volunteers to view uploaded files\.

The system enables SK Officials to upload files to the repository\.

The system allows both user roles to search for files within the database\.

The system allows both user roles to filter files based on category\.

The system allows SK Officials to delete files from the system\.

Content Management

The system enables SK Officials to create, edit, and delete announcements\.

The system allows both SK Officials and Youth Volunteers to view announcements\.

Project Monitoring

The Barangay Captain is authorized to approve, reject, or evaluate project submissions\.

The system allows SK Officials to create new project proposals\.

The system provides SK Officials with the ability to view, modify, and archive projects\.

The system enables Youth Volunteers to submit inquiries regarding projects, and allows both user roles to reply to inquiry threads\.

The system enables both user roles to search and filter projects\.

The system allows Youth Volunteers to register for upcoming projects\.

The system allows project heads to approve, reject, or set volunteer applications to pending status\.

#### <a id="_27uu3h50yivu"></a>__*Table R\-1:*__* Functional Requirements*

Reliability

The system stores all data in a secure and persistent database\.

Maintainability

The system allows authorized users to create and update data without requiring technical knowledge\.

The system codebase is organized to simplify debugging, updates, and long\-term maintenance\.

Efficiency

The system responds promptly to user actions such as file searches or project updates\.

The system supports multiple concurrent users without significant performance degradation\.

Security

The system enforces strong password policies and secure authentication mechanisms\.

The system protects user data and prevents unauthorized access to sensitive information\.

Usability

The system provides an intuitive and easy\-to\-navigate user interface\.\.

The system delivers clear feedback, including error messages and confirmation notifications\.

The system supports responsive design across various screen sizes and devices\.

The system implements input validation to prevent invalid or inconsistent user input\.

#### <a id="_ol9owh8hwe9c"></a>__Table R\-2: __Non\-Functional Requirements

### <a id="_q8llbrdlxtri"></a>	__2\.5 Design and Implementation Constraints__

This section details the limitations, risks, dependencies, and assumptions that will influence the design, development, and implementation of the Barangay Information Management System \(BIMS\)\. These factors are crucial for project planning and resource management, as they define the project's boundaries and potential challenges\.

### <a id="_pu7bp9i2r7ip"></a>		__2\.5\.1 Risk Assessment__

In the system design, development, and implementation, it is imperative to recognize and mitigate potential risks\. The design phase is one of the most crucial phases in Software Engineering 1 \(SE1\), as data is gathered here, and it is up to the developer's interpretation on how they will mitigate the problem the client is facing\. Hence, one of the risks associated with this design phase is the potential for misunderstanding the client’s interests and the possible discrepancies that may arise from the developers' implementation, as well as the risk of compromising the proposed design principles\.

A systematic and orderly approach to the system development process is needed, as this is the technical execution of the proposed project\. The team must remain attentive to the system requirements to ensure it meets the expectations of the client and avoid rewriting the code\. Furthermore, changing clients in between the development phase can be a serious risk, requiring flexibility and efficient change management to prevent scope creep\.

Lastly, unforeseen errors or bugs can appear in the implementation phase\. It can be disruptive and need immediate attention to maintain system functionality and client satisfaction\. Additionally, the need for training of the SK officials as well as the youth volunteers as they change terms every three \(3\) years is posed as one of the risks that is within the BIMs\. Their adoption to the system can be a potential risk as it may be a learning curve for some of them\. 

A primary risk for the Barangay Information Management System \(BIMS\) project is user adoption\. Both SK Officials and Youth Volunteers are accustomed to informal and manual processes \(like file sharing via Messenger\)\. There is a significant risk that users may resist the new system if it is perceived as too complex or if training is insufficient, leading to low engagement and a failure to solve the core problem of scattered data and files\.

Security and data privacy represent a risk\. The system will store public SK documents and personal information from youth volunteers who register\. Any unauthorized access, data breach, or accidental deletion of records by an admin could have serious consequences\. Mitigation strategies, such as secure authentication and imposing audit trails, are essential to address this risk\.

The project is also subject to technical and environmental risks\. The system’s reliance on a stable internet connection is a key vulnerability\. Intermittent or poor connectivity for either the SK officials in the barangay hall or the volunteers at home could render the system unusable, leading to frustration and a return to old methods\. Furthermore, as a web\-based portal, the system is at risk from common web vulnerabilities if not developed following security best practices\.

### <a id="_lhn07qq2x29q"></a>		__2\.5\.2 Assumptions and Dependencies__

A key assumption for the BIMS project is that SK Officials and Youth Volunteers will actively use the system as intended\. The project relies on officials consistently uploading and organizing files in a centralized repository\. Volunteers are expected to check the platform for upcoming projects, sign up for activities, and communicate through the system’s inquiry feature\. Without their engagement, the system may fail to improve file organization, increase youth participation, or streamline project communication, limiting its intended impact\.

The system also assumes that the barangay will provide the necessary infrastructure and support\. This includes access to computers, stable internet connectivity, and a secure environment for system operation\. It further assumes that technical personnel will be available to maintain the platform, manage backups, and address any issues promptly\. Without reliable infrastructure and support, users may experience delays, data inconsistencies, or reduced accessibility, which could hinder the system’s adoption\.

This project depends on structured and accurate data entry, as well as adherence to security and privacy protocols in compliance with the Data Privacy Act of 2012\. Each project requires clear records, designated points of contact, and timely updates so that volunteers can interact with dynamic, real\-time information\. The system assumes that officials and volunteers will follow guidelines for consistent naming conventions, project documentation, and communication to ensure data reliability, accessibility, and smooth operation across the BIMS platform\.

### <a id="_i73j09s7tufe"></a>	__2\.6 User Documentation__

The group had already anticipated the diverse technical skills that the officials and youth volunteers might possess\. That is why, with the software development team planning practical user training and extensive documentation, this will not only facilitate smooth adoption but also confirm correct usage and the successful long\-term operation of the BIMS\. A detailed guide aids in lessening errors, while enhancing user confidence and performance, and ensures proper installation, configuration, and operation of the system\.

### <a id="_dsln9xfm9ffc"></a>__2\.6\.1 Need for User Experience__

- __Varying Technical Proficiency:__ SK officials and youth volunteers have different levels of technological familiarity; therefore, the system must offer an intuitive and user\-friendly interface that supports ease of use without requiring extensive technical knowledge\.
- __System Usability:__ Because the system handles critical tasks—such as file organization, project tracking, and volunteer monitoring—it must be designed with clear navigation, simplified workflows, and accessible tools that guide users through each process efficiently\.
- __Data Accuracy:__ A well\-designed interface reduces user errors by providing structured input forms, validation prompts, and clear feedback, helping maintain the integrity of official barangay records\.
- __Long\-Term Sustainability:__ Instead of relying heavily on documentation, the system should incorporate self\-explanatory features, embedded instructions, and contextual cues that allow future SK officials and volunteers to adapt quickly\.
- __Smooth Onboarding:__ Given the three\-year SK term cycle and the continuous onboarding of new volunteers, the system must be easy to learn and operate\. A human\-centered design ensures that new users can navigate the platform with minimal support\.

### <a id="_i268q7iffs0q"></a>__2\.6\.2 Documentation Plan__

The plan of action includes user and installation manuals, training sessions, and additional references specifically: 

1. __User Manual __

For SK Officials:

- 
	- 
		- System login and navigation procedures
		- File Management
		- Content Management
		- Project Monitoring
		- Volunteer assignment and tracking
		- Security and access control features
		- User account management procedures
		- System maintenance and monitoring
		- Security settings and system updates

For Youth Volunteers:

- 
	- 
		- Volunteer sign\-up procedures
		- Viewing and filtering of available projects
		- Using communication features

1. __Barangay Information System Manual__
	- System requirements 
	- Access procedures 
	- Access Database Training
2. __Quick Reference Guide__
	- One\-page quick\-start guides for frequently performed tasks

### <a id="_4dc0rwxjey7h"></a>__2\.6\.3 Implementation Strategy__

The documentation will be developed in parallel with system development\. The content is written in English and will include practical examples relevant to barangay operations, organized by user role and task frequency for easy navigation\.

__Training Implementation__

Phase 1: SK Officials Training \(2 to 3 sessions\)

- 
	- Session 1: System overview and basic navigation \(1\.5 hours\)
	- Session 2: Navigation of the 4 project monitoring functions \(2\.5 hours\)
	- Session 3: Advanced features \(2 hours\)

Phase 2: Youth Volunteers Orientation \(1 session\)

- 
	- System introduction and volunteer walkthrough
	- Registration and project browsing demonstration
	- Q&A session for clarifications

Phase 3: Support

- 
	- Monthly check\-ins during the first 3 months of deployment
	- Designated developer contact person
	- Refresher training as needed

Distribution Method

- 
	- Digital PDF versions are accessible with the system
	- Online repositories, such as Google Drive, for convenient and immediate access

__Expected Outcomes__

Short\-term \(0 to 3 months\)

- 
	- 80% of SK officials can independently perform basic system operations
	- 80% of the youth volunteers can successfully register for projects
	- Reduced dependence on developers

Medium\-term \(3 to 6 months\)

- 
	- Complete sufficiency in daily system operations
	- Zero critical errors attributed to user mistakes
	- Successful onboarding of new volunteers without the developers' help

Long\-term \(6\+ months\)

- 
	- Smooth transition of newly elected officials
	- Sustained system adoption and consistent usage
	- New members still use the documentation
	- Still an essential tool for barangay youth operations

This documentation and training approach ensures that BIMs will remain sustainable, efficient, and user\-friendly for Barangay Malanday’s SK operations long after the project’s or term’s completion\. 

## <a id="_gh4gipx7nw8n"></a>__External Interface Requirements__

This section details the external interface requirements for the BIMS system, specifying the ways the software interacts with users, hardware, other software, and external services\. The description is informed by project diagrams, use case/workflow definitions, and current architectural practices\.  


### <a id="_wg8zeylgs7ez"></a>__3\.1 User Interfaces__

The system provides a web\-based interface accessible through standard browsers on desktop and mobile devices with a responsive design that adapts to different screen sizes\. Users interact through intuitive dashboards, data entry forms, and organized navigation menus\. The interface implements role\-based customization, displaying features and controls appropriate to each user's permission level such as administrator, staff, or youth volunteer\. Furthermore, Authentication is performed through a login screen with email\-based two\-factor verification using one\-time password codes\. The system provides immediate visual feedback through color\-coded messages indicating successful operations, errors, or required actions\. Navigation is facilitated through clearly labeled menus, recognizable icons, and logical organization of common tasks including document management, record entry, and report generation\. All interface elements maintain consistent styling and behavior to ensure ease of use for users with varying technical proficiency levels\.

### <a id="_pxoetkkjhyou"></a>__3\.2 Hardware Interfaces__

The system requires no specialized hardware equipment for operation\. Users may access the application through standard computing devices including desktop computers, laptops, tablets, or smartphones with internet connectivity and a modern web browser\. The system interfaces with standard input devices such as keyboards, mice, and touchscreens for data entry and navigation\. For document management functionality, the system accesses local device storage to facilitate file uploads including PDF documents, images, and spreadsheets\. No additional peripheral devices such as scanners, card readers, or biometric equipment are required\. A stable internet connection with minimum bandwidth of 10 Mbps is recommended for optimal system performance\.  


### <a id="_v6fv9n28irll"></a>__3\.3 Software Interfaces__

The Barangay Information Management System interfaces with a minimal set of external software systems to maintain simplicity and reduce dependencies\. The primary software interface is the MySQL relational database management system, which the application communicates with via TCP/IP protocol using standard SQL queries for storing and retrieving barangay records, user data, project information, and document metadata\. 

The system is compatible with modern, up\-to\-date web browsers including Google Chrome, Mozilla Firefox, Microsoft Edge, and Safari, communicating via standard HTTP/HTTPS protocols to render the web\-based user interface and handle client\-server interactions\. Users should ensure their browsers are updated to the latest version for optimal security and performance\.

For email functionality, the system utilizes PHPMailer library to interface with SMTP mail servers, enabling the sending of two\-factor authentication codes \(OTP\) through secure SMTP/TLS protocol\. These interfaces represent the complete set of external software dependencies required for system operation, ensuring a self\-contained architecture with minimal third\-party dependencies and reduced complexity for maintenance and support\.

### <a id="_u1tc5t2lgdth"></a>__3\.4 Communication Interfaces__

The Barangay Information Management System uses secure internet communication protocols to protect data during transmission\. All communication between user devices and the server is encrypted using HTTPS \(secure web protocol\), ensuring that barangay records, documents, and personal information remain confidential and protected from unauthorized access\. User login sessions are managed through secure tokens that verify identity and maintain access control throughout the session\. The system operates on standard internet protocols that are compatible with any regular internet connection, requiring no special networking equipment or configuration\. All file uploads, downloads, and data transfers occur through the same encrypted connection, maintaining security for all barangay documents and records\. The system is accessible to authorized personnel from any location with internet access, whether inside the barangay office or remotely, using standard web browsers on computers, laptops, or mobile devices\.

## <a id="_hfpvr724nn0j"></a>__System Features__

The functional requirements of the BIMS define the core capabilities of the website based portal system to deliver and meet the requirement of its users, primarily the SK officials and the youth volunteers, These requirements describe the specific features and behaviors of the portal, outlining how the users will interact with the system to perform essential functions such logging in, monitoring projects, managing files, and managing content\. Each function is designed for the problems encountered in the daily operations of the SK official, fostering youth engagement and streamlining administrative workflows\.

### <a id="_kb1pl9vnq6fx"></a>__4\.1 Login and User Authentication__

The Login and User Authentication function ensures secure access to the portal for youth volunteers and SK officials\. It provides mechanisms for account registration, password recovery, all enforced with two\-factor authentication to maintain system integrity and protect sensitive data\. This also covers account turnover during leadership changes

### <a id="_wlnhzxdd0ve"></a>__4\.1\.1 Sub\-functions__

Regular users may register for an account by providing their email address, password, first name, last name, middle name, and agreeing to terms and conditions\. During registration, OTP verification is mandatory to confirm that the email address is valid and active\. Once registered, users are automatically assigned the youth volunteer role, which grants standard permissions such as viewing, searching, and limited registration features\.

  
	Users who forget their passwords cannot access their accounts until they complete the password recovery process\. This process requires OTP verification to ensure that the request is legitimate and that the email address remains active\. Only after successful verification can users reset their password and regain access\.

  
	During deployment, ten SK official accounts are created with privileged roles\. These officials have the authority to reset default passwords but cannot assign or change roles for regular users\. In cases of leadership turnover, the SK chairman has the authority to create a new set of SK official accounts\. Previous SK official accounts are then set to “archive” status, ensuring that their associated data remains in the database for accountability and historical recordkeeping\.  


### <a id="_qtlju6r8sovy"></a>__4\.1\.2 Non\-Functional Requirements__

Passwords must be encrypted using a secure hashing algorithm\. Two\-factor authentication is mandatory, and the system must log both successful and unsuccessful login attempts\. A maximum of five failed login attempts is allowed before access is temporarily restricted\.

The system must reliably authenticate users and handle concurrent login requests without performance degradation\.

Clear error messages should be displayed when credentials are incorrect\. Input validation must be enforced for usernames, email addresses, and passwords to prevent invalid or malicious entries\.  


### <a id="_w1u0og3jh9ag"></a>__4\.2\. Monitor Project __

The Project Monitoring function serves as a core component of the Barangay Information Management System \(BIMS\)\. It enables SK Officials to create, coordinate, and monitor community projects while facilitating youth volunteer participation and engagement\. This function promotes transparency and streamlines communication between SK Officials and Youth Volunteers throughout the entire project lifecycle, from project creation and volunteer recruitment to implementation, inquiry handling, and monitoring\.6\+

  
__4\.2\.1 Sub\-functions__

SK Officials can create new projects by providing the required project details, including project title, category, start date and time, end date and time, location, assigned project heads, and a detailed project description\. An optional banner image may also be uploaded, subject to a maximum file size of 5 MB\. SK Officials are permitted to edit existing projects to update relevant information, delete projects that are no longer applicable, and respond to inquiries submitted by youth volunteers\. Additionally, SK Officials may utilize built\-in search and filter tools to locate and manage specific projects efficiently\.

Youth Volunteers can browse and view approved projects, including information such as project category, status, duration, location, project heads, and descriptions\. Volunteers may register for projects by completing an integrated registration form that collects their personal details\. Upon successful submission, the system provides a confirmation notification\. Youth Volunteers may also submit inquiries related to projects, which are automatically forwarded to the designated project head\. The system notifies volunteers once a response has been posted\.

Both SK Officials and Youth Volunteers can view published projects and utilize search and filtering functionalities to easily locate projects based on predefined criteria\.

### <a id="_3kho04m2rlsn"></a>__4\.2\.2 Non\-Functional Requirements__

The system shall load project listings promptly under normal network conditions\. Project creation, editing, and deletion operations must be executed efficiently to support smooth administrative workflows\.

All project data, volunteer registration records, and inquiry submissions must be securely stored in the system database\. The system shall preserve data integrity and prevent data loss during concurrent access or unexpected system failures\.

The project monitoring interface must be intuitive and accessible to users with varying levels of technical proficiency\. Clear labels, prompts, and confirmation dialogs shall guide users through each action\. Error messages must be descriptive and actionable, enabling users to resolve issues independently and enhancing overall usability\.

### <a id="_23580rs7rjb"></a>__4\.3 File Management__

The __File Management__ function serves as one of the core functionalities of the Barangay Information Management System \(BIMS\)\. It enables SK Officials to maintain, organize, and manage the system’s centralized file repository while providing controlled and read\-only access to Youth Volunteers\. SK Officials are granted full permissions to upload, archive, and delete files, while Youth Volunteers are allowed to view, search, and filter essential documents such as fiscal year budgets, official reports, and itemized purchase listings\.

__4\.3\.1 Sub functions__

The subfunctions of the File Management feature include file uploading, file archiving, and file deletion, all of which are responsibilities assigned exclusively to SK Officials to ensure that the repository remains accurate, updated, and well\-organized\. SK Officials may categorize files appropriately to improve accessibility and maintain proper document structure\.

Both SK Officials and Youth Volunteers are permitted to view, search, and filter files stored in the system based on predefined criteria such as category or file type\. These shared access functions provide transparency while enforcing role\-based restrictions, ensuring that Youth Volunteers can retrieve necessary information without modifying or compromising stored documents\.

### <a id="_stkhm4edwab5"></a>__4\.3\.2 Non\-Functional Requirements__

The File Management function must maintain high levels of performance and reliability\. File uploads are restricted to a maximum size of 10 MB to prevent system slowdowns and minimize excessive storage consumption\. All uploaded files must be stored in a secure file storage system, with corresponding metadata recorded in the system database to ensure confidentiality, integrity, and availability of documents\.

The system must reliably handle file access requests from multiple users and ensure that files remain accessible without data loss or corruption, even during concurrent operations or unexpected system interruptions\.

### <a id="_wqurlts5rah"></a>__4\.4\. Content Management__

The __Content Management__ function is one of the core functionalities of the Barangay Information Management System \(BIMS\)\. It enables SK Officials to create, edit, archive, and manage announcements to ensure that accurate, timely, and relevant information is disseminated to the community\. In contrast, Youth Volunteers are granted read\-only access, allowing them to view published announcements and stay informed about barangay activities and updates\.

__4\.4\.1 Sub functions__

The subfunctions of the Content Management feature include announcement creation, announcement editing, announcement archiving, and announcement viewing\. SK Officials are authorized to perform all four subfunctions, giving them full control over the announcement lifecycle\. Youth Volunteers are limited to viewing announcements, ensuring information access without modification privileges\.

Announcement creation allows SK Officials to publish new content, while editing enables updates or corrections to existing announcements\. Archiving is used to remove outdated or irrelevant announcements from active display while retaining them in the system for historical reference\. Viewing announcements is accessible to both SK Officials and Youth Volunteers through their respective dashboards\.

__4\.4\.2 Non\-Functional Requirements__

The Content Management function must satisfy several non\-functional requirements to ensure performance, maintainability, and usability\. From a performance perspective, announcements must load consistently and without noticeable delay to provide timely information to users\. In terms of maintainability, the system shall allow SK Officials to easily create, edit, and archive announcements without requiring technical expertise, ensuring that content remains current and accurate\.

For usability, the announcement interface must support responsive design and adapt seamlessly across multiple devices, including desktop computers, mobile phones, and tablets\. Content must be displayed in a structured, readable, and visually organized layout\. Collectively, these requirements ensure that the announcement feature remains efficient, accessible, and user\-friendly across all supported platforms\.

### <a id="_d6ghb2s0kkzm"></a>__Business Rules__

The Barangay Information Management System \(BIMS\) for Barangay Malanday operates in accordance with the organizational structure of the Sangguniang Kabataan \(SK\), the provisions of the Sangguniang Kabataan Reform Act of 2015 \(Republic Act No\. 10742\), and established barangay administrative protocols\. Within this framework, the system’s business rules govern the management, review, and approval of youth volunteer–related activities\. These rules ensure that all volunteer engagements adhere to the mandated SK workflow, reflect the legally defined roles and responsibilities of SK officials, and uphold transparency, accountability, and compliance with youth governance standards\.

__System Users and Roles__

#### <a id="_d3c10h58an1r"></a>__Primary Users__

__SK Chairman__

- Granted full system access
- Serves as the primary authority for project approval
- Holds final decision\-making authority on volunteer assignments

__SK Kagawad__

- Authorized to create and manage projects within their respective committees
- Responsible for volunteer coordination and supervision
- Permitted to manage and upload files relevant to assigned projects  


__SK Secretary__

- Responsible for document management and administrative support within the system
- Assists in system administration tasks
	- 
		- 
			- Authorized to approve projects and provide final approval for volunteer assignments in cases where the SK Chairman is unavailable

#### <a id="_yrlvvrucr8h3"></a>__Secondary Users__

__Youth Volunteers__

- Allowed to view available and approved projects
- Authorized to register for upcoming projects
- Permitted to submit inquiries regarding projects and post replies within inquiry threads

#### <a id="_d4f09vmwlwdu"></a>__System Administrators__

__Designated SK Member__

- Responsible for user account management
- Oversees system maintenance and configuration
- Performs database backup operations
- Provides technical support to system users

__User Interactions and Permissions __

### <a id="_ri2ede6cyko3"></a>__Barangay Captain__

- Access the Barangay Captain dashboard for project oversight
- Review and evaluate project proposals submitted by SK Officials
- Approve, reject, or request revisions for project submissions
- Provide final approval for projects and volunteer engagement activities
- View consolidated project statistics, budget summaries, and success metrics
- Receive system notifications related to project submissions and approvals
- Cannot create or modify project details directly
- Cannot manage volunteer applications at the operational level

### <a id="_qunkt7se8107"></a>__SK Officials__

- Create, read, update, and delete project records and related content
- Upload, organize, archive, and delete official public documents and files
- Review, approve, reject, or set volunteer applications to pending status
- Manage volunteer assignments and track volunteer participation status
- Respond to project inquiries submitted by Youth Volunteers
- Access all operational system features except final project approval

### <a id="_rupintcmumm0"></a>

### <a id="_2kta2qc7svcb"></a>__Youth Volunteers__

- 
	- 
		- Browse available and approved projects with read\-only access
		- Submit volunteer applications for upcoming projects
		- Submit inquiries related to specific projects and reply within inquiry threads
		- View announcements, public files, and project schedules
		- Cannot access administrative features or dashboards
		- Cannot view or modify other volunteers’ personal information

__Workflow Dependencies__

- Within the __Sangguniang Kabataan \(SK\) Council__, the workflow of the Barangay Information Management System \(BIMS\) follows a defined and sequential dependency to ensure proper governance, approval, and execution of projects\. Each phase must be completed before the next process can proceed\.

__Project Creation__ → __Approval by the SK Chairperson of Barangay Malanday, Marikina__ → __Volunteer Recruitment__ → __Project Implementation__ → __Project Completion and Reporting__

__Dependencies with other Barangay Offices__

Barangay Captain’s Office

- 
	- Dependency Type: Reporting
	- Interaction: SK projects requiring barangay\-wide coordination or budget approval must be endorsed through this office
	- Data Flow: Reports may be shared for transparency and governance purposes 

Barangay Secretary’s Office

- 
	- Dependency Type: Document archiving and official records
	- Interaction: Official SK documents and resolutions created in BIMs may need to be filed with the barangay secretary for formal record\-keeping 
	- Data Flow: Export functionality for official documents in standard formats

Barangay Treasurer’s Office

- 
	- Dependency Type: Budget and financial tracking
	- Interaction: Project budgets and financial reports may be coordinated with the treasurer for fund disbursement
	- Data Flow: Financial summaries and budget requests exported from BIMs

Department of the Interior and Local Government \(DILG\)

- 
	- Dependency Type: Compliance and reporting  
	- Interaction: SK council must submit periodic reports to DILG regarding youth activities and programs being implemented
	- Data Flow: System\-generated reports exported for DILG submission

__Workflow Dependencies__

- With the main barangay office
	- Major project proposal —> Barangay Captain endorsement —> Budget approval —> Implementation

## <a id="_la8vd1s0co5h"></a>__Appendices__

### <a id="_2m5t0kl2tyn0"></a>__6\.1 Initial  Interview Transcripts__

Date: September 21, 2025

Participants:

Andrea Pelias \(Interviewer\)

Jerome Ancheta \(Interviewer\)

Cielo Villaroman \(SK Malanday Representative\)

__\(0:03 – 0:26\)__

Andrea Pelias: Good evening\. Before we begin, we'd like to explain the purpose of this interview\. We are conducting a study to understand the organizational challenges of the Sangguniang Kabataan \(SK\) in Barangay Malanday, Marikina; especially regarding information management, project monitoring, communication, and sustainability\.

__\(0:26 – 0:58\)__

Andrea Pelias: Your answers will help us design a feasible digital system solution that fits your actual needs\. Permission to record, Ma’am Cielo?

Cielo Villaroman: Sure\. Okay\.

Andrea Pelias: For the first question, can you describe your organization and explain its main purpose?

Cielo Villaroman: Good evening, everyone\. I am Cielo, one of the SK officials of Malanday\.

__\(0:59 – 2:28\)__

Cielo Villaroman: The SK is the youth arm of the barangay\. Our main purpose is to represent the voice of the youth aged 18 to 30 and create programs that benefit them; whether in education, sports, livelihood, or health\.

Andrea Pelias: What are the long\-term goals of your SK Council? What are your mission and vision?

Cielo Villaroman: Our long\-term goal is to build sustainable projects that will outlast our term; scholarships, training programs, and more\. Barangay Malanday is the biggest in the city, so we focus on long\-term projects for a large youth population\.

Our mission is to empower the youth and give them opportunities\. Our vision is to see a more active, skilled, and united youth community\.

__\(2:33 – 3:29\)__

Andrea Pelias: Regarding your projects, what have you launched in the past? Which were the most successful?

Cielo Villaroman: We’ve launched sports tournaments \(badminton, volleyball, basketball, chess, ML\), free printing services \(scanning, photocopy, free ID pictures\), and the Hatid\-Sundo Program for graduates studying at Pamantasan ng Lungsod ng Marikina who graduate at PICC\. We provide free round\-trip transportation for graduates and parents\.

__\(3:29 – 4:24\)__

Cielo Villaroman: We also give free school supplies for elementary and high school students, and scholarship programs\.

The most successful project is the basketball league, as Malanday youth are very active and engaged in basketball\.

__\(4:28 – 5:29\)__

Andrea Pelias: How did you plan and execute these projects? What tools or systems did you use?

Cielo Villaroman: We conduct monthly council sessions for planning; identifying needs and target beneficiaries\. We use social media, group chats, trackers, and manual reports\.

Andrea Pelias: Were there challenges in monitoring project progress; like budget tracking, attendance, or beneficiary records?

Cielo Villaroman: Yes, especially because not all youth have devices or Wi\-Fi\. Sometimes we do house\-to\-house or contact area leaders\.

__\(6:08 – 6:55\)__

Andrea Pelias: How often do you launch projects?

Cielo Villaroman: We target nine SDGs\. Each month we have assigned projects\. Big events like the sports fest span months \(e\.g\., September–December\)\. Monthly and quarterly projects are recorded in our schedule\.

__\(6:57 – 7:29\)__

Andrea Pelias: Regarding information and data management, what kinds of information do you handle?

Cielo Villaroman: Member lists, participants, finances, project reports\. I usually prepare the reports and pass them to DILG for approval\.

__\(7:30 – 9:07\)__

Cielo Villaroman: Our data is mostly stored in paper files and Excel, but I often use Google Docs\.

Andrea Pelias: What challenges do you face in record\-keeping and data retrieval?

Cielo Villaroman: My Google storage is full and I don’t have a shared account, so updating old files is hard\. I make copies as backups\.

For communication, we coordinate first within the council, then with youth volunteers\. We use meetings, group chats, and Facebook since youths are very active there\.

__\(9:11 – 10:50\)__

Andrea Pelias: Do you also promote your projects on Facebook?

Cielo Villaroman: Yes, only on Facebook because it reaches the most youth\.

Andrea Pelias: Do you have enough resources like PC, Wi\-Fi, or software?

Cielo Villaroman: Yes, we have a computer, Wi\-Fi, and basic software, but the budget is always limited\. That affects our capacity to execute bigger projects\. We also rely on volunteers and leaders to relay information\.

__\(10:53 – 11:24\)__

Andrea Pelias: What is your process for turnover when a new SK is elected?

Cielo Villaroman: Usually the SK Chairperson and Treasurer lead the turnover\. Past officials may also join\. We conduct a formal turnover of records and documents\.

__\(11:24 – 12:17\)__

Cielo Villaroman: All records for the term are stored and checked by DILG and CT\. However, sometimes files are incomplete due to misplacement or poor documentation, making it harder for the next council\. Completing BILG requirements is necessary for turnover\.

__\(12:19 – 12:36\)__

Andrea Pelias: Is there someone in your team who handles tech\-related tasks?

Cielo Villaroman: Yes, one or two members, but our process is not systematic\.

__\(12:40 – 14:05\)__

Andrea Pelias: Who has access to your data and how is it controlled?

Cielo Villaroman: Everyone has access, but mainly me and our chairperson\.

Andrea Pelias: How do you secure your records?

Cielo Villaroman: We keep physical folders and store them in a cabinet containing all received files from CT and DILG\.

Andrea Pelias: Have you experienced missing files or data loss?

Cielo Villaroman: Yes, especially with heavy paperwork\.

Andrea Pelias: Do you keep backups?

Cielo Villaroman: Yes\. Before submitting to offices, we prepare two copies: one for us and one for the receiving office\.

__\(14:48 – 15:32\)__

Andrea Pelias: If we were to create a digital solution, what format do you prefer; website or mobile app?

Cielo Villaroman: A simple website with Facebook integration would be best, since Facebook is widely used in our barangay\. We want multiple user levels and access to project updates and monthly reports\.

__\(15:32 – 17:31\)__

Cielo Villaroman: It depends on what you think is best for us\.

Andrea Pelias: What tasks would you want the system to automate?

Cielo Villaroman: Budgeting and project management\.

Jerome Ancheta: Do you use templates for documents?

Cielo Villaroman: Yes; minutes, attendance, monthly reports\. The template includes logos \(DILG, Bagong Pilipinas, SK, and barangay\)\.

__\(17:31 – 18:10\)__

Jerome Ancheta: Do you prefer different types of users?

Cielo Villaroman: Yes; SK admins with full access and youth users with limited access\.

__\(18:10 – 19:09\)__

Andrea Pelias: What features should be exclusive to admins vs\. youth users?

Cielo Villaroman: Youth users should be able to log in to see upcoming projects, past accomplishments, project budgets, and photos \(though updating photos may be labor\-intensive\)\.

__\(19:20 – 20:25\)__

Jerome Ancheta: From all the data we gathered, what is the biggest problem your organization faces?

Cielo Villaroman: Limited access and engagement\. Youth only see posts but not all have Wi\-Fi or phones, so they miss upcoming projects and accomplishments\.

__\(20:25 – 21:24\)__

Cielo Villaroman: They only join projects they happen to see\. Also, for the website design, our barangay color is green\. You may choose the theme, but green is our preference\.

__\(21:33 – 22:21\)__

Jerome Ancheta: For meetings, what aspects would you like simplified in a database system?

Cielo Villaroman: Meetings have many components; minutes, attendance, photo documentation, notice of meeting\. It’s a lot, especially since meetings occur monthly\.

__\(22:32 – 23:02\)__

Andrea Pelias: We can end the interview now\. Thank you very much, Ma’am Cielo, for attending\. We will get back to you once we conceptualize the website for Barangay Malanday\.

Cielo Villaroman: Thank you so much\.

Andrea Pelias: Thank you\.

### <a id="_ytx0cu7to6wh"></a>__6\.2 Second Interview __

Date: November 11, 2025

Participants:

Jerome Ancheta \(Interviewer\)

Cielo Villaroman \(SK Malanday Representative\)

	__\(0:01\-0:19\)__

Jerome Ancheta: Kunwari, ano? Meetings of the meeting\. Notice, attendance, documentation, RCD\.

Cielo Villaroman: RCD, yes\. I’ll send it\.

Jerome Ancheta: Ah, sige\. Tapos?

__\(0:20 – 0:32\)__

Jerome Ancheta: Pwede kayo mag\-upload online, parang cloud hosting\. Basically, you can upload files on the web\.

Cielo Villaroman: Ah, okay\.

Jerome Ancheta: But we will limit the file size\. Like other platforms, may upload limit\. Is 5MB acceptable instead of 10MB?

Cielo Villaroman: Oo, 5MB is okay\.

__\(0:56 – 1:18\)__

Jerome Ancheta: I sent a picture—this is what can be accessed online\. Scroll through it\.

Cielo Villaroman: Sige, accessing it now\. Kumusta yung SE nyo?

Jerome Ancheta: May ginagawa pa\.

Cielo Villaroman: Okay\.

__\(1:19 – 1:56\)__

Jerome Ancheta: Ano itong CBYDP?

Cielo Villaroman: Ayan yung mga pwede i\-access online\.

Jerome Ancheta: Can all users access it?

Cielo Villaroman: Yes, pwede\.

Jerome Ancheta: Sinend mo ito last time, tapos meron kang template?

Cielo Villaroman: Oo\.

Jerome Ancheta: Or pwede na lang kayong mag\-upload ng soft copy?

Cielo Villaroman: Yes, pwede\. Pag\-upload namin, madedownload nila\.

__\(2:09 – 2:49\)__

Jerome Ancheta: What is the Comprehensive Budget Development Program?

Cielo Villaroman: Buong project plan yan—kailangan ma\-accomplish\. May goals per year\.

Jerome Ancheta: And the Annual Barangay Youth Investment Program?

Cielo Villaroman: That’s our budget—how much is allotted per project\.

Jerome Ancheta: SK Workplan and Budget?

Cielo Villaroman: Same, but more detailed, with timelines\.

__\(3:00 – 3:22\)__

Cielo Villaroman: Yung RCB \(Registered Cash in Bank\), ayun yung pang\-finance—kung magkano pumapasok, ini\-withdraw, at dine\-deposit\.

Jerome Ancheta: Okay\.

__\(3:26 – 3:35\)__

Jerome Ancheta: Yung Itemized List of Purchase Requests?

Cielo Villaroman: Listahan yan ng materials na nabili namin, doon naka\-record\.

__\(3:36 – 3:39\)__

Jerome Ancheta: So pwede nyo i\-upload yung soft copy para makita ng kabataan?

Cielo Villaroman: Oo\.

Jerome Ancheta: Okay, yun lang\. Update na lang kita pag may dagdag pa ako\.

Cielo Villaroman: Thank you\.

Jerome Ancheta: Thank you sa time\.

### <a id="_3x1ztuy48269"></a>__6\.2 Google Form Interview__

____

#### <a id="_o9ezsgm5vaqm"></a>*6\.2\.1 Barangay Malanday \(SK Officials\) \- Scattered Files*

#### <a id="_vru4vscr29ex"></a>____*6\.2\.2 Barangay Malanday \(SK Officials\) \- Scattered Files*

**

#### <a id="_hxdtrlsnb6hj"></a>*6\.2\.2 Barangay Malanday \(SK Officials\) \- Scattered Files*

#### <a id="_kp88ah8ts8ee"></a>*6\.3\.1\. Barangay Malanday \(Youth Volunteers\) \- No Calendar*

**

#### <a id="_itd9t98eacmw"></a>*6\.3\.2\. Barangay Malanday \(Youth Volunteers\) \- No Calendar*

**

#### <a id="_ntbq4219djhd"></a>*6\.3\.2\. Barangay Malanday \(Youth Volunteers\) \- No Calendar*

**

#### <a id="_aqfwuzxm4sfn"></a>*6\.4\.1\. Follow\-up Interview: SK Officials & Youth Volunteers \- FAQ*



#### <a id="_rjg1l32r2ctn"></a>*6\.4\.2\. Follow\-up Interview: SK Officials & Youth Volunteers \- FAQ*



#### <a id="_yhxsoawk2485"></a>*6\.5\.1\. SK Officials \- Post don't convert to sign ups*

* 				6\.5\.2\. SK Officials \- Post don't convert to sign ups*

**

#### <a id="_unme34cg41id"></a>*6\.5\.3\. SK Officials \- Post don't convert to sign ups*

**

#### <a id="_3hmkr43wghm5"></a>*6\.5\.4\. SK Officials \- Post don't convert to sign ups*

**

#### <a id="_v6by0ig77sk8"></a>*6\.5\.5\. SK Officials \- Post don't convert to sign ups*

**

#### <a id="_svsieyp4mzji"></a>*6\.6\.1\. SK Officials \- Current Status Metrics*

**

#### <a id="_j11ihdgiuhto"></a>*6\.6\.2\. SK Officials \- Current Status Metrics*

<a id="_osxj27mcavcj"></a>Reference

Reference:  
  
System Requirements Specification Sheet

1\. Introduction

This documents the purpose and scope of the project

1\.1\. Project Purpose

Define why there is a need for the project\. A fishbone analysis may be helpful in identifying

project purpose\. Identify project’s beneficiaries and stakeholders\. Introduce the individuals

whom the group interviewed and a summary of the discussion\. Full client interview

transcripts must be included in the appendices\.

Figure R\-1: Fishbone diagram

1\.2\. Project Scope

Describe what the project can do\. Identify project goals and objectives, making sure they are

measurable and attainable based on project plan\. A Validation Board will help identify the

project’s scope and limitations\.

Figure R\-2: Javelin Board

2\. Overall description

This documents what the project can do and its requirements

2\.1\.Project perspective

Create a model of the system by identifying who are the system’s actors, what are its

primary functionalities and capabilities

Figure R\-3: Use case diagram

2\.2\.User accounts and characteristics

Identify the users of the system and their characteristics\. Describe how each one will

interact with the system\. Actor interaction must also be identified, if any\.

2\.3\.Project functions

Create a model of the system process flow from start to end, including decision trees and

generation of reports, if any\.

Figure R\-5: Activity diagram

2\.4\. Operating environment

List and describe the system’s functional requirements by identifying what the project is

capable of doing\. Non\-functional requirements are those which needed to validate the

project’s performance\. Non\-functional requirements may include system reliability,

maintainability, efficiency, security and usability\. Identifying non\-functional requirements

often entail the need for user acceptance tests \(UAT\) which would be later identified in the

System Test Plan \(STP\) document

Table R\-1: Functional requirements

Table R\-2: Non\-functional requirements

2\.5\.Design and implementation constraints

This documents the limitations, dependencies and possible consequences on the system’s

design, development and implementation

2\.5\.1\. Risk assessment

Describe risks involved during system design, development and implementation\.

2\.5\.2\. Assumptions and dependencies

Describe how the system may affect organization productivity and processes\.

Identify factors which may affect the organization upon use of the system\.

2\.6\.User documentation

Identify the need for user training and documentation such as user manuals and installation

manuals\. Describe how these will be implemented and what would be the expected

Outcomes\.

3\. External Interface Requirements

3\.1\.User interfaces

Describe how users will interact with your proposed system via the system’s UI\.

3\.2\.Hardware interfaces \(if any\)

Describe how users will interact with any hardware peripherals used in the proposed

system, if any\. Also include how the hardware peripheral will interact or connect with your

proposed system\.

Figure R\-6: System block diagram

3\.3\.Software interfaces \(if any\)

In case the organization already has an existing system and your proposed system will need

to be integrated to it, describe how the interaction or connection will occur\.

Figure R\-7: System integration diagram

3\.4\.Communication interfaces

Describe how the system will be implemented, if online, offline or stand\-alone\. In case the

system is online, what would be the requirements needed to access it\.

4\. System features

List down and explain each system requirement, focusing on system’s functional requirements\.

4\.1\.Requirement 1

4\.2\.Requirement 2

4\.3\.\.\.\.

5\. Business rules

Identify who will interact with the system and possible dependencies to and from other offices

in the organization\.

6\. Suggested Appendices

6\.1\.Interview transcripts

