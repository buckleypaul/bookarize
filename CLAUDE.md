# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bookarize is a **book summarization agent** that processes one chapter per invocation, tracking progress across runs via a state machine. The full specification lives in `prompt.md`.

## How It Works

The agent operates as a state machine driven by `progress.txt`:

1. **No progress.txt** → Initialize: find the `.md` book file, locate the first chapter boundary, create `progress.txt` and `chapter-summary.md`. Do NOT summarize on this run.
2. **progress.txt with ENDING_LINE/BOOK_FILE** → Summarize the next chapter, append to `chapter-summary.md`, update `progress.txt` with new ending line and story-so-far.
3. **progress.txt with CHAPTERS_COMPLETE** → Generate `book-summary.md` from all chapter summaries, then mark `BOOK_COMPLETE`.
4. **progress.txt with BOOK_COMPLETE** → Reply "Already complete." and stop.

## Key Files (Runtime)

- `progress.txt` — State tracking: `ENDING_LINE`, `BOOK_FILE`, `---STORY_SO_FAR---` section, and completion flags
- `chapter-summary.md` — Accumulated per-chapter summaries (appended each run)
- `book-summary.md` — Final holistic book summary (generated once at the end)
- The book file — any `.md` file in the directory excluding the three above and `readme.md`

## Chapter Detection

A chapter boundary is a **standalone line** (surrounded by blank lines or at file start) that, after stripping markdown formatting (`#`, `**`, `*`, `__`, `_`) and HTML tags, starts with `Chapter`, `Prologue`, or `Epilogue` (case-insensitive). Lines containing these words mid-paragraph are NOT boundaries.

## Critical Rules

- Exactly **one chapter per invocation** — no more, no less
- Initialization run does **no summarization** — only sets up state files
- Content after the last chapter marker: summarize if >20 non-blank lines, skip if ≤20
- Story-so-far is a **coherent growing narrative** (2-4 sentences per chapter), not bullet points
- Operate autonomously — never ask the user for input
