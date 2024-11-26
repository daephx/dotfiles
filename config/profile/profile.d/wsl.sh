#!/usr/bin/env bash
# WSL: Environment configuration for Windows Subsystem for Linux (WSL).
# Add extra commands and improve performance by removing unnecessary interop.

# WSL: Enabled in windows subsystem
read -r var &> /dev/null < /proc/version
if test "${var#*microsoft}" = "$var"; then
  return
fi

# Attempt to reclaim memory cache from WSL Guest
alias drop_cache="sudo sh -c \
  \"echo 3 >'/proc/sys/vm/drop_caches' \
  && swapoff -a && swapon -a \
  && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
