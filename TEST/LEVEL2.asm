DATAS SEGMENT
    ;�˴��������ݶδ���
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
    
    DRAWLEVEL2 MACRO
    	DRAWRECT 100,60,500,70,BLUE
    	DRAWRECT 100,120,450,130,BLUE
    	DRAWRECT 450,120,460,240,BLUE
    	DRAWRECT 500,60,510,280,BLUE
    	DRAWRECT 300,240,460,250,BLUE
    	DRAWRECT 300,280,510,290,BLUE
    	DRAWRECT 300,250,310,280,RED
    ENDM
    
    COLORSHOW
    DRAWLEVEL2
    
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
