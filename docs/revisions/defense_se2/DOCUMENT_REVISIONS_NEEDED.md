# Document Revisions Needed — SE2 Defense (2026-04-14)

This file lists the changes that must be applied to the formal SRS, SDD, and SPMP documents based on the SE2 panel feedback. It is the companion to `DEFENSE_SE2_TRANSCRIPT.md`, which tracks the system-side work.

Each section below points to the `UPDATE_GUIDE_*.md` file that already holds the copy-paste-ready language for the Word document — add/replace text there so the next doc regeneration picks up the changes.

> **Note:** Table/label numbering consistency (original item #4) is intentionally excluded per team decision.

---

## 1. Methodology — must be discussed before results (item #2)

**Panel remark:** *"You didn't mention the methodology in your discussion earlier. You tested the methodology right away."*

**Where:** SRS front matter / SDD Section 1 (Introduction) and SPMP Section A.

**Change needed:**
- Add a dedicated **"Research / Development Methodology"** subsection *before* any testing or results discussion. Cover:
  - Chosen methodology (Agile / Iterative / SDLC phase model — whichever the team actually used).
  - Why it was chosen (small team, evolving client requirements, short timeline).
  - How each phase maps to deliverables (planning → SRS, design → SDD, build → sprints, test → QA plan).
  - Data-gathering method used with the client and pilot barangay (interviews with SK officials, document review, iterative prototype feedback).
- In the oral defense script (`SE2_PPT_GUIDE.md`), insert the methodology slide/paragraph **before** the feature walkthrough.

**Target file:** `docs/UPDATE_GUIDE_SPMP.md` — add a new "Methodology (insert before Section B)" block. Also add a paragraph to `docs/UPDATE_GUIDE_SRS.md` under Section 1.

---

## 2. Sentence case throughout (item #3)

**Panel remark:** *"Use sentence case all throughout the document. If you don't need capital letters, don't use capital letters. Because if you do it again and again, it gets bigger. It looks like a proper noun."*

**Rule:** only the first word of a heading/sentence and actual proper nouns (names, places, product names, acronyms) are capitalized. Everything else is lowercase.

**Where:** all three documents (SRS, SDD, SPMP) — headings, subheadings, table titles, figure captions, bullet lead-ins.

**Concrete before → after examples to apply:**

| Current (title case) | Revised (sentence case) |
|---|---|
| "System Overview And Objectives" | "System overview and objectives" |
| "Non-Functional Requirements" | "Non-functional requirements" |
| "Data Dictionary Tables" | "Data dictionary tables" |
| "Technical Feasibility Analysis" | "Technical feasibility analysis" |
| "Project Management Plan" | "Project management plan" |
| "Overview Of The Barangay Information Management System" | "Overview of the Barangay Information Management System" *(proper noun preserved)* |
| "Barangay Captain" (when not a title preceding a name) | "barangay captain" |
| "SK Official" (role, generic) | "SK official" *(SK kept — acronym)* |

**Keep capitalized (proper nouns / acronyms):**
- Barangay Malanday, Sangguniang Kabataan, SK, BIMS, Supabase, PostgreSQL, Netlify, JavaScript, HTML, CSS, Tailwind, National Privacy Commission, NPC, Google, Gmail, JWT, OTP, RLS, AES, TLS, HTTPS.
- Acronyms stay uppercase.
- Table/figure labels keep the leading word capitalized: *"Table 1: User account fields"*.

**Target files:** `UPDATE_GUIDE_SRS.md`, `UPDATE_GUIDE_SDD.md`, `UPDATE_GUIDE_SPMP.md` — go through every heading and body paragraph and apply the rule. This is a mechanical pass; do it last so no new title-case text gets added after.

---

## 3. Reports capability (item #7) — add to Information Management objective

**Panel remark:** *"The numbers are wasted if there is no destination. Why don't you mention in your document that the system is capable of producing reports. You have statistics, right? You have a diagram. On the left, there is an export. You can download it. There is a CSV, spreadsheet, or another format."*

**Where to add:**
- **SRS — Section 4 (Specific requirements):** under the Information Management objective (one of the 1–6 objectives), add a functional requirement:
  > *"The system shall provide dashboard metrics in exportable report form. Authorized users (SK official, Barangay Captain, System Administrator) shall be able to download the current dashboard snapshot in CSV or spreadsheet (.xls) format. Reports include a header with title, generation timestamp, generator, and source page, followed by grouped metric sections. Exported data is read-only — users cannot alter historical figures through the export path."*
- **SDD — Section 3 (Design):** add a new component entry:
  > *"ReportExport utility (`js/utils/report-export.js`) — CSV/XLS builder with UTF-8 BOM, CSV-escaped values, grouped sections, and metadata header. Consumed by `sk-dashboard.html`, `captain-dashboard.html`, and `superadmin-dashboard.html` via an Export Report dropdown placed above each statistics grid."*
- **SPMP — Deliverables list:** note that reporting/export is now part of the MVP (not a post-launch item).

**Target files:** `UPDATE_GUIDE_SRS.md` (new section under Information Management), `UPDATE_GUIDE_SDD.md` (new component), `UPDATE_GUIDE_SPMP.md` (deliverables).

---

## 4. Encryption policy — strengthen (item #9)

**Panel remark:** *"Earlier, you didn't give a clear explanation. Just add it. As per your request, you can strengthen it."*

**Where:** SRS Section 4.1.2 (Non-functional requirements — Security) and SDD Section on Security architecture.

**Change needed — replace the current vague paragraph with the four-part statement:**

1. **In transit.** All traffic to Supabase (REST, Realtime, Storage, Auth) and Google OAuth uses HTTPS (TLS 1.2+). A Content-Security-Policy meta tag restricts `connect-src` to `https://*.supabase.co` and `wss://*.supabase.co`, blocking plaintext fallback.
2. **At rest.** The database (Supabase Postgres on AWS RDS) and file storage (Supabase Storage on S3-compatible object storage) are both encrypted at rest with AES-256, managed by the platform. Backups inherit the same guarantee.
3. **Credentials.** User passwords are hashed with bcrypt by Supabase Auth (GoTrue). Passwords never appear in application logs, `Log_Tbl`, `localStorage`, or URL parameters. Session tokens are signed JWTs issued by Supabase and validated on every RLS-protected query. The service-role key is never shipped to the browser; only the anon (publishable) key is present client-side.
4. **Defense in depth.** Row-Level Security (RLS) policies on every table re-check each request, so at-rest encryption translates into real privacy: an authenticated user can only decrypt the rows their role and identity allow.

**Also:** link the full policy file `docs/revisions/defense_se2/ENCRYPTION_POLICY.md` as an appendix reference so reviewers can verify every claim.

**Target files:** `UPDATE_GUIDE_SRS.md` (4.1.2 rewrite), `UPDATE_GUIDE_SDD.md` (Security section).

---

## 5. Archiving / retention — 5 years (item #6)

**Already implemented in code.** Docs still need wording change.

**Where:** SRS non-functional requirements (Data retention) and SDD data dictionary note on `File_Tbl`.

**Change needed:**
- Replace any occurrence of *"1 year"* or *"one-year retention"* with **"five (5) years"**.
- Add the sentence: *"Retention aligns with National Privacy Commission (NPC) guidance. After five years, files are automatically marked ARCHIVED by the scheduled `archive_old_files()` database function; final disposal/shredding is a manual decision by the Barangay Captain or System Administrator."*

**Target files:** `UPDATE_GUIDE_SRS.md`, `UPDATE_GUIDE_SDD.md`.

---

## 6. Project approval cap — 3 open at a time (item #11)

**Already implemented in code.** Docs must describe the rule.

**Where:** SRS functional requirements (Project approval workflow) and SDD business-rule section.

**Change needed — add the rule verbatim:**

> *"No more than three (3) projects may be in an approved-and-not-yet-completed state at any time. The Barangay Captain cannot approve a new project while three others are still open; one must be completed first. This rule is enforced in `captain-dashboard.html` (approveProject) and in the revision auto-approve path in `sk-projects.html`. The `MAX_OPEN_PROJECTS` constant controls the cap."*

**Target files:** `UPDATE_GUIDE_SRS.md`, `UPDATE_GUIDE_SDD.md`.

---

## 7. Upload validation — document the business rule (item #5)

**Already implemented in UI.** Docs should record the decision.

**Where:** SRS Section 4 (File management functional requirement) and SDD (Upload component).

**Change needed — add:**

> *"The system validates file type (PDF, DOC, DOCX, XLS, XLSX, PNG, JPG, JPEG) and size (≤ 10 MB) automatically. Content correctness — confirming that the uploaded document is the intended one (e.g., a project report, not a registration form) and that it belongs in the selected category — is the SK official's responsibility and is enforced via peer review among the nine SK officials. A notice to this effect is shown at the point of upload."*

**Target files:** `UPDATE_GUIDE_SRS.md`, `UPDATE_GUIDE_SDD.md`.

---

## 8. Rejection reason — document the rule (item #8)

**Already implemented in code.** Docs should note the requirement.

**Change needed — add to SRS approval workflow section:**

> *"When rejecting a project or requesting revision, the Barangay Captain must provide a reason of at least 10 characters in the Comments / Reason field. The reason is stored on the project record (`approvalNotes`) and displayed to the SK official on `sk-projects.html` so they can respond. Approval notes are optional."*

**Target files:** `UPDATE_GUIDE_SRS.md`, `UPDATE_GUIDE_SDD.md`.

---

## 9. Project scoring / clearance flow (item #1) — **Resolved by code inspection, not a gap**

**Panel remark:** *"If it's 50 to 70, you don't want it anymore. You need to get it to 80. Does the system clear it or is there a specific person who can do it?"*

**Finding after checking the system:** the score the panel referenced is the **project success rate** (`calculateSuccessRate()` in `sk-projects.html`, line 4762). It is a post-completion metric — calculated from actual budget, actual volunteers, actual beneficiaries, timeline status, and volunteer feedback — not a pre-approval gate. It cannot be "raised to 80" by a person because raising it would require changing the underlying actuals, which would misreport the project.

**No code or doc change needed**, but the SRS / SDD should explain the feature clearly so the panel doesn't misinterpret it again.

**Change needed:**

- **SRS — Section 4 (functional requirements), under Post-project evaluation:**
  > *"Upon marking a project as COMPLETED, the system computes an automatic success rate (0–100%) from the actual outcomes of the project. The formula is weighted: budget efficiency 25%, volunteer participation 20%, timeline adherence 20%, community impact 20%, volunteer feedback 15%. The success rate is an outcome indicator for transparency and is not a pre-approval threshold. It cannot be manually overridden. If an input value was entered incorrectly, the SuperAdmin or Barangay Captain may correct the input and the score recalculates automatically."*
- **SDD — Post-project evaluation component:** document the same formula and mark it explicitly as **outcome metric, not decision gate**.
- Add this paragraph to both documents as an explicit note so reviewers understand the score's role.

**Defense talking point (also in `DEFENSE_SE2_TRANSCRIPT.md` item #1):**
> "The score in BIMS is a post-completion success rate, not a pre-approval threshold. It's calculated automatically from actual project outcomes — budget efficiency, volunteer participation, timeline adherence, community impact, and volunteer feedback. Because it reflects what actually happened, it cannot be 'upgraded' by a person; doing so would defeat its purpose as a transparency metric."

**Target files:** `UPDATE_GUIDE_SRS.md` (new paragraph under Post-project evaluation), `UPDATE_GUIDE_SDD.md` (clarify component role). Client consultation no longer required for item #1.

---

## Landing page (item #10) — no doc change needed

The landing page is visual/asset work; the SRS already states the system has a public transparency landing page. No wording update required.

---

## Summary checklist for the document editor

- [ ] Add methodology section to SPMP (and short intro in SRS)
- [ ] Apply sentence-case pass across all three documents
- [ ] Add reports/export capability (SRS requirement + SDD component + SPMP deliverable)
- [ ] Replace encryption paragraph with 4-part statement + appendix link
- [ ] Change retention wording from 1 year to 5 years + NPC reference
- [ ] Add 3-open project cap rule
- [ ] Add upload content-review business rule
- [ ] Add rejection-reason minimum rule
- [ ] Add post-project success-rate clarification (outcome metric, not decision gate) to SRS + SDD
