CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,    -- Unique identifier for each user from auth system, auto deletes associated data on user deletion
  user_name VARCHAR(20) UNIQUE NOT NULL,       -- Unique username required
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP  -- Auto-set user account creation time including time zone
);

CREATE TABLE route_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'completed', 'cancelled')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ended_at TIMESTAMPTZ,
  start_latitude DECIMAL(9,6),
  start_longitude DECIMAL(9,6),
  end_latitude DECIMAL(9,6),
  end_longitude DECIMAL(9,6)
);

CREATE TABLE location_points (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES route_sessions(id) ON DELETE CASCADE,
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  recorded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trusted_observers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  observer_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE (owner_user_id, observer_user_id)
);

CREATE TABLE session_observers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES route_sessions(id) ON DELETE CASCADE,
  observer_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  UNIQUE (session_id, observer_user_id)
);

CREATE TABLE observer_invite_codes (
  code_hash TEXT PRIMARY KEY,
  owner_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  expires_at TIMESTAMPTZ NOT NULL,
  used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)