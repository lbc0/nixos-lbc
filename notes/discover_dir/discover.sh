#!/usr/bin/env bash
#
# discover_dir.sh - Walk a directory tree and dump everything into one note file.
#
# What it does:
#   1. Writes a `tree` listing of the target directory to the note file.
#   2. Walks the directory subdirectory by subdirectory (in sorted order),
#      and for every regular file, appends its full path and its content
#      to the same note file.
#
# Usage:
#   ./discover_dir.sh <directory> [output_note_file]
#
# Example:
#   ./discover_dir.sh ./myproject notes.txt
#
set -euo pipefail

TARGET_DIR="${1:-.}"
OUT_FILE="${2:-discovery_notes.txt}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: '$TARGET_DIR' is not a directory." >&2
    exit 1
fi

# Resolve to an absolute path so headers/paths in the note are unambiguous
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# Start fresh
: > "$OUT_FILE"

# Resolve the note file to an absolute path so we can skip it below if it
# happens to live inside the directory being scanned (avoids cat'ing the
# note file into itself).
OUT_FILE_ABS="$(cd "$(dirname "$OUT_FILE")" && pwd)/$(basename "$OUT_FILE")"

echo "==================================================" >> "$OUT_FILE"
echo "DIRECTORY STRUCTURE: $TARGET_DIR" >> "$OUT_FILE"
echo "Generated: $(date)" >> "$OUT_FILE"
echo "==================================================" >> "$OUT_FILE"
echo >> "$OUT_FILE"

# Step 1: tree listing (fall back to a find-based tree if `tree` isn't installed)
if command -v tree >/dev/null 2>&1; then
    # --charset=ascii avoids Unicode box-drawing characters, which can come
    # out garbled (mojibake) on systems/terminals with a non-UTF-8 locale.
    tree --charset=ascii "$TARGET_DIR" >> "$OUT_FILE" 2>/dev/null || tree "$TARGET_DIR" >> "$OUT_FILE"
else
    echo "(note: 'tree' command not found, using a find-based fallback)" >> "$OUT_FILE"
    find "$TARGET_DIR" | sed -e "s|^$TARGET_DIR|.|" -e 's|[^/]*/| |g' >> "$OUT_FILE"
fi

echo >> "$OUT_FILE"
echo "==================================================" >> "$OUT_FILE"
echo "FILE CONTENTS" >> "$OUT_FILE"
echo "==================================================" >> "$OUT_FILE"

# Step 2: walk subdirectory by subdirectory (sorted), file by file (sorted)
# Find every directory under TARGET_DIR (including itself), sorted by path.
while IFS= read -r dir; do
    echo >> "$OUT_FILE"
    echo "--------------------------------------------------" >> "$OUT_FILE"
    echo "DIRECTORY: $dir" >> "$OUT_FILE"
    echo "--------------------------------------------------" >> "$OUT_FILE"

    # Only files directly inside this directory (so we still go dir by dir),
    # sorted alphabetically.
    find "$dir" -maxdepth 1 -type f | sort | while IFS= read -r file; do
        # Skip the note file itself if it lives in the scanned directory
        if [ "$file" = "$OUT_FILE_ABS" ]; then
            continue
        fi

        echo >> "$OUT_FILE"
        echo ">>> FILE: $file" >> "$OUT_FILE"
        echo "--------------------" >> "$OUT_FILE"

        # Detect binary files without relying on the external `file` command
        # (not available on all systems, e.g. Git Bash / MSYS on Windows).
        # grep -I treats binary content as "no match", so this is a portable check.
        if grep -Iq '' "$file" 2>/dev/null; then
            cat "$file" >> "$OUT_FILE"
        else
            echo "[binary file - content skipped]" >> "$OUT_FILE"
        fi
        echo >> "$OUT_FILE"
    done
done < <(find "$TARGET_DIR" -type d | sort)

echo
echo "Done. Notes written to: $OUT_FILE"
