# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
#session_root "~/Projects/sibben"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "sibben"; then

  # Load a defined window layout.
  load_window "mox-members"
  load_window "sibbenapi"
  load_window "mox-admin"
  load_window "onderdelenzoeker"
  load_window "YouTube"
  load_window "irc"

  # Select the default active window on session creation.
  select_window 0

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
