/* 
RLS Row Level Security Policies

Users can:
    - Read their own profile
    - Create, read, update, and end their own route sessions
    - Insert and read location points for sessions they own
    - Unauthorized access to other users' data is prevented
*/

ALTER TABLE 