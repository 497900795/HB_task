DATAS SEGMENT
    ;�˴��������ݶδ���
    ;��ɫ����
     BLUE DB 0BH
     RED DB 0CH
     WHITE DB 0FH
     BLACK DB 0
	 CONSTR DB 'P','r','e','s','s',' ','a','n','y',' ','k','e','y',' ','t','o',' ','c','o','n','t','i','n','u','e'
	 LENCONSTR dw $-CONSTR
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

    DRAWDEADSCENCE MACRO
    	;ͼ��
    	DRAWDEADIMG
    	;����
    	WRITECONWORD
    ENDM
    
    DRAWDEADIMG MACRO
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
    
    DRAWDEADSCENCE

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




