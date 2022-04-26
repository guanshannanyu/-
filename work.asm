assume cs:code

stack segment
db 128 dup (0)
stack ends

code segment

start: 
        
        mov al,12h
        mov ah,0
        mov cx,10
        mov bx,100
        mov dx,10
        int 10h
huitu:
        mov al,1100b
        mov ah,0ch
        inc cx  
        int 10h      
        cmp bx,cx
        
        jne huitu


code ends
end start