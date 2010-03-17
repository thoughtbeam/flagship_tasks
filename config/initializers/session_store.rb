# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_tasks_session',
  :secret => 'b82acf84cfcc6824edfbd48b65809aff09b6a0bf2e716c9b99ffb6497c2b0bdbd46dc2c87e65d1dcd6be2ea8e73eed11e4251c0d81db0cafbc55e2355abaf9c9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
