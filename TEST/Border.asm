DATAS SEGMENT
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
    WRITESIMPLE MACRO
    	 ;只写首尾
        MOV CX,1
        ;光标移动
        MOV DL,0;首
        MOV AH,2
        INT 10H
        ;写'*'
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        MOV DL,1;首
        MOV AH,2
        INT 10H
        ;写'*'
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        ;光标移动
        MOV DL,79;尾
        MOV AH,2
        INT 10H
        ;写'*'
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
         MOV DL,78;尾
        MOV AH,2
        INT 10H
        ;写'*'
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        INC DH
        ENDM
        
        WRITEFULL MACRO
        MOV CX,80
        ;光标移动
        MOV DL,0
        MOV AH,2
        INT 10H
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        INC DH
        ENDM
    
    
     DRAWBORDER MACRO
    	LOCAL NEXTLINE,FULL,FIN
        XOR DX,DX
        XOR BX,BX
    NEXTLINE:
        CMP DH,0
        JZ FULL
        CMP DH,24
        JZ FULL
        CMP DH,25
        JAE FIN
       	WRITESIMPLE
        JMP NEXTLINE
        ;写满一行
        FULL:
       	WRITEFULL
        JMP NEXTLINE
        FIN:
    ENDM
    
    
    DRAWBORDER
    MOV AH,1
    INT 21H
    MOV AH,4CH
    INT 21H
    
 
CODES ENDS
    END START


