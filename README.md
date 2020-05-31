# Extend-Basic--C64

Its been a long time since I started coding and over the past 30+ years if found that the continual challenges and enjoyment that coding has brought me to be a great way to past the time. Recently I was cleaning up some old paperwork and came across some early code of mine written from the Commodore 64 in 6502 assembler and I thought I’d share.

This Commodore 64 source code (6510 assembly language, Kick Assembler format) adds four new commands to the standard Commodore BASIC v2 and will give you an idea of how to add your own commands to the BASIC via a wedge.

On the C64 you can intercept the BASIC command prompt READY. and jump to your own subroutine. In this example, I use ! key as the wedge. If the ! is missing it returns to BASIC normally. If the ! is found then the subroutine will check the next available characters to determine whether they match a known command.

By using the wedge method you can also access these new BASIC commands within your own BASIC programs. Compile the above code then load and execute by typing SYS49152. Follow this by typing NEW.

10 REM BASIC TEST PROGRAM USING NEW COMMANDS
20 !CLS
30 !TXT,1
40 FOR X = 0 TO 255
50 FOR T = 0 TO 15
50 !BRD,T : !SCR,T
60 NEXT T
70 NEXT X
80 !HELP
