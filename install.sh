#!/usr/bin/bash

exclude=("systemd" ".gitignore" ".git" "$(echo $0 | cut -c3-)")

for string in ${exclude[@]}; do
    exclude_string="$exclude_string|$string"
done
exclude_string=$(echo $exclude_string | cut -c2-)

shopt -s extglob dotglob
GLOBIGNORE=".:.."
echo ./!($exclude_string)

# Copying .config/* files and .rc files
cp -flav ./!($exclude_string) $HOME/

# Copying systemd user service files
cp -fva systemd/user  /usr/lib/systemd
