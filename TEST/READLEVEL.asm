DATAS SEGMENT
    ;�˴��������ݶδ���
    FILENAME DB 'L.TXT',0
    BUF DB ?
    STT DB 'OK$'
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
    
    LEA DX,FILENAME
    MOV AL,0
    MOV CX,0
    MOV AH,3CH
    INT 21H
    
    LEA DX,BUF
    MOV BX,AX
    MOV CX,1
    MOV AH,3FH
    INT 21H
    
    CMP DX,'5'
    JZ OKK
    
    FIN:
    MOV AH,3EH
    INT 21H
    
    MOV AH,1
    INT 21H
    
    MOV AH,4CH
    INT 21H
    
    OKK:
	LEA DX,STT
    MOV AH,9
    INT 21H
    JMP FIN
    
CODES ENDS
    END START
