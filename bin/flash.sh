#!/usr/bin/env bash
#
# Flash the latest successful GitHub Actions build onto one half of the keyboard.
#
# Put the target half into bootloader mode first (left: Mod+macro1, right: Mod+macro3).
# The half then shows up as a USB drive containing INFO_UF2.TXT.
#
# Usage: bin/flash.sh [left|right] [--variant clique|no-clique] [--timeout SECONDS] [--dry-run]

set -euo pipefail

BRANCH="MyDvorakKeymap_BasedV3.0-Japanese"

side="left"
variant="clique"
timeout=60
dry_run=false

usage() {
    sed -n '3,8p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
    case "$1" in
        left|right) side="$1" ;;
        --variant) variant="$2"; shift ;;
        --timeout) timeout="$2"; shift ;;
        --dry-run) dry_run=true ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

case "$variant" in
    clique|no-clique) ;;
    *) echo "--variant must be clique or no-clique" >&2; exit 2 ;;
esac

# Resolve the fork from origin. gh may otherwise pick the upstream remote.
origin_url=$(git -C "$(dirname "$0")/.." remote get-url origin)
repo="${origin_url#https://github.com/}"
repo="${repo#git@github.com:}"
repo="${repo%.git}"

run_info=$(gh run list -R "$repo" -w Build -b "$BRANCH" -s success -L 1 \
    --json databaseId,headSha,displayTitle \
    -q '.[0] | "\(.databaseId)\t\(.headSha[0:7])\t\(.displayTitle)"')
if [ -z "$run_info" ]; then
    echo "No successful Build run found on $BRANCH." >&2
    exit 1
fi
IFS=$'\t' read -r run_id run_sha run_title <<< "$run_info"
echo "Build run: $run_id ($run_sha $run_title)"

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

gh run download "$run_id" -R "$repo" -n "firmware-$variant" -D "$work_dir"
uf2=$(find "$work_dir" -name "*-$side.uf2" | head -n 1)
if [ -z "$uf2" ]; then
    echo "No *-$side.uf2 in artifact firmware-$variant." >&2
    exit 1
fi
echo "Firmware: $(basename "$uf2") (firmware-$variant)"

find_drives() {
    local letter
    for letter in d e f g h i j k l m n o p q r s t u v w x y z; do
        if [ -f "/$letter/INFO_UF2.TXT" ]; then
            echo "/$letter"
        fi
    done
}

if [ "$dry_run" = true ]; then
    timeout=0
fi

drives=$(find_drives)
waited=0
while [ -z "$drives" ] && [ "$waited" -lt "$timeout" ]; do
    if [ "$waited" -eq 0 ]; then
        echo "Waiting up to ${timeout}s for the $side half in bootloader mode..."
    fi
    sleep 1
    waited=$((waited + 1))
    drives=$(find_drives)
done

if [ -z "$drives" ]; then
    echo "No UF2 bootloader drive found." >&2
    [ "$dry_run" = true ] && exit 0
    exit 1
fi
if [ "$(echo "$drives" | wc -l)" -gt 1 ]; then
    echo "Multiple UF2 bootloader drives found. Connect only one half:" >&2
    echo "$drives" >&2
    exit 1
fi

drive="$drives"
echo "Bootloader drive: $drive"
sed 's/^/  /' "$drive/INFO_UF2.TXT"

if [ "$dry_run" = true ]; then
    echo "Dry run: would copy $(basename "$uf2") to $drive"
    exit 0
fi

# The drive disconnects as soon as the copy completes.
# Some systems report an error at that moment even though flashing succeeded.
if cp "$uf2" "$drive/"; then
    echo "Copied. The $side half reboots with the new firmware."
else
    echo "cp reported an error. This can be spurious when the drive detaches after flashing." >&2
    echo "Check whether the $side half rebooted and works." >&2
    exit 1
fi
