# SafeRoute MVP - Data Model
This document describes the SQL data model for the SafeRoute MVP.  This schema is minimal and session-based to support real-time location shasring while minimizing data retention and security risk.

***

## Design Principles
- **Session-based tracking**: Locaion data only exists within an active route session
- **Data separation**: User identity, trip metadata, and geolocation data are stored in separate tables
- **Explicit and session-based authorization**: Observers must be explicitly authorized per session
- **Minimal retention**: Location points are designed to be deleted after 14 days
- **Read-only location data**: Historical location points are never modified

***

## Tables
### 1. `users`
Stores user identity information.

**Fields:**
- `id` (UUID, PK)
- `email` (TEXT, UNIQUE)
- `user_name` (TEXT)
- `created_time` (TIMESTAMP)

**Notes:**
- Observers and tracked users are both represented as users



### 2. `route_sessions`
Represents metadata from a single tracked trip.

**Fields:**
- `id` (UUID, PK)
- `user_id` (UUID, FK --> users.id)
- `status` (TEXT) --> `active | completed | cancelled`
- `started_time` (TIMESTAMP)
- `end_time` (TIMESTAMP, nullable)
- `start_latitude` (DECIMAL, nullable)
- `start_longitude` (DECIMAL, nullable)
- `end_latitude` (DECIMAL, nullable)
- `end_longitude` (DECIMAL, nullable)

**Notes**
- One user may have many sessions but only one active session at a time
- Start and end metadata allow session summaries to reduce storage overhead



### 3. `location_points`
Stores periodic geolocation updates during active route session.

**Fields:**
- `id` (UUID, PK)
- `session_id` (UUID, FK --> route_sessions.id)
- `latitude` (DECIMAL)
- `longitude` (DECIMAL)
- `recorded_time` (TIMESTAMP)

**Notes**
- Data is read-only
- Location points are deleted after 14 days
- Minimal data is temporarily stored in MVP



### 4. `trusted_observers`
Represents longer-lived trust relationships between users

**Fields:**
- `id` (UUID, PK)
- `owner_user_id` (UUID, FK --> users.id)
- `observer_user_id` (UUID, FK --> users.id)
- `created_time` (TIMESTAMP)

**Notes**
- Owner grants observer the ability to view sessions
- Trust relationships do not automatically grant access to sessions



## 5. `session_observers`
Grants explicit observer access to a specific route session

**Fields:**
- `id` (UUID, PK)
- `session_id` (UUID, FK --> route_sessions.id)
- `observer_user_id` (UUID, FK --> users.id)

**Notes**
- Observers must already exist in `trusted_observers`
- Authorization only applies to the associated session



## 6. `observer_invite_codes`
Supports temporary, secure invitation of trusted observers

**Fields:**
- `code_hash` (TEXT, UNIQUE)
- `owner_user_id` (UUID, FK --> users.id)
- `expires_at` (TIMESTAMP)
- `used` (BOOLEAN)
- `created_time` (TIMESTAMP_)

**Notes**
- Invite codes are stored as cryptographic hashes from randomly and securely generated tokens
- Users must share the raw token out-of-band
- Verify observer submitted `owner_user_id` and token by hashing token and ensuring invite is not used or expired

***

## Relationships Summary
- `users` 1 --> N `route_sessions`
- `route_sessions` 1 --> N `location_points`

- `users` 1 --> N `trusted_observers` (as both owner and observer)

- `route_sessions` 1 --> N `session_observers`
- `users` 1 --> N `session_observers` (as observer)

- `users` 1 --> N `observer_invite_codes`

***

## Security Notes
- Location data is session-scoped and time-limited
- No OS permissions state stored in database
- Authorization is explicit and revocable at both trust and session levels
- Potential future work in rate limiting code validation