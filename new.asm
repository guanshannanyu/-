DATAS SEGMENT
    tip db 'please chose: A:broadcast the music B:show the pentagram',0dh,0ah,'$'
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;��ӡ�ַ�����ʾ��Ϣ
    MOV DX,OFFSET TIP
    ;����9���ж�
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
