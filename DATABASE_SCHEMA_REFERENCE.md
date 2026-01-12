# BIMS Database Schema - Actual Table & Column Names

**CRITICAL DISCOVERY**: PostgreSQL converts all identifiers to lowercase by default!

---

## ⚠️ Important Naming Rules

### Table Names
- **Actual Format**: `tablename_tbl` (all lowercase with underscore)
- **Example**: `user_tbl`, `sk_tbl`, `announcement_tbl`

### Column Names
- **Actual Format**: `columnname` (all lowercase, no underscores for most fields)
- **Example**: `userid`, `firstname`, `publisheddate`, `accountstatus`
- **Exception**: Some fields keep underscores like `image_path_url` becomes `imagepathurl`

---

## Complete Table List (From Your Database)

```
announcement_tbl
annual_budget_tbl
application_tbl
budgetbreakdown_tbl
captain_tbl
certificate_tbl
evaluation_tbl
expenses_tbl
file_tbl
inquiry_tbl
logs_tbl
notification_tbl
otp_tbl
post_project_tbl
pre_project_tbl
reply_tbl
report_tbl
sk_tbl
testimonies_tbl
user_tbl
```

---

## Key Tables with Actual Column Names

### user_tbl
```sql
user_tbl (
  userid UUID PRIMARY KEY,
  email VARCHAR(255),
  firstname VARCHAR(100),
  lastname VARCHAR(100),
  middlename VARCHAR(100),
  role VARCHAR(20),              -- 'SK_OFFICIAL', 'YOUTH_VOLUNTEER', 'CAPTAIN'
  birthday DATE,
  contactnumber VARCHAR(13),
  address TEXT,
  imagepathurl TEXT,
  termsconditions BOOLEAN,
  accountstatus VARCHAR(20),     -- 'ACTIVE', 'INACTIVE', 'PENDING'
  createdat TIMESTAMPTZ,
  updatedat TIMESTAMPTZ
)
```

### sk_tbl
```sql
sk_tbl (
  skid SERIAL PRIMARY KEY,
  userid UUID REFERENCES user_tbl(userid),
  position VARCHAR(20),          -- 'SK_CHAIRMAN', 'SK_SECRETARY', 'SK_TREASURER', 'SK_KAGAWAD'
  termstart DATE,
  termend DATE,
  createdat TIMESTAMPTZ
)
```

### announcement_tbl
```sql
announcement_tbl (
  announcementid SERIAL PRIMARY KEY,
  userid UUID REFERENCES user_tbl(userid),
  title VARCHAR(255),
  category VARCHAR(20),          -- 'URGENT', 'UPDATE', 'GENERAL'
  contentstatus VARCHAR(20),     -- 'ACTIVE', 'ARCHIVED'
  description TEXT,
  imagepathurl TEXT,
  publisheddate TIMESTAMPTZ,
  createdat TIMESTAMPTZ,
  updatedat TIMESTAMPTZ
)
```

### file_tbl
```sql
file_tbl (
  fileid SERIAL PRIMARY KEY,
  userid UUID REFERENCES user_tbl(userid),
  filename VARCHAR(255),
  filetype VARCHAR(10),          -- 'PDF', 'XLSX', 'JPG', 'PNG', 'DOC'
  filestatus VARCHAR(20),        -- 'ACTIVE', 'ARCHIVED'
  filepath TEXT,
  filecategory VARCHAR(20),      -- 'GENERAL', 'PROJECT'
  dateuploaded TIMESTAMPTZ,
  createdat TIMESTAMPTZ
)
```

### pre_project_tbl
```sql
pre_project_tbl (
  preprojectid SERIAL PRIMARY KEY,
  userid UUID REFERENCES user_tbl(userid),
  skid INTEGER REFERENCES sk_tbl(skid),
  title VARCHAR(255),
  description TEXT,
  category VARCHAR(100),
  budget BIGINT,
  volunteers INTEGER,
  beneficiaries INTEGER,
  status VARCHAR(20),            -- 'ONGOING', 'COMPLETED', 'CANCELLED'
  startdatetime TIMESTAMPTZ,
  enddatetime TIMESTAMPTZ,
  location VARCHAR(255),
  imagepathurl TEXT,
  submitteddate DATE,
  approvalstatus VARCHAR(20),    -- 'PENDING', 'APPROVED', 'REJECTED', 'REVISION'
  approvaldate DATE,
  approvalnotes TEXT,
  createdat TIMESTAMPTZ,
  updatedat TIMESTAMPTZ
)
```

### application_tbl
```sql
application_tbl (
  applicationid SERIAL PRIMARY KEY,
  userid UUID REFERENCES user_tbl(userid),
  preprojectid INTEGER REFERENCES pre_project_tbl(preprojectid),
  preferredrole VARCHAR(100),
  parentconsentfile TEXT,
  applicationstatus VARCHAR(20), -- 'PENDING', 'APPROVED', 'REJECTED'
  applieddate DATE,
  createdat TIMESTAMPTZ,
  updatedat TIMESTAMPTZ
)
```

---

## JavaScript Query Examples (CORRECT)

### SELECT with WHERE
```javascript
const { data, error } = await supabaseClient
  .from('user_tbl')
  .select('userid, firstname, lastname, email, role, accountstatus')
  .eq('userid', userId)
  .single();

// Access data (all lowercase)
const userName = `${data.firstname} ${data.lastname}`;
const isActive = data.accountstatus === 'ACTIVE';
```

### INSERT
```javascript
const { data, error } = await supabaseClient
  .from('announcement_tbl')
  .insert({
    userid: currentUser.id,
    title: 'New Announcement',
    category: 'GENERAL',
    contentstatus: 'ACTIVE',
    description: 'Description here',
    imagepathurl: null,
    publisheddate: new Date().toISOString()
  })
  .select();
```

### JOIN
```javascript
const { data, error } = await supabaseClient
  .from('user_tbl')
  .select(`
    userid,
    firstname,
    lastname,
    email,
    sk_tbl (
      skid,
      position,
      termstart,
      termend
    )
  `)
  .eq('role', 'SK_OFFICIAL');
```

### UPDATE
```javascript
const { data, error } = await supabaseClient
  .from('user_tbl')
  .update({
    firstname: 'John',
    lastname: 'Doe',
    accountstatus: 'ACTIVE',
    updatedat: new Date().toISOString()
  })
  .eq('userid', userId);
```

---

## Common Column Patterns

| Pattern | Examples |
|---------|----------|
| IDs | `userid`, `skid`, `announcementid`, `fileid` |
| Names | `firstname`, `lastname`, `middlename`, `filename` |
| Status | `accountstatus`, `contentstatus`, `filestatus`, `applicationstatus` |
| Dates | `birthday`, `publisheddate`, `submitteddate`, `applieddate` |
| Timestamps | `createdat`, `updatedat`, `timestamp` |
| URLs/Paths | `imagepathurl`, `filepath`, `certificatefileurl` |
| Boolean | `termsconditions`, `isreplied`, `isread`, `isused` |

---

## SQL Examples (CORRECT)

### Check Account
```sql
SELECT
  u.userid,
  u.email,
  u.firstname,
  u.lastname,
  u.role,
  u.accountstatus,
  s.skid,
  s.position
FROM user_tbl u
LEFT JOIN sk_tbl s ON u.userid = s.userid
WHERE u.userid = '39f5af8b-914a-448e-b6dc-a630f0938b72';
```

### Insert User
```sql
INSERT INTO user_tbl (
  userid, email, firstname, lastname, middlename, role, birthday,
  contactnumber, address, termsconditions, accountstatus
)
VALUES (
  '39f5af8b-914a-448e-b6dc-a630f0938b72',
  'sk.official.test@bims.com',
  'Andrea', 'Pelias', 'Santos',
  'SK_OFFICIAL', '1998-05-15',
  '+639171234567', 'Blk 10 Lot 5, Malanday, Marikina City',
  true, 'ACTIVE'
);
```

### Insert SK Official
```sql
INSERT INTO sk_tbl (userid, position, termstart, termend)
VALUES (
  '39f5af8b-914a-448e-b6dc-a630f0938b72',
  'SK_CHAIRMAN',
  '2024-01-01',
  '2026-12-31'
);
```

---

## Why PostgreSQL Converts to Lowercase

PostgreSQL automatically converts unquoted identifiers to lowercase:

```sql
-- These are ALL equivalent:
CREATE TABLE User_Tbl (...);
CREATE TABLE user_tbl (...);
CREATE TABLE USER_TBL (...);

-- All become: user_tbl
```

To preserve case, you'd need quotes (but don't do this):
```sql
CREATE TABLE "User_Tbl" (...);  -- Case preserved but harder to use
```

---

## Migration Checklist

When updating code, replace:

### Table Names
- `User_Tbl` → `user_tbl`
- `SK_Tbl` → `sk_tbl`
- `Announcement_Tbl` → `announcement_tbl`
- `File_Tbl` → `file_tbl`

### Column Names
- `userID` → `userid`
- `firstName` → `firstname`
- `lastName` → `lastname`
- `middleName` → `middlename`
- `accountStatus` → `accountstatus`
- `contentStatus` → `contentstatus`
- `publishedDate` → `publisheddate`
- `imagePathURL` → `imagepathurl`
- `createdAt` → `createdat`
- `updatedAt` → `updatedat`

---

**Document Version**: 2.0 (Corrected)
**Last Updated**: 2026-01-11
**Status**: Official Reference ✅
