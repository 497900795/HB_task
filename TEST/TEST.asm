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
     ;���������ñ���
     CONSTR DB 'P','r','e','s','s',' ','a','n','y',' ','k','e','y',' ','t','o',' ','c','o','n','t','i','n','u','e'
	 LENCONSTR dw $-CONSTR
	 ;�ؿ���д
	 HANDLE DW ?
	 LEVEL DB ?,0
	 FILENAME DB 'LEVEL.TXT'  
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
      MOV DL,11           ;������,����Ϊ�����
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN4,BX                  
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
    
    
    ;------------------------------
    ;��ʼ����
    STARTPAGE:
    CALL INITSTARTPAGE
    ;ѡ��1,����Ϸ
    MOV AH,7
    INT 21H
    ;1.��ʼ��Ϸ
    CMP AL,'1'
    JZ PLAYLEVEL1
    ;2.������Ϸ
    CMP AL,'2'
   	JZ LOADGAEM
    ;3.�˳���Ϸ
    CMP AL,'3'
    JZ EXITGAME   
    
    ;��һ��
    PLAYLEVEL1:
    MOV AL,'1'
    MOV LEVEL,AL
    CALL WRITEFILE
   	CALL INITLEVEL1
    NEXTSTEP_L1:
    JUDGE PLYX1,PLYY1
    CMP AL,BLUE
    JZ DEAD
    CMP AL,RED
    JZ PLAYLEVEL2
    ;�������ƶ�
    CALL PLYOPERATE
    JMP NEXTSTEP_L1
        
    ;�ڶ���
    PLAYLEVEL2:
    MOV AL,'2'
    MOV LEVEL,AL
    CALL WRITEFILE
   	CALL INITLEVEL2
    NEXTSTEP_L2:
    JUDGE PLYX1,PLYY1
    CMP AL,BLUE
    JZ DEAD
    CMP AL,RED
    JZ PLAYLEVEL3
    ;�������ƶ�
    PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
    JMP NEXTSTEP_L2
        
    ;������
    PLAYLEVEL3:
    MOV AL,'3'
    MOV LEVEL,AL
    CALL WRITEFILE
   	CALL INITLEVEL3
    NEXTSTEP_L3:
    JUDGE PLYX1,PLYY1
    CMP AL,BLUE
    JZ DEAD
    CMP AL,RED
    JZ VICTORY
    ;�������ƶ�
    PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
    JMP NEXTSTEP_L3 
      
    ;ʤ������
    VICTORY:
    CALL DRAWVICTORYSCENCE 
    MOV AH,7
    INT 21H
    CALL CLEAN
    JMP STARTPAGE
        
    ;��������
    DEAD:
    CALL DRAWDEADSCENCE
    MOV AH,7
    INT 21H
    CALL CLEAN
    JMP STARTPAGE
    
    ;���ؽ���
    LOADGAEM:
    CALL READFILE
    CALL LOADLEVEL
    
    ;�˳���Ϸ  
    EXITGAME:   
    MOV AH,4CH
    INT 21H
  ;-------------------------------
  
    ;��ɫ��ͼģʽ
    COLORSHOW PROC
        MOV AH,0
        MOV AL,10H
        INT 10H
        RET
   	COLORSHOW ENDP
    
    ;������ʾģʽ
    WORDSHOW PROC
        MOV AH,0
        MOV AL,2
        INT 10H
        RET
    WORDSHOW ENDP
  	
  	;���Ʊ߿�
    ;ֻд��β����
    WRITESIMPLE PROC
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
        RET
    WRITESIMPLE ENDP
      
    ;д��һ��  
    WRITEFULL PROC
        MOV CX,80
        ;����ƶ�
        MOV DL,0
        MOV AH,2
        INT 10H
        MOV AL,'*'
        MOV AH,0AH
        INT 10H
        INC DH
        RET
   WRITEFULL ENDP
   
    ;���Ʊ߿�
     DRAWBORDER PROC
        XOR DX,DX
        XOR BX,BX
        NEXTLINE:
        CMP DH,0
       	JZ FULL
        CMP DH,24
        JZ FULL
        CMP DH,25
        JAE FIN
        CALL WRITESIMPLE
        JMP NEXTLINE
        ;д��һ��
        FULL:
        CALL WRITEFULL
        JMP NEXTLINE
        FIN:
    DRAWBORDER ENDP
  
    ;����ʼҳ��
    DRAWSTART PROC
        SVRGI
        WRITESTARTOPTION NGAME,8
        WRITESTARTOPTION LGAME,11
        WRITESTARTOPTION EGAME,14
        LDRGI
        RET
    DRAWSTART ENDP
  
  ;��ʼ����ʼ���� 
  INITSTARTPAGE PROC
	  	CALL WORDSHOW
	    CALL DRAWBORDER
	    CALL DRAWSTART
	    RET
  INITSTARTPAGE ENDP
  
  
    ;���Ƶ�һ��
    DRAWLEVEL1 PROC
        DRAWRECT 100,60,500,70,BLUE
        DRAWRECT 100,120,450,130,BLUE
        DRAWRECT 450,120,460,250,BLUE
        DRAWRECT 500,60,510,250,BLUE
        DRAWRECT 460,240,500,250,RED
        RET
   	DRAWLEVEL1 ENDP
    
	INITLEVEL1 PROC
	  	CALL COLORSHOW
	  	CALL CLEAN
	  	CALL SETPOSL1;����λ�÷ŵ���һ�ؿ�ʼλ��
	  	DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE  
	  	CALL DRAWLEVEL1
	  	RET
	 INITLEVEL1 ENDP
  
    ;���Ƶڶ���
    DRAWLEVEL2 PROC
        DRAWRECT 100,60,500,70,BLUE
        DRAWRECT 100,120,450,130,BLUE
        DRAWRECT 450,120,460,240,BLUE
        DRAWRECT 500,60,510,280,BLUE
        DRAWRECT 300,240,460,250,BLUE
        DRAWRECT 300,280,510,290,BLUE
        DRAWRECT 300,250,310,280,RED
        RET
    DRAWLEVEL2 ENDP
    
    
    ;��������ϰ�,�㷨Ϊ��ȡ���������
    ;�����ĸ������,��Ϊ�ϰ����ƫ��
    ;ƫ��ʩ�ӵ����ԭʼֵ
    LOADBARRIER PROC
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
        RET 
    LOADBARRIER ENDP
    
    ;������,ƽ��������������ϰ�
    DRAWLEVEL3 PROC
        ;�Ȼ��Ʊ߿�,����������ϰ���
        DRAWRECT 80,100,600,110,BLUE
        DRAWRECT 80,220,600,230,BLUE
        DRAWRECT 590,110,600,220,RED
        CALL LOADBARRIER
        RET
    DRAWLEVEL3 ENDP
      
  INITLEVEL2 PROC
	    CALL COLORSHOW
	    CALL CLEAN
	    CALL SETPOSL2;����λ�÷ŵ��ڶ��ؿ�ʼλ��
	    DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE
	    CALL DRAWLEVEL2
	    RET
  INITLEVEL2 ENDP
  
  INITLEVEL3 PROC
	    CALL COLORSHOW
	    CALL CLEAN
	    CALL SETPOSL3;����λ�÷ŵ������ؿ�ʼλ��
	    DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE
	    CALL DRAWLEVEL3
	    RET
  INITLEVEL3 ENDP
  
  PLYOPERATE PROC
	  	PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
	  	RET
  PLYOPERATE ENDP
  
	;��������
	DRAWDEADSCENCE PROC
		;����
		CALL CLEAN
		;ͼ��
		CALL DRAWDEADIMG
		;����
		CALL WRITECONWORD
		RET
	DRAWDEADSCENCE ENDP

	;ʤ������
	DRAWVICTORYSCENCE PROC
		;����
		CALL CLEAN	
		;ͼ��
		CALL DRAWVICTORYIMG
		;����
		CALL WRITECONWORD
		RET
	DRAWVICTORYSCENCE ENDP
	
	;����
    CLEAN PROC
        SVRGI
        MOV AL,0
        XOR CX,CX
        MOV DH,25
        MOV DL,78
        MOV BH,0
        MOV AH,7
        INT 10H
        LDRGI
        RET
    CLEAN ENDP
    
    READFILE PROC
    	LEA DX,FILENAME
    	MOV AL,2
   		MOV CX,0
    	MOV AH,3DH
    	INT 21H
    	
    	MOV HANDLE,AX
   		LEA DX,LEVEL
    	MOV BX,HANDLE
    	MOV CX,1
    	MOV AH,3FH
    	INT 21H

    	MOV AH,3EH
    	INT 21H
    	RET
    READFILE ENDP
   
   	WRITEFILE PROC
 		MOV AH, 3DH
		MOV AL, 1
		LEA DX, FILENAME
		INT 21H
		MOV HANDLE,ax
    
    	MOV AH,40H
    	MOV BX,HANDLE
    	LEA DX,LEVEL
    	MOV CX,1
    	INT 21H
   
    	MOV AH,3EH
    	MOV BX,HANDLE
    	INT 21H
   		RET
   	WRITEFILE ENDP
   	
   	 ;���ص��ض��ؿ�
    LOADLEVEL PROC
    MOV AL,'1'
    CMP AL,LEVEL
    JZ PLAYLEVEL1
    MOV AL,'2'
    CMP AL,LEVEL
    JZ PLAYLEVEL2
    MOV AL,'3'
    CMP AL,LEVEL
    JZ PLAYLEVEL3
    LOADLEVEL ENDP

	;��һ�س�ʼ������
    SETPOSL1 PROC
        MOV AX,95
        MOV PLYX1,AX
        MOV AX,85
        MOV PLYY1,AX
        MOV AX,115
        MOV PLYX2,AX
        MOV AX,105
        MOV PLYY2,AX
        RET
    SETPOSL1 ENDP 
    
    ;�ڶ��س�ʼ������
    SETPOSL2 PROC
        MOV AX,95
        MOV PLYX1,AX
        MOV AX,85
        MOV PLYY1,AX
        MOV AX,115
        MOV PLYX2,AX
        MOV AX,105
        MOV PLYY2,AX
        RET
    SETPOSL2 ENDP
    
    ;�����س�ʼ������
    SETPOSL3 PROC
        MOV AX,80
        MOV PLYX1,AX
        MOV AX,160
        MOV PLYY1,AX
        MOV AX,100
        MOV PLYX2,AX
        MOV AX,180
        MOV PLYY2,AX
        RET
    SETPOSL3 ENDP
    
    
    ;ͼ��
    DRAWDEADIMG PROC
    	;��ĸD,1��
     	DRAWRECT 80,100,100,210,BLUE
        DRAWRECT 80,100,150,120,BLUE
        DRAWRECT 140,110,160,210,BLUE
        DRAWRECT 80,200,150,220,BLUE
        ;��ĸE
        DRAWRECT 200,100,280,120,BLUE
        DRAWRECT 200,150,280,170,BLUE
        DRAWRECT 200,200,280,220,BLUE
        DRAWRECT 200,100,220,220,BLUE
        ;��ĸA
        DRAWRECT 330,100,420,120,BLUE
        DRAWRECT 330,150,420,170,BLUE
        DRAWRECT 330,100,350,220,BLUE
        DRAWRECT 400,100,420,220,BLUE
        ;��ĸD,2��
     	DRAWRECT 470,100,540,120,BLUE
        DRAWRECT 470,200,540,220,BLUE
        DRAWRECT 530,110,550,210,BLUE
        DRAWRECT 470,100,490,220,BLUE
        RET
    DRAWDEADIMG ENDP
    
    ;����
    WRITECONWORD PROC
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
        RET
    WRITECONWORD ENDP
    
    DRAWVICTORYIMG PROC
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
    	RET
    DRAWVICTORYIMG ENDP
        
CODES ENDS
    END START
