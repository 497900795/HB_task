DATAS SEGMENT
    ;此处输入数据段代码
    BLUE DB 0BH
    RED DB 0CH
    WHITE DB 0FH
    BLACK DB 0
    CONSTR DB 'P','r','e','s','s',' ','a','n','y',' ','k','e','y',' ','t','o',' ','c','o','n','t','i','n','u','e'
	LENCONSTR dw $-CONSTR  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
        ;彩色绘图模式
    COLORSHOW MACRO
	    MOV AH,0
	    MOV AL,10H
	    INT 10H
    ENDM
    
    ;文字显示模式
    WORDSHOW MACRO
	    MOV AH,0
	    MOV AL,2
	    INT 10H
    ENDM

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
    
    ;此处输入代码段代码
    DRAWVICTORYSCENCE MACRO
    	;图形
    	DRAWVICTORYIMG
    	;文字
    	WRITECONWORD
    ENDM
    
    DRAWVICTORYIMG MACRO
    	;W
    	DRAWRECT 100,80,120,220,BLUE
    	DRAWRECT 140,80,160,220,BLUE
    	DRAWRECT 180,80,200,220,BLUE
    	DRAWRECT 100,200,200,220,BLUE
    	;I
    	DRAWRECT 250,80,330,100,BLUE
    	DRAWRECT 280,80,300,220,BLUE
    	DRAWRECT 250,200,330,220,BLUE
    	;N
    	DRAWRECT 380,80,400,220,BLUE
    	DRAWRECT 380,80,430,100,BLUE
    	DRAWRECT 430,80,450,220,BLUE
    	DRAWRECT 450,200,480,220,BLUE
    	DRAWRECT 480,80,500,220,BLUE
    ENDM
    
    WRITECONWORD MACRO
    	LOCAL WRITENEXT
        XOR BX,BX
        MOV DH,22
        MOV DL,25
        MOV AH,2
        INT 10H
        
        MOV CX,LENCONSTR
        XOR SI,SI
        WRITENEXT:
        MOV AH,2
        MOV DL,CONSTR[SI]
        INT 21H
        INC SI
        LOOP WRITENEXT
    ENDM
    
    COLORSHOW
    DRAWVICTORYSCENCE
    
    MOV AH,7
    INT 21H
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START








