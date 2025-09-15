#!/bin/bash
# smoke_test.sh - Minimal smoke test

set -e

# Use Serial Experiments Soprano - stable, known title
echo "https://www.youtube.com/watch?v=BNr1mlYRgq8" | pbcopy

# Run dlzap
./dlzap

# Check Serial Experiments Soprano file exists (title may vary)
soprano_file=$(find "$HOME/Downloads/dlzap/" -name "*Serial Experiments Soprano*" -name "*.mp4" | head -1)
[ -n "$soprano_file" ] || { echo "✗ Serial Experiments Soprano file not found"; exit 1; }

# Check file is reasonable size
size=$(stat -f%z "$soprano_file" 2>/dev/null || stat -c%s "$soprano_file")
[ $size -gt 100000 ] || { echo "✗ File too small"; exit 1; }

echo "✓ Smoke test passed"