DATAS SEGMENT
    ;此处输入数据段代码
    ;开始界面信息
     NGAME DB '1.NEW GAME$'
     LGAME DB '2.LOAD GAME$'
     EGAME DB '3.EXIT$'
     ;颜色变量
     BLUE DB 0BH
     RED DB 0CH
     WHITE DB 0FH
     BLACK DB 0 
     ;第三关生成随机数用
     DELTX1 DW ?
     DELTY1 DW ?
     DELTX2 DW ?
     DELTY2 DW ?
     POSX1 DW 80,220,300,440,520
     POSY1 DW 110,150,180,140,155
     POSX2 DW 100,245,325,460,550
     POSY2 DW 130,170,195,160,165
     ;玩家位置控制,第1,2关
     PLYX1 DW 95
     PLYY1 DW 85
     PLYX2 DW 115
     PLYY2 DW 105
     ;死亡场景用变量
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
    ;此处输入代码段代码
    
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
    
    ;清屏
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
    
    ;画开始页面
    DRAWSTART MACRO
        SVRGI
        WRITESTARTOPTION NGAME,8
        WRITESTARTOPTION LGAME,11
        WRITESTARTOPTION EGAME,14
        LDRGI
    ENDM
    
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
    
    ;文字显示模式
    WORDSHOW MACRO
        MOV AH,0
        MOV AL,2
        INT 10H
    ENDM


    ;绘制第一关
    DRAWLEVEL1 MACRO
        DRAWRECT 100,60,500,70,BLUE
        DRAWRECT 100,120,450,130,BLUE
        DRAWRECT 450,120,460,250,BLUE
        DRAWRECT 500,60,510,250,BLUE
        DRAWRECT 460,240,500,250,RED
    ENDM

    ;绘制第二关
    DRAWLEVEL2 MACRO
        DRAWRECT 100,60,500,70,BLUE
        DRAWRECT 100,120,450,130,BLUE
        DRAWRECT 450,120,460,240,BLUE
        DRAWRECT 500,60,510,280,BLUE
        DRAWRECT 300,240,460,250,BLUE
        DRAWRECT 300,280,510,290,BLUE
        DRAWRECT 300,250,310,280,RED
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
    
      ;玩家移动,小写wasd控制 
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
    
    ;第一关初始化方块
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
    
    ;第二关初始化方块
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
    
     ;第三关初始化方块
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
    
    ;死亡场景
 	DRAWDEADSCENCE MACRO
    	;图形
    	DRAWDEADIMG
    	;文字
    	WRITECONWORD
    ENDM
    ;图形
    DRAWDEADIMG MACRO
    	;字母D,1号
     	DRAWRECT 80,100,100,210,BLUE
        DRAWRECT 80,100,150,120,BLUE
        DRAWRECT 140,110,160,210,BLUE
        DRAWRECT 80,200,150,220,BLUE
        ;字母E
        DRAWRECT 200,100,280,120,BLUE
        DRAWRECT 200,150,280,170,BLUE
        DRAWRECT 200,200,280,220,BLUE
        DRAWRECT 200,100,220,220,BLUE
        ;字母A
        DRAWRECT 330,100,420,120,BLUE
        DRAWRECT 330,150,420,170,BLUE
        DRAWRECT 330,100,350,220,BLUE
        DRAWRECT 400,100,420,220,BLUE
        ;字母D,2号
     	DRAWRECT 470,100,540,120,BLUE
        DRAWRECT 470,200,540,220,BLUE
        DRAWRECT 530,110,550,210,BLUE
        DRAWRECT 470,100,490,220,BLUE
    ENDM
    ;文字
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
    
    ;对宏的调用
    ;开始界面
    STARTPAGE:
    WORDSHOW
    DRAWBORDER
    DRAWSTART
    ;选项1,新游戏
    MOV AH,7
    INT 21H
    ;1.开始游戏
    CMP AL,'1'
    JZ STARTGAME
    ;2.继续游戏
    ;3.退出游戏
    CMP AL,'3'
    JZ EXITGAME
    
    STARTGAME:
    COLORSHOW
    ;第一关
    PLAYLEVEL1:
   	CALL INITLEVEL1
    NEXTSTEP_L1:
    JUDGE PLYX1,PLYY1
    CMP AL,BLUE
    JZ DEAD
    CMP AL,RED
    JZ PLAYLEVEL2
    ;不死则移动
    CALL PLYOPERATE
    JMP NEXTSTEP_L1
    
    ;第二关
    PLAYLEVEL2:
   	CALL INITLEVEL2
    NEXTSTEP_L2:
    JUDGE PLYX1,PLYY1
    CMP AL,BLUE
    JZ DEAD
    CMP AL,RED
    JZ PLAYLEVEL3
    ;不死则移动
    PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
    JMP NEXTSTEP_L2
    
    ;第三关
    PLAYLEVEL3:
   	CALL INITLEVEL3
    NEXTSTEP_L3:
    JUDGE PLYX1,PLYY1
    CMP AL,BLUE
    JZ DEAD
    CMP AL,RED
    JZ VICTORY
    ;不死则移动
    PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
    JMP NEXTSTEP_L3
    
    ;胜利结束
    VICTORY:
    CLEAN
    DRAWVICTORYSCENCE 
    MOV AH,7
    INT 21H
    CLEAN
    JMP STARTPAGE
    
    ;死亡结束
    DEAD:
    CLEAN
    DRAWDEADSCENCE
    MOV AH,7
    INT 21H
    CLEAN
    JMP STARTPAGE
    
    EXITGAME:   
    MOV AH,4CH
    INT 21H
    
  INITLEVEL1 PROC
  	CLEAN
  	SETPOSL1;方块位置放到第一关开始位置
  	DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE  
  	DRAWLEVEL1
  	RET
  INITLEVEL1 ENDP
  
  INITLEVEL2 PROC
   CLEAN
   SETPOSL2;方块位置放到第二关开始位置
   DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE
   DRAWLEVEL2
   RET
  INITLEVEL2 ENDP
  
  INITLEVEL3 PROC
   CLEAN
   SETPOSL3;方块位置放到第三关开始位置
   DRAWRECT PLYX1,PLYY1,PLYX2,PLYY2,WHITE
   DRAWLEVEL3
   RET
  INITLEVEL3 ENDP
  
  PLYOPERATE PROC
  	PLYMOVE PLYX1,PLYY1,PLYX2,PLYY2
  	RET
  PLYOPERATE ENDP
    
CODES ENDS
    END START








  



