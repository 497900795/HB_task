DATAS SEGMENT
    ;�˴��������ݶδ���
     NGAME DB '1.NEW GAME$'
     LGAME DB '2.LOAD GAME$'
     EGAME DB '3.EXIT$'
     BLUE DB 0BH
	 RED DB 0CH
	 WHITE DB 0FH  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
    SVRGI MACRO
    	PUSH AX
    	PUSH BX
    	PUSH CX
    	PUSH DX
    ENDM
    
    LDRGI MACRO
    	POP AX
    	POP BX
    	POP CX
    	POP DX
    ENDM
    
    ;����
	CLEAN MACRO
	  	SVRGI
	    MOV AL,0
	    XOR CX,CX
	    MOV DH,25
	    MOV DL,78
	    MOV BH,0
	    MOV AH,7
	    INT 10H
	    LDRGI
    ENDM
    
	WIRTESTARTOPTION MACRO STR,RW	
		MOV BH,0
		MOV DH,RW
		MOV DL,28
		MOV AH,2
		INT 10H
		LEA DX,STR
		MOV AH,9
		INT 21H
	ENDM
	;����ʼҳ��
	DRAWSTART MACRO
		SVRGI
		WIRTESTARTOPTION NGAME,8
	   	WIRTESTARTOPTION LGAME,11
	   	WIRTESTARTOPTION EGAME,14
	   	LDRGI
	   	MOV AH,8
	   	INT 21H
	ENDM
	
	;���Ʊ߿�
	;ֻд��β����
	WRITESIMPLE MACRO
    	;ֻд��β
        MOV CX,1
        ;����ƶ�
        MOV DL,0;��
        MOV AH,2
        INT 10H
        ;д'*'
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        MOV DL,1;��
        MOV AH,2
        INT 10H
        ;д'*'
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        ;����ƶ�
        MOV DL,79;β
        MOV AH,2
        INT 10H
        ;д'*'
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
         MOV DL,78;β
        MOV AH,2
        INT 10H
        ;д'*'
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        INC DH
    ENDM
      
	;д��һ��  
    WRITEFULL MACRO
        MOV CX,80
        ;����ƶ�
        MOV DL,0
        MOV AH,2
        INT 10H
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        INC DH
   ENDM
	;���Ʊ߿�
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
        ;д��һ��
        FULL:
	       	WRITEFULL
	        JMP NEXTLINE
        FIN:
    ENDM
    
    
     ;���ƾ���,��ƴ������
    ;�����ֱ�Ϊ��һ���������,�ڶ����������,��ɫ
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


    ;��ɫ��ͼģʽ
    COLORSHOW MACRO
	    MOV AH,0
	    MOV AL,10H
	    INT 10H
    ENDM
    
    ;������ʾģʽ
    WORDSHOW MACRO
	    MOV AH,0
	    MOV AL,2
	    INT 10H
    ENDM


    ;���Ƶ�һ��
    DRAWLEVEL1 MACRO
    	DRAWRECT 100,60,500,70,BLUE
    	DRAWRECT 100,120,450,130,BLUE
    	DRAWRECT 450,120,460,250,BLUE
    	DRAWRECT 500,60,510,250,BLUE
    	DRAWRECT 460,240,500,250,RED
    ENDM

    ;���Ƶڶ���
    DRAWLEVEL2 MACRO
        DRAWRECT 100,60,500,70,BLUE
        DRAWRECT 100,120,450,130,BLUE
        DRAWRECT 450,120,460,240,BLUE
        DRAWRECT 500,60,510,280,BLUE
        DRAWRECT 300,240,460,250,BLUE
        DRAWRECT 300,280,510,290,BLUE
        DRAWRECT 300,250,310,280,RED
    ENDM
	
	;�Ժ�ĵ���
	DRAWBORDER
	DRAWSTART
	
	MOV AH,1
	INT 21H
	CMP AL,'1'
	JZ STARTGAME
	
	STARTGAME:
	COLORSHOW
	DRAWLEVEL1
    MOV AH,1
    INT 21H
    CLEAN
    DRAWLEVEL2
   
	
	
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



