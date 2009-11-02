# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_snaz_session',
  :secret      => 'df4e044aab35511286d870e2dea9f06f176a0591667a0fdb3ee0e126551b7b266e037c97742a0654dbdd0faa4aaec0a006c0f016d883cc3f9b285268fd1e87fd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
