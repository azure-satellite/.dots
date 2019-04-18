import atexit
import os
import readline

histfile = os.path.join(
    os.path.expanduser("~"), os.path.join(".cache", "python_history"))

try:
    readline.read_history_file(histfile)
    h_len = readline.get_current_history_length()
except FileNotFoundError:
    open(histfile, 'wb').close()
    h_len = 0


def save(prev_h_len, histfile):
    import readline
    new_h_len = readline.get_current_history_length()
    readline.set_history_length(1000)
    try:
        # python3
        readline.append_history_file(new_h_len - prev_h_len, histfile)
    except AttributeError:
        # python2
        readline.write_history_file(histfile)


atexit.register(save, h_len, histfile)

del os, atexit, readline, save, histfile
