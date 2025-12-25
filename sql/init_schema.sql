CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,    -- Unique identifier for each user from auth system, auto deletes associated data on user deletion
  user_name VARCHAR(20) UNIQUE NOT NULL,       -- Unique username required
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP  -- Auto-set user account creation time including time zone
);

