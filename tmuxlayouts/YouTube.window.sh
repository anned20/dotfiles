# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "YouTube"

# Run commands.
run_cmd "mpsyt" 0

# Paste text
#send_keys "top"    # paste into active pane
#send_keys "date" 1 # paste into pane 1

# Set active pane.
select_pane 0
