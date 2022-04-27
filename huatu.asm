assume cs:code

data segment
dw 0,0
dw 200,200
db 0001b
mus_freg  dw 330,294,262,294,3 dup (330)     ;Ƶ�ʱ�
               dw 3 dup (294),330,392,392
               dw 330,294,262,294,4 dup (330)
               dw 294,294,330,294,262,-1
     mus_time  dw 6 dup (25),50                   ;���ı�
               dw 2 dup (25,25,50)
               dw 12 dup (25),100
data ends

; datanew segment
     
;      mus_freg  dw 330,294,262,294,3 dup (330)     ;Ƶ�ʱ�
;                dw 3 dup (294),330,392,392
;                dw 330,294,262,294,4 dup (330)
;                dw 294,294,330,294,262,-1
;      mus_time  dw 6 dup (25),50                   ;���ı�
;                dw 2 dup (25,25,50)
;                dw 12 dup (25),100
; datanew ends

stack segment
db 200 dup (0)
stack ends

code segment


;----------���ֵ�ַ��-----------
ADDRESS MACRO A,B
     LEA SI,A
     LEA BP,DS:B
ENDM

start:    
        mov ax,data
        mov ds,ax
        mov ax,stack
        mov ss,ax
        mov sp,200  ;��ʼ�����洢��

        mov ax,0
        mov es,ax
        push es:[4*9]
        pop ds:[0]
        push es:[4*9+2]
        pop ds:[2]      ;����ԭ��int 9

        mov word ptr es:[9*4],offset int9
        mov es:[4*9+2],cs
        call wujiaoxin

        
    
     ;address mus_freg, mus_time
     ;call music

        jmp start

wujiaoxin proc
work:  
        mov ax,data
        mov ds,ax
        mov al,12h      ;640*480 256��ͼ��ģʽ:  
        mov ah,0        ;�������趨��ʾģʽ�ķ������
        mov cx,ds:[4]
        mov bx,200
        mov dx,ds:[6]
        int 10h
huitu:
        mov al,ds:[8]    ;������ɫ
        mov ah,0ch      ;д��ͼ��
        inc cx  
        int 10h              
        dec bx
        cmp bx,0
        jne huitu
        
step2:
        mov bx,145
huitu2:
        mov al,ds:[8] 
        mov ah,0ch
        dec cx
        inc dx
      
        int 10h
        dec bx
        cmp bx,0
        jne huitu2

step3:
        mov bx,50
huitu3:
        mov al,ds:[8] 
        mov ah,0ch
        inc cx
        dec dx
        dec dx
        dec dx
        dec dx
        
        int 10h
        dec bx
        cmp bx,0
        jne huitu3

step4:
        mov bx,50
huitu4:
        mov al,ds:[8] 
        mov ah,0ch
        inc cx
        inc dx
        inc dx
        inc dx
        inc dx
        
        int 10h
        dec bx
        cmp bx,0
        jne huitu4

step5:
        mov bx,145
huitu5:
        mov al,ds:[8] 
        mov ah,0ch
        dec cx
        dec dx       
        int 10h
        dec bx
        cmp bx,0
        jne huitu5

wujiaoxin endp


int9:   
        push ax
        push bx
        push es
        mov ax,0
        in al,60h

        pushf
        pushf
        pop bx
        and bh,11111100b        ;���ж�
        push bx
        popf
        push ax
        mov ax,data
        mov ds,ax
        pop ax
        
        call dword ptr ds:[0]  ;����ԭ����int 9��ȡ��������,��Ȼ�޷�����

        cmp al,48h
        je up

        cmp al,4bh
        jz left
        cmp al,50h
        jz down
        cmp al,4dh
        jz right

        cmp al,39h
        jz space

        jmp work
        

up:     
              
        mov dx,ds:[6]    
        sub dx,5
        mov ds:[6],dx   
        jmp work

down:   
        mov dx,ds:[6]    
        add dx,5
        mov ds:[6],dx   
        jmp work

left:   
        mov cx,ds:[4]    
        sub cx,5
        mov ds:[4],cx   
        jmp work

right:  
        mov cx,ds:[4]    
        add cx,5
        mov ds:[4],cx   
        jmp work

space:  
        mov bx,ds:[8]
        inc bx
        mov ds:[8],bx
        jmp work

exit:     
     mov ah, 4cH
     int 21h



code ends
end start