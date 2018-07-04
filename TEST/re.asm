DATA    SEGMENT
    FILE   DB  'C:\1.TXT', 0
    BUF    DB  256   DUP(0)
   HANDLE  DW  ?
 
    ERROR_MESSAGE  DB  0AH, 'ERROR ! $' 
DATA    ENDS
 
CODE    SEGMENT
    ASSUME    CS:CODE, DS:DATA
START:
    MOV   AX, DATA
    MOV   DS, AX
    MOV   DX, OFFSET   FILE
    MOV   AL, 0
    MOV   AH, 3DH           ;打开文件
    INT   21H 
    JC    ERROR 
 
    MOV   HANDLE, AX      
 
    MOV   BX, AX
    MOV   CX, 255
    MOV   DX, OFFSET  BUF
    MOV   AH, 3FH          ;从文件中读255字节→buf
    INT   21H
    JC    ERROR
 
    MOV   BX, AX 
    MOV   BUF[BX], '$'
    MOV   DX, OFFSET   BUF  ;显示文件内容
    MOV   AH, 9
    INT   21H
  
    MOV   BX, HANDLE
    MOV   AH, 3EH           ;关闭文件
    INT   21H    ;    
    JNC   END1
 
ERROR:
    MOV   DX, OFFSET   ERROR_MESSAGE
    MOV   AH, 9
    INT   21H
END1:
    MOV   AH, 4CH
    INT   21H
CODE    ENDS
    END    START
