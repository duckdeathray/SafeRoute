# Row Level Security Policies (RLS)
This document describes the Row Level Security policies for the SafeRoute MVP.  These policies enforce per-user access control and follow the principle of least access.  By default, users are denied unauthorized access to other users' data.

***

## Authentication
RLS policies rely on Supabase authentication
- auth.uid() represents the UUID of the currently authenticated user
- All queries are executed by authenticated users
- access bypassing RLS are limited to admin operations


## Design Principles
- Least privilege: users only access data required
- Ownership-based access: primary access is determined by row ownership
- Explicit sharing: shared access is granted only through observer tables
- Database enforced security: no client-side checcks


## Tables

### 1. `users`
**Access Rules:**
- Users may read, update, and delete their own profile
- Users may not access other users' profile data

**Policy Logic:**
- Ownership via `users.id = auth.uid()`



### 2. `route_sessions`
**Access Rules:**
- Owners may create, read, update, and delete their own sessions
- Observers may read sessions they are explicitly assigned to
- No user may modify sessions they do not own

**Policy Logic:**
- Owners access via `route_sessions.user_id = auth.uid()`
- Observers access via `session_observers` join table



### 3. `location_points`
**Access Rules:**
- Owners may read and write location points for their own sessions
- Observers may read location points for sessions they are assigned to

**Policy Logic:**
- Access for owners is inferred via `route_sessions`
- Access for observers is 



### 4. `trusted_observers`
**Access Rules:**
- Owners may read, write, and delete observers they have added
- Observers may read and delete owners they have been assigned to

**Policy Logic:**
- Ownership via `owner_user_id = auth.uid()`
- Observer via `observer_user_id = auth.uid()`
