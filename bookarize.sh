#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ITERATION=0

echo "Starting Bookarize"

while true; do
  ITERATION=$((ITERATION + 1))
  echo ""
  echo "==============================================================="
  echo "  Bookarize - Iteration $ITERATION"
  echo "==============================================================="

  OUTPUT=$(claude --dangerously-skip-permissions --model sonnet -p "$(cat "$SCRIPT_DIR/prompt.md")" 2>&1 | tee /dev/stderr) || true

  if echo "$OUTPUT" | grep -q "BOOK_SUMMARY_COMPLETE"; then
    echo ""
    echo "Book summarization complete!"
    echo "Completed in $ITERATION iterations."
    exit 0
  fi

  if echo "$OUTPUT" | grep -q "Already complete"; then
    echo ""
    echo "Book was already complete. Delete progress.txt to restart."
    exit 0
  fi

  echo "Iteration $ITERATION complete. Continuing..."
  sleep 2
done
