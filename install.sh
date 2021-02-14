#!/usr/bin/bash

exclude=(".gitignore" ".git" "$(echo $0 | cut -c3-)")

for string in ${exclude[@]}; do
    exclude_string="$exclude_string|$string"
done
exclude_string=$(echo $exclude_string | cut -c2-)

shopt -s extglob dotglob
GLOBIGNORE=".:.."
echo ./!($exclude_string)

cp -flav ./!($exclude_string) $HOME/
