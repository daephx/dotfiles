# Lua Settings
# Trailing ;; ensure that default path will be appended by Lua
LUA_LIB="$XDG_LOCAL_HOME/lib/lua" # Custom module location
export LUA_PATH="$LUA_PATH;$LUA_LIB/?.lua;$LUA_LIB/?/init.lua;;"
export LUA_CPATH="$LUA_CPATH;$LUA_LIB/?.so;$LUA_LIB/?/init.so;;"
# export LUAROCKS_CONFIG="$XDG_CONFIG_HOME/luarocks/config*.lua"
unset LUA_LIB
