DATAS SEGMENT
    tip db 'please chose: A:broadcast the music B:show the pentagram',0dh,0ah,'$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;打印字符串提示信息
    MOV DX,OFFSET TIP
    ;调用9号中断
    MOV AH,09H
    INT 21H

    

        push si
        push di
        push cx
        push dx
        push ax
        push bx
        push es


    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
