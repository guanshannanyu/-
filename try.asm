assume cs:code
data segment
dw 90,100
dw 190
dw 115
dw 140
dw 165
dw 90
data ends

code segment
start:  
        mov ax,data
        mov ds,ax
        mov si,0
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

code ends
end start