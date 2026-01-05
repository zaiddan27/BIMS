# BIMS - Barangay Information Management System

A comprehensive web-based management system for Barangay Malanday's Sangguniang Kabataan (SK) operations.

## Features

### Main Dashboard (index.html)
- Hero section with background image and transparent overlay
- 2025 Budget Allocation display with **edit functionality**
- Project success metrics
- Featured projects carousel
- Volunteer testimonials slider

### Project Management
- **SK Project Management** (skproject.html) - Create and manage SK projects
- **Youth Project Management** (youthproject.html) - Youth-focused project tracking
- **Project Archive** (sk-archive.html) - View completed projects with multi-format export (PDF, CSV, TXT)

### Document Management
- **SK Files** (skfiles.html) - Document storage and organization
- **Youth Files** (youtfiles.html) - Youth-specific document management

### Calendar & Scheduling
- **SK Calendar** (skcalendar.html) - Event scheduling and management
- **Youth Calendar** (youthcal.html) - Youth event tracking

### Testimonials & Certificates
- **Testimonies** (sk-testimonies.html) - Volunteer feedback with delete functionality
- **Youth Certificates** (youth-certificates.html) - Generate and download participation certificates

### Dashboards
- **Main Dashboard** (index.html) - Overview and statistics
- **Captain Dashboard** (captain-dashboard.html) - SK Captain's control panel
- **Youth Dashboard** (youtbDashboard.html) - Youth volunteer interface
- **Admin Dashboard** (dashb.html) - Administrative controls

### Authentication
- **Login** (login.html) - User authentication
- **Sign Up** (signup.html) - New user registration

## Recent Updates

### Budget Management
- Added edit button to 2025 Budget Allocation section
- Modal interface for updating budget values
- Real-time calculation of total budget
- Automatic progress bar updates
- Input validation for budget amounts

### Archive Page
- Removed redundant filter checkboxes
- Added multi-format export options (PDF, CSV, Text)
- Text export with professional box-drawing character formatting

### Certificates
- Enhanced certificate design with decorative elements
- Fixed PDF alignment issues
- Improved spacing and typography

### Testimonials
- Simplified interface (removed pending/approved sections)
- Single delete functionality for testimonials
- Streamlined workflow

## Technologies Used

- **HTML5** - Structure and content
- **Tailwind CSS** - Styling framework
- **JavaScript** - Interactivity and functionality
- **jsPDF & html2canvas** - PDF generation
- **Font Awesome** - Icons

## Database Schema

ER diagrams available in:
- `BIMS_ER_Diagram.puml`
- `BIMS_ER_Diagram_CORRECTED.puml`

## Installation

1. Clone the repository
2. Open any HTML file in a modern web browser
3. No server setup required - runs entirely in the browser

## Project Structure

```
BIMS/
├── index.html                  # Main landing page
├── login.html                  # Authentication
├── signup.html                 # User registration
│
├── SK Official Pages
│   ├── sk-dashboard.html       # SK Officials dashboard
│   ├── sk-projects.html        # Project monitoring & management
│   ├── sk-files.html           # File management
│   ├── sk-calendar.html        # Event calendar
│   ├── sk-testimonies.html     # Testimonials management
│   └── sk-archive.html         # Completed projects archive
│
├── Youth Volunteer Pages
│   ├── youth-dashboard.html    # Youth volunteer dashboard
│   ├── youth-projects.html     # Browse & apply to projects
│   ├── youth-files.html        # Access files & documents
│   ├── youth-calendar.html     # View events & schedules
│   └── youth-certificates.html # Download certificates
│
├── Captain Pages
│   └── captain-dashboard.html  # Barangay Captain dashboard
│
├── Assets & Resources
│   ├── asset/                  # Images and media files
│   │   ├── hero.jpg           # Landing page background
│   │   └── logo.svg           # BIMS logo
│   ├── css/
│   │   └── responsive.css     # Mobile/tablet responsive styles
│   ├── js/
│   │   └── mobile-nav.js      # Mobile navigation functionality
│   └── docs/                  # Documentation
│
├── Documentation
│   ├── README.md              # Project overview
│   ├── PROGRESS.md            # Development progress tracking
│   ├── CLAUDE.md              # Development guidelines
│   ├── CHANGELOG.md           # Version history
│   ├── RESPONSIVE-GUIDE.md    # Responsive design documentation
│   └── PROJECT DOCUMENTS/     # SE requirements & specifications
│
└── Test Files
    ├── test-projects.html     # Project testing page
    └── DEMO_INSTRUCTIONS.html # Demo usage guide
```

## Browser Compatibility

- Chrome (Recommended)
- Firefox
- Edge
- Safari

## License

© 2025 BIMS - Barangay Information Management System. All rights reserved.

## Contact

- Email: info@malandaybims.ph
- Phone: (02) 8xxx-xxxx
