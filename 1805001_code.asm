.MODEL SMALL

.STACK 100H
.DATA
x DW ?
y DW ?
z DW ?
a DW ?
b DW 100 DUP(?)
MOV AX, [BP-4]
ADD AX, 1
MOV WORD PTR [BP-4], AX
MOV AX, [BP-4]
MOV WORD PTR [BP-2],AX
