DATAS SEGMENT
    ;�˴��������ݶδ���
    ;��ʼ������Ϣ
     NGAME DB '1.NEW GAME$'
     LGAME DB '2.LOAD GAME$'
     EGAME DB '3.EXIT$'
     ;��ɫ����
     BLUE DB 0BH
	 RED DB 0CH
	 WHITE DB 0FH
	 BLACK DB 0 
     ;�����������������
     DELTX1 DW ?
     DELTY1 DW ?
     DELTX2 DW ?
     DELTY2 DW ?
     POSX1 DW 80,220,300,440,520
     POSY1 DW 110,150,180,140,155
     POSX2 DW 100,245,325,460,550
     POSY2 DW 130,170,195,160,165
     ;���λ�ÿ���,��1,2��
     PLYX1 DW 95
     PLYY1 DW 85
     PLYX2 DW 115
     PLYY2 DW 105  
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
    
	WRITESTARTOPTION MACRO STR,RW	
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
		WRITESTARTOPTION NGAME,8
	   	WRITESTARTOPTION LGAME,11
	   	WRITESTARTOPTION EGAME,14
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


;�����
    RANNUM MACRO RAN1,RAN2,RAN3,RAN4
      ;��һ��
      MOV AH,0             ;��ʱ�Ӽ�����ֵ
      INT 1AH
      MOV AX,DX            
      AND AH,3
      MOV DL,21          ;������,����Ϊ�����
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN1,BX
      ;�ڶ���
      MOV AH,0             ;��ʱ�Ӽ�����ֵ
      INT 1AH
      MOV AX,DX            
      AND AH,3
      MOV DL,26           ;������,����Ϊ�����
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN2,BX
      ;������
      MOV AH,0             ;��ʱ�Ӽ�����ֵ
      INT 1AH
      MOV AX,DX            
      AND AH,3
      MOV DL,11          ;������,����Ϊ�����
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN3,BX   
      ;���Ĵ�
      MOV AH,0             ;��ʱ�Ӽ�����ֵ
      INT 1AH
      MOV AX,DX            
      AND AH,3
      MOV DL,16           ;������,����Ϊ�����
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN4,BX                  
    ENDM
   
    ;��������ϰ�,�㷨Ϊ��ȡ���������
    ;�����ĸ������,��Ϊ�ϰ����ƫ��
    ;ƫ��ʩ�ӵ����ԭʼֵ
    LOADBARRIER MACRO
        LOCAL NEXTPOINT
        RANNUM DELTX1,DELTX2,DELTY1,DELTY2
        XOR SI,SI
        
        NEXTBARRIER:
        MOV AX,DELTX1
        ADD AX,POSX1[SI]
        MOV POSX1[SI],AX
        MOV AX,DELTY1
        ADD AX,POSY1[SI]
        MOV POSY1[SI],AX
        MOV AX,DELTX2
        ADD AX,POSX2[SI]
        MOV POSX2[SI],AX
        MOV AX,DELTY2
        ADD AX,POSY2[SI]
        MOV POSY2[SI],AX
        
        
        DRAWRECT POSX1[SI],POSY1[SI],POSX2[SI],POSY2[SI],BLUE
        INC SI
        INC SI
        CMP SI,10
        JB NEXTBARRIER 
    ENDM
    
    ;������,ƽ��������������ϰ�
    DRAWLEVEL3 MACRO
        ;�Ȼ��Ʊ߿�,����������ϰ���
        DRAWRECT 80,100,600,110,BLUE
        DRAWRECT 80,220,600,230,BLUE
        DRAWRECT 590,110,600,220,RED
        LOADBARRIER
    ENDM
    
      ;����ƶ�,Сдwasd���� 
    PLYMOVE MACRO X1,Y1,X2,Y2
        LOCAL MUP,MDOWN,MLEFT,MRIGHT,FINSTEP
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
        ;��
        MUP:
        MOVEUP Y1,Y2
        JMP FINSTEP
        ;��
        MDOWN:
        MOVEDOWN Y1,Y2
        JMP FINSTEP
        ;��
        MLEFT:
        MOVELEFT X1,X2
        JMP FINSTEP
        ;��
        MRIGHT:
        MOVERIGHT X1,X2
        JMP FINSTEP
        ;�ƶ�����,���»�ͼ
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
    
    ;��һ�س�ʼ������
    SETPOSL1 MACRO
    	MOV AX,95
    	MOV PLYX1,AX
    	MOV AX,85
    	MOV PLYY1,AX
    	MOV AX,115
    	MOV PLYX2,AX
    	MOV AX,105
    	MOV PLYY2,AX
    ENDM 
    
    ;�ڶ��س�ʼ������
    SETPOSL2 MACRO
    	MOV AX,95
    	MOV PLYX1,AX
    	MOV AX,85
    	MOV PLYY1,AX
    	MOV AX,115
    	MOV PLYX2,AX
    	MOV AX,105
    	MOV PLYY2,AX
    ENDM
    
     ;�����س�ʼ������
    SETPOSL3 MACRO
    	MOV AX,80
    	MOV PLYX1,AX
    	MOV AX,160
    	MOV PLYY1,AX
    	MOV AX,100
    	MOV PLYX2,AX
    	MOV AX,180
    	MOV PLYY2,AX
    ENDM
    
	;�Ժ�ĵ���
	;��ʼ����
	DRAWBORDER
	DRAWSTART
	;ѡ��1,����Ϸ
	MOV AH,7
	INT 21H
	CMP AL,'1'
	JZ STARTGAME
	
	STARTGAME:
	COLORSHOW
	;��һ��
	PLAYLEVEL1:
	CLEAN
	SETPOSL1
	DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE	
	DRAWLEVEL1
	NEXTSTEP_L1:
	JUDGE PLYX1,PLYY1
	CMP AL,BLUE
	JZ DEAD
	CMP AL,RED
	JZ PLAYLEVEL2
    ;�������ƶ�
    PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
    JMP NEXTSTEP_L1
	
    PLAYLEVEL2:
    CLEAN
    SETPOSL2;����λ�÷ŵ��ڶ��ؿ�ʼλ��
    DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE	
    DRAWLEVEL2
    NEXTSTEP_L2:
	JUDGE PLYX1,PLYY1
	CMP AL,BLUE
	JZ DEAD
	CMP AL,RED
	JZ PLAYLEVEL3
    ;�������ƶ�
    PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
    JMP NEXTSTEP_L2
    
    PLAYLEVEL3:
    CLEAN
    SETPOSL3
    DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE	
    DRAWLEVEL3
    NEXTSTEP_L3:
	JUDGE PLYX1,PLYY1
	CMP AL,BLUE
	JZ DEAD
	CMP AL,RED
	JZ DEAD
    ;�������ƶ�
    PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
    JMP NEXTSTEP_L3
    
	DEAD:
	
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START






