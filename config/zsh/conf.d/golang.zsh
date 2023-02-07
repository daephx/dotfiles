# DO NOT EDIT: installed by update-golang.sh

if ! echo "$PATH" | grep -Eq "(^|:)/usr/local/go/bin($|:)"
then
    export PATH=$PATH:/usr/local/go/bin
fi
if ! echo "$PATH" | grep -Eq "(^|:)$HOME/go/bin($|:)"
then
    export PATH=$PATH:$HOME/go/bin
fi
# update-golang.sh: end
