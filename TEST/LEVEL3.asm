
;                       _oo0oo_
;                      o8888888o
;                      88" . "88
;                      (| -_- |)
;                      0\  =  /0
;                    ___/`---'\___
;                  .' \\|     |// '.
;                / \\|||  :  |||// \
;                / _||||| -:- |||||- \
;               |   | \\\  -  /// |   |
;              | \_|  ''\---/''  |_/ |
;               \  .-\__  '-'  ___/-. /
;            ___'. .'  /--.--\  `. .'___
;          ."" '<  `.___\_<|>_/___.' >' "".
;         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
;         \  \ `_.   \_ __\ /__ _/   .-` /  /
;     =====`-.____`.___ \_____/___.-`___.-'=====
;                      `=---='
;
;
;     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;              ���汣��         ����BUG


DATAS SEGMENT
   ;�˴��������ݶδ���
   BLUE DB 0BH
	 RED DB 0CH
	 WHITE DB 0FH
	 ;�����������������
	 DELTX1 DW ?
	 DELTY1 DW ?
	 DELTX2 DW ?
	 DELTY2 DW ?
	 POSX1 DW 80,220,300,440,520
	 POSY1 DW 110,150,180,140,155
	 POSX2 DW 100,245,325,460,550
	 POSY2 DW 130,170,195,160,165 
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
   	
   	COLORSHOW
   	DRAWLEVEL3
      
    MOV AH,1
    INT 21H
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




