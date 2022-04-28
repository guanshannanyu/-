assume cs:code

data segment
dw 0,0
dw 200,200
db 0001b
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
        mov sp,128  ;初始化各存储区

        mov ax,0
        mov es,ax

try:    push es:[4*9]
        pop ds:[0]
        push es:[4*9+2]
        pop ds:[2]      ;备份原来int 9,好像用不到，不改了

        mov word ptr es:[9*4],offset zhongduan
        mov es:[4*9+2],cs

        call wujiaoxin
        ;call zhongduan
        push ds:[0]
        pop es:[9*4]
        push ds:[2]
        pop es:[9*4+2]
        jmp try

; int9:
;         call zhongduan
;         jmp try

wujiaoxin proc
work:   mov al,12h      ;640*480 256的图形模式:  
        mov ah,0        ;是用来设定显示模式的服务程序
        mov cx,ds:[4]
        mov bx,200
        mov dx,ds:[6]
        int 10h
huitu:
        mov al,ds:[8]    ;设置颜色
        mov ah,0ch      ;写入图像
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
        ret
wujiaoxin endp
zhongduan: 
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
        call dword ptr ds:[0]  ;调用原来的int 9获取键盘输入,不然无法输入

        cmp al,48h
        jz up

jp1:

        cmp al,4bh
        jz left
jp2:
        cmp al,50h
        jz down
jp3:
        cmp al,4dh
        jz right
jp4:
        cmp al,39h
        jz space
jp5:
        pop es
        pop bx
        pop ax
        call wujiaoxin
        iret
        


        

up:  
              
        mov dx,ds:[6]    
        sub dx,5
        mov ds:[6],dx   
        jmp jp1
     
left:  
        mov cx,ds:[4]    
        sub cx,5
        mov ds:[4],cx   
        jmp jp2

down:  
        mov dx,ds:[6]    
        add dx,5
        mov ds:[6],dx  
        jmp jp3 



right: 
        mov cx,ds:[4]    
        add cx,5
        mov ds:[4],cx   
        jmp jp4

space:
        mov bx,ds:[8]
        inc bx
        mov ds:[8],bx
        jmp jp5

code ends
end start