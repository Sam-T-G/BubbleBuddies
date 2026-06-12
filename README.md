# BubbleBuddies — LC-3 Bubble Sort

**Group:** Bubble Buddies
**Members:** Samuel Gerungan, Tyla Robertson
**Advisor:** Kasey Nguyen, PhD
**Course:** CIS 11 — Course Project

## Overview

An LC-3 assembly implementation of bubble sort. The program prompts the user for eight integers in the range 0–100, sorts them in ascending order, and prints the result to the console.

## Repository contents

| File | Purpose |
|---|---|
| `bubblebuddies.asm` | LC-3 source for the bubble sort program |
| `PROJECTDOCUMENTATION.docx` | Project documentation: objectives, pseudocode, flowchart, design summary |
| `PROJECTDOCUMENTATION.tex` | LaTeX source for the same documentation |
| `BubbleBuddiesDocumentation.pdf` | PDF rendering of the documentation |
| `flowchart.png` | Program flowchart, also embedded in the documentation |
| `LICENSE` | MIT License |
| `README.md` | This file |

## How to run

1. Open the LC-3 simulator used in CIS 11.
2. Load `bubblebuddies.asm`, assemble, and start execution at `x3000`.
3. When prompted, enter eight integers (0–100), pressing **Enter** after each.
4. The program prints the eight numbers in ascending order and halts.

## Required test case

| Input | Expected output |
|---|---|
| `11, 8, 2, 17, 6, 4, 3, 21` | `2, 3, 4, 6, 8, 11, 17, 21` |

## Design summary

Two subroutines do the per-number work. `READNUM` reads one integer from the keyboard a character at a time until ENTER, validating range and digit characters. `PRINTNUM` prints one integer as decimal digits. The main program holds the input loop, the bubble sort, and the output loop. Each subroutine saves the registers it uses on entry and restores them before returning.

Full design rationale lives in `PROJECTDOCUMENTATION.docx`.

## References

- *Introduction to Computing Systems* (Patt & Patel) — LC-3 architecture reference.
- CIS 11 lecture material and lab exercises (Kasey Nguyen, PhD).
