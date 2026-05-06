#!/bin/bash
# Usage: ./script.sh <dir> <dest_path>

set -euo pipefail

DIR="$1"
DEST_PATH="$2"

mkdir -p "$DEST_PATH"

find "$DIR" -maxdepth 1 -type f -name "*.html" | while IFS= read -r file; do
    filename=$(basename "$file" .html)

    perl -0777 -ne '
        while (/<app-cours.*?>.*?<\/app-cours>/sg) {
            print "$&\n"
        }
    ' "$file" > "$DEST_PATH/$filename.md"

done
