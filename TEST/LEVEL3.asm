
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
;              佛祖保佑         永无BUG


DATAS SEGMENT
   ;此处输入数据段代码
   BLUE DB 0BH
	 RED DB 0CH
	 WHITE DB 0FH
	 ;第三关生成随机数用
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
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
    
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
    
    ;文字显示模式
    WORDSHOW MACRO 
	    MOV AH,0
	    MOV AL,2
	    INT 10H
    ENDM
    
    
    
    ;随机数
    RANNUM MACRO RAN1,RAN2,RAN3,RAN4
      ;第一次
      MOV AH,0             ;读时钟计数器值
      INT 1AH
      MOV AX,DX            
      AND AH,3
      MOV DL,21          ;做除法,余数为随机数
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN1,BX
      ;第二次
      MOV AH,0             ;读时钟计数器值
      INT 1AH
      MOV AX,DX            
      AND AH,3
      MOV DL,26           ;做除法,余数为随机数
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN2,BX
      ;第三次
      MOV AH,0             ;读时钟计数器值
      INT 1AH
      MOV AX,DX            
      AND AH,3
      MOV DL,11          ;做除法,余数为随机数
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN3,BX   
      ;第四次
      MOV AH,0             ;读时钟计数器值
      INT 1AH
      MOV AX,DX            
      AND AH,3
      MOV DL,16           ;做除法,余数为随机数
      DIV DL
      XOR BX,BX
      MOV BL,AH
      MOV RAN4,BX                  
    ENDM
   
    ;加载随机障碍,算法为获取随机数种子
    ;产生四个随机数,作为障碍物的偏移
    ;偏移施加到点的原始值
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
    
   	;第三关,平行线内随机生成障碍
   	DRAWLEVEL3 MACRO
   		;先绘制边框,后生成随机障碍物
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




