# WSL: Enabled in windows subsystem
read -r var < /proc/version
if ! echo "$var == *wsl" 1> /dev/null; then
  return
fi

# Attempt to reclaim memory cache from WSL Guest
alias drop_cache="sudo sh -c \
  \"echo 3 >'/proc/sys/vm/drop_caches' \
  && swapoff -a && swapon -a \
  && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
