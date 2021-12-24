import readline
import rlcompleter
import atexit
import os


# Make exit work as expected
type(exit).__repr__ = type(exit).__call__

# tab completion
readline.parse_and_bind('tab: complete')

# History file - attempt XDG directory: fallback $HOME
try:
    histfile = os.path.join(os.environ['XDG_STATE_HOME'], 'python_history')
except KeyError:
    histfile = os.path.join(os.environ['HOME'], '.python_history')

try:
    readline.read_history_file(histfile)
except IOError:
    pass
atexit.register(readline.write_history_file, histfile)
del os, histfile, readline, rlcompleter
