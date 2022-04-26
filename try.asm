assume cs:code
data segment
dw 90,100
dw 190
dw 115
dw 140
dw 165
dw 90
dw 0,0
data ends

stack segment
db 128 dup (0)
stack ends

code segment

start:  
        mov ax,data
        mov ds,ax
        mov ax,stack
        mov ss,ax
        mov sp,128
        mov si,0

        mov ax,0
        mov es,ax       ;安装键盘处理程序时定位

work:   push es:[9*4]
        pop ds:[14]
        push es:[9*4+2]
        pop ds:[16]     ;备份int9中断

        mov word ptr es:[9*4],offset int9
        mov es:[9*4+2],cs       ;安装int9中断向量号

        mov al,12h
        mov ah,0
        mov cx,[si]
        mov bx,[si+4]
        mov dx,[si+2]
        int 10h
huitu:
        mov al,1100b
        mov ah,0ch
        inc cx        
        cmp cx,bx
        int 10h
        jne huitu


step2:
        mov bx,[si+6]
huitu2:
        mov al,1100b
        mov ah,0ch
        dec cx
        inc dx
        cmp bx,cx
        int 10h
        jne huitu2

step3:
        mov bx,[si+8]
huitu3:
        mov al,1100b
        mov ah,0ch
        inc cx
        dec dx
        dec dx
        dec dx
        dec dx
        cmp cx,bx
        int 10h
        jne huitu3

step4:
        mov bx,[si+10]
huitu4:
        mov al,1100b
        mov ah,0ch
        inc cx
        inc dx
        inc dx
        inc dx
        inc dx
        cmp cx,bx
        int 10h
        jne huitu4
jmp1:   jmp step5
jmp2:   jmp work

step5:
        mov bx,[si+12]
huitu5:
        mov al,1100b
        mov ah,0ch
        dec cx
        dec dx
        
        cmp cx,bx
        int 10h
        jne huitu5

s:      mov ax,0
        mov es,ax
        
        jmp work

int9:   
        push ax
        push bx
        push es
        in al,60h

        pushf
        pushf
        pop bx
        and bh,11111100b        ;开中断
        push bx
        popf
        call dword ptr ds:[14]  ;调用原来的int 9获取键盘输入

        cmp al,48h
        je up
        ;cmp al,4bh
        ; jz left
        ; cmp al,50h
        ; jz down
        ; cmp al,40h
        ; jz right

        pop es
        pop bx
        pop ax
        jmp work
        mov ax,4c00h
        int 21h    ;若按其他建则重新开始

up:     
       
        mov si,2
        mov ax,ds:[si]
        add ax,50
        mov ds:[si],ax
        ; push ax
        ; pop [si]
        jmp jmp2



code ends
end start