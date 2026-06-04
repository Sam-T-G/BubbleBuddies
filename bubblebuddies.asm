;CIS11
;Samuel Gerungan, Tyla Robertson
;Course Project Part 2 - Bubble Sort (Bubble Buddies)


        .ORIG x3000             ; RUBRIC #1 - where the program loads in memory

; init SP - point R6 at the top of the software stack
        LD R6, SPINIT           ; RUBRIC #10 - SP; loaded from .FILL pointer slot below

; prompt - show the "enter 8 numbers" message
        LEA R0, PROMPT          ; LEA = load address, not value
        PUTS                    ; RUBRIC #12 - PUTS prints the string at R0

; read 8 numbers into ARRAY  -- RUBRIC #4 #5 #6
        AND R5, R5, x0          ; i = 0 (AND with 0 is the LC-3 way to clear a reg)
INLOOP  LD R1, ARRAY            ; R1 = base address of ARRAY (x3100)
        ADD R1, R1, R5          ; R1 = &ARRAY[i] (pointer arithmetic)
        JSR READNUM             ; call READNUM, result lands in R0
        STR R0, R1, x0          ; ARRAY[i] = R0 (STR writes R0 at addr R1+0)
        ADD R5, R5, x1          ; i++
        ADD R2, R5, #-8         ; R2 = i - 8 (sets the condition codes)
        BRn INLOOP              ; loop while i < 8 (BRn = branch if negative)

; bubble sort, inlined
; Run 8 passes. Each pass walks j=0..6 comparing ARRAY[j] vs ARRAY[j+1]
; and swaps if out of order. Big values "bubble" to the end each pass.
        AND R4, R4, x0          ; outer i = 0
SORTOUT AND R5, R5, x0          ; inner j = 0 (reset each outer pass)
SORTIN  LD R0, ARRAY            ; R0 = base address of ARRAY
        ADD R0, R0, R5          ; R0 = &ARRAY[j]
        LDR R1, R0, x0          ; R1 = ARRAY[j]   (LDR loads from addr R0+offset)
        LDR R2, R0, x1          ; R2 = ARRAY[j+1] (offset 1 = next word over)
        NOT R3, R2              ; flip every bit of R2 (step 1 of negate)
        ADD R3, R3, x1          ; R3 = -R2 (NOT + 1 = two's complement)
        ADD R3, R1, R3          ; R3 = R1 - R2 (subtraction via add-the-negative)
        BRnz NOSWAP             ; if R1 <= R2 they're already in order, skip swap
        STR R2, R0, x0          ; swap: ARRAY[j]   = smaller value
        STR R1, R0, x1          ;       ARRAY[j+1] = larger value
NOSWAP  ADD R5, R5, x1          ; j++
        ADD R3, R5, #-7         ; R3 = j - 7 (stop after j=6 since j+1 maxes at 7)
        BRn SORTIN              ; loop while j < 7
        ADD R4, R4, x1          ; i++
        ADD R3, R4, #-8         ; R3 = i - 8
        BRn SORTOUT             ; loop while i < 8

; output header - print "Sorted numbers: "
        LEA R0, RESULT
        PUTS                    ; RUBRIC #2

; print ARRAY[0..7] separated by spaces
        AND R5, R5, x0          ; i = 0
OUTLOOP LD R1, ARRAY
        ADD R1, R1, R5          ; R1 = &ARRAY[i]
        LDR R0, R1, x0          ; R0 = ARRAY[i] (the value to print)
        JSR PRINTNUM            ; print it as decimal digits
        LD R0, ASCSPC           ; R0 = ' '
        OUT                     ; RUBRIC #12 - OUT prints the single char in R0
        ADD R5, R5, x1
        ADD R2, R5, #-8
        BRn OUTLOOP

        HALT                    ; RUBRIC #12 - stop the simulator

; READNUM - read one integer 0-100, return in R0.
; Reprompts on bad char, out-of-range, or *10 overflow.
; Stack: push R7 first so RET still works, then any regs we modify.
READNUM ADD R6, R6, #-1         ; RUBRIC #8 - PUSH: make room on the stack
        STR R7, R6, x0          ; RUBRIC #9 - save R7 (return address) first
        ADD R6, R6, #-1
        STR R1, R6, x0          ; save R1 (we'll use it as the accumulator)
        ADD R6, R6, #-1
        STR R2, R6, x0          ; save R2 (temp for char compares)
        ADD R6, R6, #-1
        STR R3, R6, x0          ; save R3 (temp for the *10 multiply)

RNSTART AND R1, R1, x0          ; clear accumulator; we'll build the number up
RNLOOP  GETC                    ; RUBRIC #12 - GETC reads one keyboard char into R0
        OUT                     ; echo it back so the user sees what they typed

; ENTER means the user is done typing this number
        LD R2, NEGNL            ; R2 = -10 (= -ASCII of '\n')
        ADD R2, R0, R2          ; R2 = char - '\n'; if char was '\n', R2 = 0
        BRz RNDONE              ; RUBRIC #6 - if zero, finalize the value

; validate the char is '0'..'9' before treating it as a digit
        LD R2, NEGZERO          ; R2 = -'0' (-48)
        ADD R2, R0, R2          ; RUBRIC #11 - char - '0' = digit value 0-9 if valid
        BRn RNERRC              ; if negative, char was below '0' - invalid
        LD R3, NEGNINE          ; R3 = -'9' (-57)
        ADD R3, R0, R3          ; R3 = char - '9'
        BRp RNERRC              ; if positive, char was above '9' - invalid

; R1 = R1*10 + R2  (LC-3 has no MUL, so we add R1 to itself 9 times)
        ADD R3, R1, x0          ; R3 = R1 (save the value before we start)
        ADD R1, R1, R3          ; 2x
        ADD R1, R1, R3          ; 3x
        ADD R1, R1, R3          ; 4x
        ADD R1, R1, R3          ; 5x
        ADD R1, R1, R3          ; 6x
        ADD R1, R1, R3          ; 7x
        ADD R1, R1, R3          ; 8x
        ADD R1, R1, R3          ; 9x
        ADD R1, R1, R3          ; 10x (R1 is now old R1 * 10)
        BRn RNOFLO              ; RUBRIC #7 - if the multiply went negative, overflow
        ADD R1, R1, R2          ; tack on the new digit
        BR RNLOOP               ; read the next char

RNDONE  LD R2, NEG100
        ADD R2, R1, R2          ; R2 = R1 - 100
        BRp RNERRR              ; RUBRIC #7 - if > 100, fail the range check
        ADD R0, R1, x0          ; copy the validated value into R0 (the return reg)

; POP in reverse order, then RET back to whoever called us
        LDR R3, R6, x0          ; restore R3 from top of stack
        ADD R6, R6, x1          ; RUBRIC #8 - POP: move SP back up
        LDR R2, R6, x0
        ADD R6, R6, x1
        LDR R1, R6, x0
        ADD R6, R6, x1
        LDR R7, R6, x0          ; RUBRIC #9 - restore R7 (return address)
        ADD R6, R6, x1
        RET                     ; jumps to R7 (back to the caller)

; error paths - print a message and re-prompt for the same number
RNERRC  LEA R0, ERRBADC         ; "digits only"
        PUTS
        BR RNSTART              ; reset accumulator, read again
RNERRR  LEA R0, ERRRNG          ; "must be 0-100"
        PUTS
        BR RNSTART
RNOFLO  LEA R0, ERRRNG          ; reuse the range message for overflow
        PUTS
        BR RNSTART

; PRINTNUM (Tyla) - R0 (0-100) in, decimal digits out
; Use the Part 1 pseudocode. PUSH R7 + regs used, POP before RET
; FYI my READNUM labels from previous code are RN + role (RNSTART, RNLOOP, RNDONE)
PRINTNUM RET                    ; stub for printnum

; DATA - RUBRIC #1 (constants, pointer slots, strings)
; Constants up top so the subroutines can reach them with LD.
ASCSPC  .FILL x0020             ; ' ' - space separator between sorted numbers
NEGZERO .FILL xFFD0             ; -'0' (-48) - subtract from a char to get the digit value
NEGNINE .FILL xFFC7             ; -'9' (-57) - used to check char > '9'
NEGNL   .FILL xFFF6             ; -'\n' (-10) - used to detect the ENTER key
NEG100  .FILL xFF9C             ; -100 - for the 0-100 range check

; pointer slots - actual storage at known addresses (easy to view in simulator):
; x3200-x3207  ARRAY (the 8 user numbers, sorted in place)
; x3FF0-x4000  stack region (SP starts at x4000, grows down)
SPINIT  .FILL x4000             ; initial SP value
ARRAY   .FILL x3200             ; ARRAY data lives at x3200-x3207

PROMPT  .STRINGZ "Enter 8 numbers (0-100), press ENTER after each:\n"
RESULT  .STRINGZ "\nSorted numbers: "
ERRRNG  .STRINGZ "\nInvalid: must be 0-100. Try again: "
ERRBADC .STRINGZ "\nInvalid: digits only. Try again: "

        .END
