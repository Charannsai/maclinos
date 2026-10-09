#!/bin/bash
# =============================================================================
# MaclinOS Package Manifest Collector
# =============================================================================
# Collects installed package list with versions for reproducibility.
#
# Usage: ./scripts/collect-manifest.sh [output-file]
# =============================================================================

set -euo pipefail

OUTPUT="${1:-manifest-$(date +%Y%m%d).txt}"

echo "MaclinOS Package Manifest"
echo "Generated: $(date -Iseconds)"
echo "System: $(uname -a)"
echo "Debian: $(cat /etc/debian_version 2>/dev/null || echo 'unknown')"
echo ""
echo "--- Installed Packages ---"

dpkg-query -W -f='${Package}\t${Version}\t${Status}\n' | \
    grep 'install ok installed' | \
    cut -f1-2 | \
    sort > "$OUTPUT"

TOTAL=$(wc -l < "$OUTPUT")
echo "Total packages: $TOTAL"
echo "Manifest saved to: $OUTPUT"
