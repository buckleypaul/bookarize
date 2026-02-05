# Bookarize

A book summarization agent that processes books one chapter at a time, tracking progress across runs via a state machine.

## Overview

Bookarize is designed to work with Claude Code to automatically generate detailed chapter-by-chapter summaries and a comprehensive book summary from markdown-formatted books. It processes one chapter per invocation, maintaining state between runs, making it ideal for summarizing long books without hitting context limits.

## Features

- **Incremental Processing**: Summarizes one chapter per run, allowing for processing of books of any length
- **State Persistence**: Tracks progress across runs via `progress.txt`
- **Comprehensive Summaries**: Generates both detailed chapter summaries and a holistic book summary
- **Story Tracking**: Maintains a running narrative of the story so far
- **Flexible Input**: Works with any markdown-formatted book file
- **Autonomous Operation**: No manual intervention required between chapters

## How It Works

Bookarize operates as a state machine with the following flow:

1. **Initialization** (First run)
   - Finds the book file (`.md` format)
   - Locates the first chapter boundary
   - Creates `progress.txt` and `chapter-summary.md`
   - Does NOT summarize on this run

2. **Chapter Summarization** (Subsequent runs)
   - Reads the next chapter from where it left off
   - Generates a detailed summary with POV, short summary, and comprehensive details
   - Appends to `chapter-summary.md`
   - Updates `progress.txt` with the new position and story-so-far

3. **Book Summary Generation** (After all chapters)
   - Generates a holistic book summary in `book-summary.md`
   - Includes overview, characters, plot summary, themes, and notable elements

4. **Completion**
   - Marks the book as complete in `progress.txt`

## Requirements

- [Claude Code](https://claude.ai/code) (claude.ai/code)
- A book in markdown format (`.md` file)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/buckleypaul/bookarize.git
   cd bookarize
   ```

2. Place your book file (`.md` format) in the directory

## Usage

### Using the Shell Script

The easiest way to run bookarize is with the included shell script:

```bash
./bookarize.sh your-book.md
```

This will:
- Copy your book file to a temporary working directory
- Run Claude Code to process chapters
- Continue processing until the entire book is summarized
- Leave the results in a `_bookarize/` directory

### Manual Usage with Claude Code

1. Place your book file in the directory (any `.md` file except `readme.md`, `chapter-summary.md`, or `book-summary.md`)

2. Run Claude Code with the project context:
   ```bash
   claude-code
   ```

3. Give the command to process the book:
   ```
   process book
   ```

4. Repeat step 3 until the book is complete (the agent will tell you when to run again)

## Chapter Detection

Bookarize recognizes chapter boundaries using these patterns:

- `# Chapter 1`
- `## Chapter 3: The Beginning`
- `### Prologue`
- `**Chapter 1**`
- `<b>Chapter 5</b>`
- `**<em>Epilogue</em>**`

Chapters must be on standalone lines (surrounded by blank lines) to be recognized.

## Output Files

- **`progress.txt`** - Tracks the current state and position in the book
- **`chapter-summary.md`** - Contains all chapter summaries, appended incrementally
- **`book-summary.md`** - Final holistic summary of the entire book (generated at the end)

## Example Output Structure

### Chapter Summary Format
```markdown
## Chapter 1: The Beginning

**Point of view:** Third-person limited (John)

**Summary:** John discovers a mysterious letter that changes everything...

### Detailed Summary

[Comprehensive multi-paragraph summary of the chapter]

---
```

### Book Summary Format
```markdown
# Book Summary: your-book.md

## Overview
[1-2 paragraph overview]

## Main Characters
[Character list with descriptions]

## Plot Summary
[Complete plot arc summary]

## Key Themes
- Theme 1: explanation
- Theme 2: explanation

## Notable Elements
[Writing style, structure, unique aspects]
```

## Restarting

To summarize a different book or restart the current one:

```bash
rm progress.txt chapter-summary.md book-summary.md
```

Then place your new book file and run again.

## Technical Details

See `CLAUDE.md` for detailed implementation guidance and `prompt.md` for the complete specification.

## License

MIT

## Author

Paul Buckley
