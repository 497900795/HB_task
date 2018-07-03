DATAS SEGMENT
    ;此处输入数据段代码 
	BLUE DB 0BH
	RED DB 0CH
	WHITE DB 0FH
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
    
    
    
    ;绘制边框
;只写首尾的行
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
;写满一行  
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
;绘制边框
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
    
    
    DRAWRECT MACRO X1,Y1,X2,Y2,COLOR
    	LOCAL ROW,COL
    	XOR BX,BX
    	XOR CX,CX
    	XOR DX,DX
    	MOV AH,0CH
    	MOV AL,COLOR
    	MOV DX,Y1
    	MOV CX,X1
    	ROW:
    		MOV CX,X1
    		COL:INT 10H
    			INC CX
    			CMP CX,X2
    			JB COL
    		INC DX
    		CMP DX,Y2
    		JB ROW
    ENDM
    
    ;绘制第一关
    DRAWLEVEL1 MACRO
    	DRAWRECT 100,60,500,70,BLUE
    	DRAWRECT 100,120,450,130,BLUE
    	DRAWRECT 450,120,460,250,BLUE
    	DRAWRECT 500,60,510,250,BLUE
    	DRAWRECT 460,240,500,250,RED
    ENDM
    
    
    COLORSHOW MACRO
	    MOV AH,0
	    MOV AL,10H
	    INT 10H
    ENDM
    
    WORDSHOW MACRO
	    MOV AH,0
	    MOV AL,2
	    INT 10H
    ENDM
    
   
    COLORSHOW
    DRAWLEVEL1
    
    
    MOV AH,1
   	INT 21H
   
    
   
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



