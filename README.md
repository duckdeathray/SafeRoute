# SafeRoute
SafeRoute is a session-based route tracking MVP that allows a user to start a trip, share live location updates during the trip, and allows a trusted observer to view trip progress until the user is marked safely arrived.

## MVP Scope
##### - Start and end a route session
##### - Live geolocation updates during an active trip
##### - Observer map view of active trips
##### - Automatic safe arrival state upon trip completion

## Repository Structure
##### - /app – mobile app screens and navigation
##### - /services – API and platform integrations
##### - /docs – design and security documentation

## Out of Scope (Future Work)
##### - Scheduled and predicted routes
##### - Deviation and timeout alerts
##### - Transport mode detection
##### - Route history analytics
##### - ETA optimization via external API's

##### - Alert customization
  - User-defined thresholds for deviation, inactivity, or time overruns
  - Configurable notification timing and escalation rules

##### - Interactive Check-In Verification
  - Active safety check-ins when anomalies occur (e.g., route deviation, prolonged inactivity)
  - Verification methods such as quick tap confirmation, short code entry, or gesture/pattern input to confirm user safety

##### - Emergency Escalation Integrations
  - Quick-access actions to initiate emergency calls or messages via native device services
  - Configurable escalation paths to trusted contacts or local emergency services
  - Explicit safeguards and disclaimers to prevent accidental activation

Location updates are delivered on a best-effort basis and may be delayed or unavailable due to network, device, or operating system constraints.
