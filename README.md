# BubbleBuddies — LC-3 Bubble Sort

**Group:** Bubble Buddies
**Members:** Samuel Gerungan, Tyla Robertson
**Advisor:** Kasey Nguyen, PhD
**Course:** CIS 11 — Course Project

## Overview

An LC-3 assembly implementation of the bubble sort algorithm. The program prompts the user for eight integers in the range 0–100, sorts them in ascending order using bubble sort, and prints the sorted result to the console.

## Repository contents

| File | Purpose |
|---|---|
| `PROJECTDOCUMENTATION.docx` | Part 1 project documentation (objectives, business process, user roles, terminology, statement of functionality, scope, performance, usability, enhancement log, appendices, pseudocode, flowchart) |
| `PROJECTDOCUMENTATION.tex` | LaTeX source for a PDF rendering of the documentation, generated from the same content as the `.docx` |
| `flowchart.png` | Program flowchart (input loop, bubble sort, output loop, READNUM and PRINTNUM subroutines), embedded inside `PROJECTDOCUMENTATION.docx` |
| `bubblebuddies.asm` *(coming with Part 3)* | The assembled LC-3 program |
| `LICENSE` | MIT License |
| `README.md` | This file |

## How to run *(applies once Part 3 ships)*

1. Open the LC-3 simulator used in CIS 11.
2. Load `bubblebuddies.asm`, assemble, and start execution at `x3000`.
3. When prompted, enter eight integers (0–100), pressing **Enter** after each.
4. The program prints the eight numbers in ascending order and halts.

## Required test case

| Input | Expected output |
|---|---|
| `11, 8, 2, 17, 6, 4, 3, 21` | `2, 3, 4, 6, 8, 11, 17, 21` |

## Design summary

- **Two subroutines:** `READNUM` reads one number from the keyboard one character at a time until ENTER is pressed; `PRINTNUM` prints one number to the screen as decimal digits. Each subroutine saves the registers it uses at the start and restores them before returning.
- **In the main program:** the input loop (8 numbers), the bubble sort, and the output loop.
- **Register use:** `R0` for values passed to and from subroutines and TRAPs; `R1` and `R2` for the two values being compared in the sort; `R3` for the comparison result; `R4` for the outer sort-loop counter; `R5` for the input, sort, and output loop counters; `R6` as the pointer that walks through the array; `R7` for the return address.

Full design rationale and rubric alignment live in `PROJECTDOCUMENTATION.docx`.

## References

- *Introduction to Computing Systems* (Patt & Patel) — LC-3 architecture reference.
- CIS 11 lecture material and lab exercises (Kasey Nguyen, PhD).
