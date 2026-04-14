# Defense SE2 — Minor Revision

**Date:** Apr 14, 2026, 6:52 AM
**Duration:** 18:18
**Outcome:** Passed with minor revisions

---

## Revision Items (Panel Feedback)

1. **Project application scoring / clearance flow** — 📝 **Clarified, no code change needed (2026-04-14)**
   - **Panel remark:** *"If it's 50 to 70, you don't want it anymore. You need to get it to 80. Does the system clear it or is there a specific person who can do it?"*
   - **Finding after verifying the code:** the "score" in BIMS is the **post-completion project success rate**, calculated by `calculateSuccessRate()` in `sk-projects.html` (line 4762) after a project is marked complete. Weighted formula: Budget efficiency 25% + Volunteer participation 20% + Timeline adherence 20% + Community impact 20% + Volunteer feedback 15%.
   - The score is **not** a pre-approval gate. It reflects what actually happened — actual vs. planned budget, actual vs. target volunteers, actual vs. target beneficiaries, timeline status, and volunteer feedback. Inputs are facts, not judgment calls.
   - The panel's suggestion to "upgrade a 50–70 to 80" doesn't technically apply: you cannot raise the score without changing the underlying actuals, and doing so would undermine the metric's purpose as a transparency report card.
   - **Team decision:** keep the existing success-rate feature as designed. Do not add a manual "clear to 80" override — it would misrepresent outcomes.
   - **Authority question (still useful):** if a correction is ever needed because of a data-entry error, the **SuperAdmin and Captain** retain authority to edit the inputs (e.g., fix a wrong volunteer count) which will recalculate the score. Pure score override is not allowed by design.
   - **Defense-ready answer:** see below.

   **Defense answer for item #1 (use verbatim if asked):**
   > "The score in BIMS is a post-completion success rate, not a pre-approval threshold. It's calculated automatically from actual project outcomes — budget efficiency, volunteer participation, timeline adherence, community impact, and volunteer feedback — weighted into a single 0–100% value. Because it reflects what actually happened, it cannot be 'upgraded' by a person; doing so would defeat its purpose as a transparency metric. If data was entered incorrectly, the SuperAdmin or Barangay Captain can correct the underlying inputs and the score recalculates. There is no gating threshold of 80 because a completed project is already completed — the score reports on it, not decides it."

2. **Methodology in discussion**
   - Methodology was not mentioned in the discussion; testing was shown directly.
   - Add/strengthen methodology discussion.

3. **Document formatting**
   - Text is too small in some places, too big in others — others can't read it.
   - Use **sentence case** throughout the document (only capitalize where grammatically required; avoid making everything look like proper nouns).

4. **Table and label consistency**
   - A reference to "Table 4" actually pointed to a label reading "Table 3."
   - Ensure **table and its caption/label are on the same page** as the discussion referencing it.
   - Fix table numbering consistency.

5. **Uploaded document validation** ✅ **DONE (2026-04-14)**
   - Currently only file type (JPEG/PDF) is validated — not content.
   - Question raised: if a registration form or image is uploaded in place of a report, system still accepts it.
   - Decision: since users are limited (~9 SK officials), **double-checking of documents will be handled manually by the users**, not the system.
   - Document this business rule clearly (system validates file type only; content validation is a user/officer responsibility).
   - **Action taken:** `sk-files.html` upload modal now shows an amber business-rule notice directly under the accepted-formats line: *"Content review is manual. The system validates file type and size only. You are responsible for confirming the document is the correct one (e.g., a project report, not a registration form) and placing it in the right category before uploading."* This makes the manual-review expectation visible to every SK official at the point of action.

6. **Archiving / retention policy** ✅ **DONE (2026-04-14)**
   - One-year retention is insufficient.
   - National Privacy Commission guidance: up to **5 years**, then shred/dispose.
   - Example rationale: rejected UST applicant's resume — ownership reverts; policy must address this.
   - **Action taken:**
     - New migration `supabase/migrations/027_file_retention_5yr.sql` creates `public.archive_old_files()` — marks `File_Tbl` rows with `fileStatus='ACTIVE'` and `createdAt < NOW() - INTERVAL '5 years'` as `ARCHIVED`. Deployed to remote DB.
     - Scheduling hint included for pg_cron (monthly, 1st at 02:30 UTC): `SELECT cron.schedule('archive-old-files', '30 2 1 * *', 'SELECT public.archive_old_files()');`
     - Files are soft-archived, not deleted — disposal/shredding after the 5-year window remains a manual Captain/SuperAdmin decision.
     - UI: `sk-archive.html` empty-state now reads "Files older than 5 years will be automatically archived (NPC retention policy)".

7. **Reports (new required feature)** ✅ **DONE — initial implementation (2026-04-14)**
   - Currently only statistics and dashboards exist — **no report output**.
   - Add **report generation** to the document and system:
     - Dashboard/statistics should be exportable (CSV, spreadsheet, or other format) via an export button.
     - Include "system is capable of producing reports" in the documentation.
   - Identify which of the 1–6 objectives this belongs under (Information Management).
   - Reports cannot be edited by users, but exports should be available.
   - **Action taken:**
     - New utility `js/utils/report-export.js` — CSV/XLS builder with UTF-8 BOM (Excel-compatible), proper CSV escaping, grouped sections, report metadata header (title, generated date/time, generated by, source page).
     - `sk-dashboard.html` — added **Export Report** dropdown button above the stats grid, with format picker (CSV / Spreadsheet .xls). Pulls live counts from the dashboard plus a fresh project-status breakdown (Ongoing / Completed / Pending / In Revision / Rejected) and produces a timestamped file like `sk-dashboard-report_20260414_0730.csv`.
     - Logs the export action via `logAction('Exported dashboard report', { format })`.
   - **Expanded to all dashboards (2026-04-14):**
     - `captain-dashboard.html` — Export Report dropdown on the Project Approvals section. Report groups: Approvals Summary (pending/approved/rejected/revision + total budget) and Open Project Cap (SE2 rule — open count vs. MAX_OPEN_PROJECTS = 3, completed count, slots remaining). Filename: `captain-approvals-report_<stamp>.csv|xls`.
     - `superadmin-dashboard.html` — Export Report dropdown on System Overview. Report groups: User Accounts (total/active/pending/deactivated), Activity (projects, applications, today's logs, total logs), and Records Distribution (when available). Filename: `superadmin-system-report_<stamp>.csv|xls`.
   - **Still to do:** add the capability to the SRS/SDD under Information Management objective as an explicit capability.

8. **Rejection reason** ✅ **DONE (2026-04-14)**
   - Add/clarify the reason for rejection in the flow (was not clearly explained earlier).
   - **Action taken (`captain-dashboard.html`):**
     - Relabelled the textarea to *"Comments / Reason (required when rejecting or requesting revision)"* with a helper line noting that rejection reasons are shown to the SK Official and stored on the project record.
     - Placeholder rewritten to guide the Captain: *"For rejection: state the specific reason (e.g., incomplete budget, missing attachments, conflicts with barangay policy). For revision: list the changes needed. For approval: optional notes."*
     - `rejectProject()` now enforces a **minimum 10-character** reason, focuses the field on error, and echoes the entered reason back in the confirmation dialog.
     - `requestRevision()` mirrors the same 10-char rule and echo-back pattern.
     - `approveProject()` stays optional (notes not required for approval).

9. **Encryption policy** ✅ **DONE (2026-04-14)**
   - Earlier explanation was not clear — strengthen and add detail as requested.
   - **Action taken:** authored a full encryption policy document at `docs/revisions/defense_se2/ENCRYPTION_POLICY.md` covering scope, encryption in transit (HTTPS/TLS 1.2+, CSP restrictions), encryption at rest (Supabase AES-256 on Postgres + Storage + backups), credential handling (bcrypt via Supabase Auth, session JWTs, anon vs service-role key separation), how RLS reinforces encryption, integration with the 5-year retention policy, explicit non-claims (no app-level field encryption, no self-managed keys), and verification commands for every claim. Replaces the vague defense answer with specific, auditable statements.

10. **Landing page design** ✅ **DONE (2026-04-14)**
    - Current landing page looks "elitist / Makati-style."
    - Make it feel closer to the barangay / community — authentic Filipino context.
    - Suggested imagery: volunteer wearing a blanket, genuine community scenes (not staged/glamorous).
    - Show that volunteers are real community members.
    - **Action taken:** Replaced `asset/hero.jpg` (previous stock photo of young woman holding "VOLUNTEER" sign) with an authentic Barangay Malanday community photo — SK volunteers with local children at the covered court during a gift-giving activity. Original file backed up as `asset/hero_old_backup.jpg`; new source preserved as `asset/hero_barangay_malanday.jpg`.
    - **Layout update:** Restructured the hero from a full-bleed background image (with heavy dark overlay obscuring the photo) to a modern **two-column split layout** — text content on the left, image card on the right (stacked on mobile). Image is now presented as a rounded card with shadow, subtle gradient overlay, and a glass caption badge ("Gift-giving at Barangay Malanday — Real SK volunteers. Real community."). This is the standard pattern (Stripe, Linear, Vercel) and lets the authentic photo stay fully visible and readable instead of being darkened into the background.

11. **Project evaluation — approval gating** ✅ **DONE (2026-04-14)**
    - Original panel feedback: do not allow a new approval while a previous project is still open.
    - **Refined team decision:** instead of blocking entirely, cap open (approved & not completed) projects at **3**. Allows reasonable parallelism while preventing unbounded overlap.
    - Prevents corruption / overlapping approvals.
    - **Action taken:**
      - `captain-dashboard.html` — `approveProject()` now counts rows where `approvalStatus = 'APPROVED'` AND `status != 'COMPLETED'` before approval; if count ≥ 3, approval is blocked with a toast and no DB write occurs.
      - `sk-projects.html` — the REVISION → auto-APPROVED path applies the same 3-open cap so the bypass can't be used to exceed the limit.
      - Constant `MAX_OPEN_PROJECTS = 3` declared in `captain-dashboard.html` for easy tuning.

---

## Deployment / Next Steps

- Two weeks given by Ma'am Mia — target deployment in **first or second week of CACS week**.
- Maintain systematic style during revisions; don't rush.
- Panel noted: proper interviews (~10 iterations) would strengthen the work; Shelo's involvement at SK Malanday was questioned.
- Team will be split into two groups going forward.

---

## Roles Called Out by Panel

- Project Manager
- Systems Analyst
- Business Analyst
- Developers
- QA — Espinoza, Guarnieta, Jeronimo

---

## Verdict

No formal verdict given — project accepted, revisions required within two weeks. Congratulations extended. Deployment pending.

---

## Document-only Revisions

For items that require SRS / SDD / SPMP edits (not code), see
[`DOCUMENT_REVISIONS_NEEDED.md`](DOCUMENT_REVISIONS_NEEDED.md) — it lists the exact wording to add
to the `UPDATE_GUIDE_*.md` files for methodology, sentence case, reports capability,
encryption policy, 5-year retention, 3-open cap, upload rule, and rejection rule.
Item #4 (table/label consistency) is intentionally skipped per team decision.

---

## Handwritten Panel Notes (System Revisions Checklist)

Source: Screenshot 2026-04-14 070530.png

**System:**
1. Validation of uploaded document
2. Archiving policy — (3–5 years) — **ask your client**
3. Reason for Reject
4. Include encryption policy
5. Reports
6. Project evaluation → **before approving, close prior project**

These six items are the consolidated system-side revision checklist from the panel and align with items 5, 6, 8, 9, 7, and 11 in the main revision list above.

---

## Raw Transcript

```
(0:00) If I were you, if I were you, when applying for a project, (0:08) it's like you have something to clear. (0:12) Do you get it? (0:14) Since you have a number earlier, whatever you get there, you have a range of score. (0:22) If it's 50 to 70, you don't want it anymore.
You need to get it to 80. (0:28) Does the system clear it or is there a specific person who can do it? (0:33) No, ask your client first if that's how you're going to do it. (0:37) If that's how you're going to do it, and you're going to upgrade, (0:39) don't put it in the system.
(0:42) You already completed it, you wasted the competition earlier. (0:45) For the competition to have an impact, it's a waste of time. (0:49) It's still good.
(0:52) Okay? (1:31) Okay. (2:26) Okay, you can go now. (2:30) Thank you, sir.
(2:33) You're welcome. (2:34) I'll stop in the further source. (2:39) I'm bad.
(3:07) This is just a joke. (3:09) Look. (3:09) They're giving you the extra money.
(3:11) I flow off my computer. (3:17) I'm hungry. (3:21) This is not a joke.
(3:29) You are just making it up. (3:31) They're inside the house intelligence. (3:54) Okay, I'm going to let you know where the packets are.
(3:58) And then, who else is going to be here with me in the capsule? (4:03) Oh, you're going to be alone. (4:10) What's your name? Are you a web developer? (4:13) I didn't know you were a web developer. (4:14) But I don't like web developers.
(4:18) Why? (4:18) I'm not a web developer. (4:24) I have a lot of knowledge. (4:26) But I'm a web developer.
(4:28) Why are you here? (4:30) I'm going to tell you something. (4:31) There are four of us. (4:35) I don't know which one of us is a web developer.
(4:39) Which one? (4:40) Which one? (4:40) That's why I'm here. (4:43) That's why I'm going to tell you. (4:45) I have a lot of knowledge.
(4:49) But I'm going to call you. (6:37) You didn't mention the methodology in your discussion earlier. (6:42) You tested the methodology right away.
(6:44) It's still small. (6:45) It's already big. (6:46) Others can't read it.
(6:49) And then, use sentence case all throughout the document. (6:54) I'll start with the document. (6:55) Sentence case means if you don't need capital letters, don't use capital letters.
(7:00) Right? (7:00) Because if you do it again and again, it gets bigger. (7:02) It looks like a proper noun. (7:04) Okay? (7:05) Then, the table and label consistencies.
(7:09) Earlier, I saw that you're addressing table 4, but the label on table is table 3. (7:17) Okay? (7:17) If you're going to teach, the table and what you're teaching should be within the same page. (7:26) You're teaching table 3. (7:28) When you're looking for table 3, it's on the next page. (7:30) So, maybe the claim value should be higher than the table consistencies.
(7:38) And then, for the system, my question earlier about the validation of the uploaded document, (7:44) how can we validate that the document is correct? (7:48) What was uploaded in the document earlier? (7:52) Report? (7:55) Aside from that, what sample doc is that? (7:57) What is it called? (8:00) If I uploaded a registration form, will it still accept it? (8:05) Yes. (8:06) What is your business role in that? (8:08) We separate them into general and project files. (8:12) So, who will check that? (8:14) Will the system check it or the user? (8:17) Because if I uploaded, for example, I uploaded a picture with Shell, will it still accept it? (8:23) Yes.
(8:23) Because you said JSON, PDF. (8:25) Right? (8:27) Yes. (8:27) What if it's not like that, but it's a document, will it still accept it? (8:33) Since there are only a few in our users, we are expecting only 9 in the SKA officials.
(8:40) They will only talk about the double checking of the documents. (8:46) If it's really files. (8:48) Because it's easy to say that.
(8:50) Can't you make a system that checks immediately if it's a file? (8:54) We only check the file type, but the decision if it's a file or not. (9:00) So, it can't be done. (9:01) What will you do with the archiving policy? (9:05) It can't be just one year.
(9:09) We will have a consultation with the client on what is the perfect... (9:14) The National Privacy Commission said up to five. (9:19) What they are doing is they are shredding the report if they don't need it after five years. (9:25) For example, one more thing.
(9:26) I applied to the UST, but I was not accepted. (9:28) My resume is with them. (9:30) Who owns my resume now? (9:32) You.
(9:33) Right? (9:33) So, if that's the case, I can get it back. (9:35) So, what's the policy if that's the case? (9:37) So, your document is three to five years. (9:41) Then, we will make a report.
(9:43) But it's a waste because there are a lot of statistics there. (9:48) It will be controlled by the username itself. (9:53) For example, I can't show it because I'm hiding something.
(9:57) But you can't edit the report. (9:59) Although we can't change your document, where can you put the report? (10:03) What do you mean? (10:04) Your document. (10:05) You don't have a report earlier.
(10:07) You only have statistics and a dashboard. (10:09) So, we are requiring you to include reports in your document. (10:14) Where will you put the report? (10:18) There are a lot of objectives here.
(10:23) Information management. (10:25) Information management. (10:34) The report, the dashboard earlier, where is it included? (10:40) In your objective.
(10:43) You make a dashboard with statistics. (10:46) Where do you include this part? (10:49) In your one to six objectives. (10:52) It's information.
(10:54) So, just include the plan and reports in your document. (11:01) Then, the reason why you rejected it earlier. (11:08) Then, the encryption policy.
(11:14) Earlier, you didn't give a clear explanation. (11:18) Just add it. (11:18) As per your request, you can strengthen it.
(11:25) For me, the report is better. (11:28) Because as a creditor, we are always looking for it. (11:33) And then, because I will teach in ECI, (11:37) your landing page should be honest.
(11:41) Bring it closer to the barangay. (11:42) Don't be like an elitist from Makati, (11:45) who is being trampled by a thief. (11:47) But he will volunteer.
(11:50) The one who should volunteer is the one who looks dirty, right? (11:53) Don't be like that. (11:57) You will look for a lot of things. (12:00) Why don't you make the barangay, (12:03) as he said, the barangay can be the building.
(12:06) If you don't want the building, the people. (12:09) They are happy to hold hands. (12:12) But the Filipinos should look good.
(12:14) I have a picture of a blanket. (12:18) The very Filipino. (12:20) He is wearing a blanket.
(12:22) The one I found in the barangay. (12:24) He is a volunteer. (12:25) He should show that he can do it.
(12:30) He is wearing a blanket. (12:32) He is asking for support. (12:34) He is going to blanket.
(12:36) Don't drink on the street. (12:39) Do you have one, sir? (12:41) Sir, I have a question on the report. (12:44) Is the report in the statistics? (12:47) No.
(12:48) What we mean is, (12:50) the numbers are wasted (12:52) if there is no destination. (12:54) Right? (12:55) What we mean is, (12:58) why don't you mention in your document (13:00) that the system is capable of producing reports. (13:05) You are an expert.
(13:06) You have statistics, right? (13:08) You have a diagram. (13:09) On the left, (13:11) there is an export. (13:13) You can download it.
(13:15) There is a CSV, spreadsheet, (13:18) or another format. (13:20) So there is a report. (13:21) And lastly, (13:23) in the evaluation of the project, (13:26) should I apply? (13:29) It's a waste.
(13:31) If you are approved (13:32) in your projects, (13:34) without (13:34) closing the previous project, (13:39) there will be corruption. (13:42) Okay. (13:43) Okay.
(13:44) So lastly, (13:45) I would like to call (13:47) the project manager, (13:51) systems analyst, (14:04) business analyst, (14:05) business analyst, (14:09) developers, (14:19) QA, (14:23) Espinoza, (14:25) Guarnieta, (14:27) and Jeronimo. (14:37) You didn't give a score. (14:39) You have a long mouth.
(14:45) Sir, I don't have any more questions. (14:47) Okay. (14:49) We don't have a verdict (14:50) when it comes to this, right? (14:52) Since you are accepted in your project.
(14:54) I think, how many weeks are you given (14:55) by Ma'am Mia? (14:56) Two weeks? (14:58) So first week or second week (15:00) of CACS week? (15:02) When is the deployment? (15:03) I don't have one yet. (15:06) So that we can be closer. (15:10) The problem is, (15:11) some CICA students don't want to accept.
(15:15) When they get the grade, (15:16) there is no deployment. (15:18) Okay. (15:20) So I will ask you, Shelo.
(15:23) Is there no cousin, Shelo, (15:25) in all of you? (15:26) Are you sure? (15:28) You are my DNA. (15:30) There might be a son there. (15:33) Okay, congratulations.
(15:34) We hope that it will continue. (15:37) The execution of your project (15:40) Although, it's just a lot. (15:43) You are in a hurry (15:44) because you want to highlight everything.
(15:47) It's a waste of beauty (15:48) if we are in a hurry. (15:50) Anyway, you will be separated. (15:54) You will be split into two groups.
(15:58) So my advice is that (15:59) you maintain that strategy. (16:01) It's not good, (16:02) but you should maintain (16:04) a systematic style. (16:06) You will get it (16:08) if you properly interview (16:09) maybe 10 times.
(16:13) How many times have you interviewed Shelo? (16:16) It's random. (16:17) Because Shelo is not here, (16:19) you don't send him to SK Malanday. (16:24) If we ask for your picture in Malanday, (16:26) will you show it to us? (16:27) No, right? (16:29) Okay, congratulations.
(16:32) Congratulations. (16:45) Your background (16:58) Your background (17:00) Volunteer (17:01) Raise your hand. (17:03) Hold the mic.
(17:07) Hold the mic. (17:10) Okay. (17:14) Pay your debt first.
(17:16) Hey, Shelo. (17:17) Pay your debt. (17:19) Okay.
(17:20) One, two, three. (17:24) Organize. (17:25) One, two, three.
(17:27) Show your real colors. (17:29) One more. (17:31) One, two, three.
(17:34) Okay, sir. (17:37) You look shy. (17:41) You look shy.
(17:53) Thank you. (18:01) Shelo, thank you. (18:05) Thank you.
```
