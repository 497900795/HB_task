DATAS SEGMENT
    ;�˴��������ݶδ���  
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
    
    
    DRAWBORDER
    MOV AH,1
    INT 21H
    MOV AH,4CH
    INT 21H
    
 
CODES ENDS
    END START


