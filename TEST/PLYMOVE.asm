DATAS SEGMENT
    ;此处输入数据段代码
    BLUE DB 0BH
	RED DB 0CH
    WHITE DB 0FH
    BLACK DB 0
    PLYX1 DW 100
    PLYY1 DW 100
    PLYX2 DW 120
    PLYY2 DW 120
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
    
    ;绘制矩形,来拼出场景
    ;参数分别为第一个点的坐标,第二个点的坐标,颜色
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


    ;彩色绘图模式
    COLORSHOW MACRO
	    MOV AH,0
	    MOV AL,10H
	    INT 10H
    ENDM
    
    ;玩家移动,小写wasd控制	
    PLYMOVE MACRO X1,Y1,X2,Y2
    	LOCAL MUP,MDOWN,MLEFT,MRIGHT
   		MOV AH,7
    	INT 21H
    	PUSH AX  	
    	DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,BLACK
    	POP AX
    	CMP AL,'w'
    	JZ MUP
    	CMP AL,'a'
    	JZ MLEFT
    	CMP AL,'s'
    	JZ MDOWN
    	CMP AL,'d'
    	JZ MRIGHT
    	JMP FINSTEP
    	;上
    	MUP:
    	MOVEUP Y1,Y2
    	JMP FINSTEP
    	;下
    	MDOWN:
    	MOVEDOWN Y1,Y2
    	JMP FINSTEP
    	;左
    	MLEFT:
    	MOVELEFT X1,X2
    	JMP FINSTEP
    	;右
    	MRIGHT:
    	MOVERIGHT X1,X2
    	JMP FINSTEP
    	;移动结束,重新画图
    	FINSTEP:
    	DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE
    ENDM
    
    MOVEUP MACRO Y1,Y2
    	MOV CX,Y1
    	MOV DX,Y2
    	SUB CX,5
    	SUB DX,5
    	MOV Y1,CX
    	MOV Y2,DX
    ENDM
    
    MOVEDOWN MACRO Y1,Y2
    	MOV CX,Y1
    	MOV DX,Y2
    	ADD CX,5
    	ADD DX,5
    	MOV Y1,CX
    	MOV Y2,DX
    ENDM
    
    MOVELEFT MACRO X1,X2
    	MOV CX,X1
    	MOV DX,X2
    	SUB CX,5
    	SUB DX,5
    	MOV X1,CX
    	MOV X2,DX
    ENDM
    
    MOVERIGHT MACRO X1,X2
    	MOV CX,X1
    	MOV DX,X2
    	ADD CX,5
    	ADD DX,5
    	MOV X1,CX
    	MOV X2,DX
    ENDM
    
    JUDGE MACRO X,Y
    	LOCAL FINJUD
    	MOV CX,X
    	MOV DX,Y
    	XOR BX,BX
    	
    	;POINT1
    	MOV AH,0DH
    	INT 10H
    	CMP AL,BLUE
    	JZ FINJUD
    	CMP AL,RED
    	JZ FINJUD
    	   	
    	;POINT2
    	PUSH CX
    	ADD CX,20
    	MOV AH,0DH
    	INT 10H
    	CMP AL,BLUE
    	JZ FINJUD
    	CMP AL,RED
    	JZ FINJUD
    	POP CX
    	
    	;POINT3
    	PUSH CX
    	PUSH DX
    	ADC CX,20
    	ADC DX,20
    	MOV AH,0DH
    	INT 10H
    	CMP AL,BLUE
    	JZ FINJUD
    	CMP AL,RED
    	JZ FINJUD
    	POP DX
    	POP CX
    	
    	;POINT4
    	PUSH DX
    	ADC DX,20
    	MOV AH,0DH
    	INT 10H
    	CMP AL,BLUE
    	JZ FINJUD
    	CMP AL,RED
    	JZ FINJUD
    	POP DX
    	

    	FINJUD:
    ENDM
    
    COLORSHOW
    DRAWRECT 200,150,500,200,BLUE
    DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE
   
    NEXTSTEP:
    ;读像素判断
    ;入口参数为左上定点的坐标,出口是某个点读到的死亡颜色或者胜利颜色
    ;死亡 BLUE
    ;胜利 RED
	JUDGE PLYX1,PLYY1
	CMP AL,BLUE
	JZ FIN
    ;不死则移动
    PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
    
    JMP NEXTSTEP
     FIN:    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


