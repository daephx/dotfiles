# Lua Settings: Configure Lua and Luarocks paths.

# Add custom Lua library path to the Lua search paths.
# The trailing ;; ensures that the default paths are also included by Lua.
LUA_LIB="${XDG_LOCAL_HOME:-$HOME/.local}/lib/lua" # Custom module location
export LUA_PATH="$LUA_PATH;$LUA_LIB/?.lua;$LUA_LIB/?/init.lua;;"
export LUA_CPATH="$LUA_CPATH;$LUA_LIB/?.so;$LUA_LIB/?/init.so;;"
unset LUA_LIB # Unset temporary variable after use.

# Set the custom configuration path for Luarocks.
export LUAROCKS_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/luarocks/config*.lua"
