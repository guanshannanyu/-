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

;ջ�ζ���
stack segment stack
      db 128 dup(?)
stack ends


;----------���ֵ�ַ��-----------
ADDRESS MACRO A,B
     LEA SI,A
     LEA BP,DS:B
ENDM
;-------------------------------

;����ζ���
code segment
     assume ds:data, ss:stack, cs:code
start:
        mov ax, data
        mov ds, ax
        mov ax, stack
        mov ss, ax
        mov sp, 128
        
        call wujiaoxin
        address mus_freg, mus_time
        call music
        jmp start

exit:     
     mov ah, 4cH
     int 21h

;------------����-------------
gensound proc near
     push ax
     push bx
     push cx
     push dx
     push di

     mov al, 0b6H
     out 43h, al    ;��ʼ��8253�����ڲ���Ƶ�����跽��

     mov dx, 12h
     mov ax, 348ch
     div di         ;����Ҫ����������Ƶ��

     out 42h, al    
     mov al, ah
     out 42h, al    ;��Ƶ�ʴ���42�˿ڣ��Ա�������Ӧ��ֵ

     in al, 61h
     mov ah, al
     or al, 3       ;��PB0,PB1��λ��1��������
     out 61h, al

        pushf
        push ax
        push bx
        push cx
        push dx
        push di
        call zhongduan
        call wujiaoxin
        ; popf
        ; pop es
        ; pop bx
        ; pop ax
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        popf

wait1:
     mov cx, 3314
     call waitf
delay1:
     dec bx
     jnz wait1

     mov al, ah
     out 61h, al

        
     pop di
     pop dx
     pop cx
     pop bx
     pop ax
     ret 
gensound endp

;--------------------------
waitf proc near
      push ax
waitf1:
      in al,61h
      and al,10h
      cmp al,ah
      je waitf1
      mov ah,al
      loop waitf1
      pop ax
      ret
waitf endp
;--------------�������ú���----------------
music proc near
      xor ax, ax
freg:
      mov di, [si]
      cmp di, 0FFFFH
      je end_mus
      mov bx, ds:[bp]
      add si, 2
      add bp, 2
      call gensound
      
      jmp freg
end_mus:
      ret
music endp


wujiaoxin proc
work:   mov al,12h      ;640*480 256��ͼ��ģʽ:  
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
        ret
wujiaoxin endp
zhongduan   proc
        push ax
        push bx
        push es
        in al,60h

        pushf
        pushf
        pop bx
        and bh,11111100b        ;���ж�
        push bx
        popf
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
        ret
        
zhongduan endp

        

up:  
              
        mov dx,ds:[6]    
        sub dx,5
        mov ds:[6],dx   
        ret
        

down:   
        mov dx,ds:[6]    
        add dx,5
        mov ds:[6],dx  
        ret 

left:   
        mov cx,ds:[4]    
        sub cx,5
        mov ds:[4],cx   
        ret

right:  
        mov cx,ds:[4]    
        add cx,5
        mov ds:[4],cx   
        ret

space:  
        mov bx,ds:[8]
        inc bx
        mov ds:[8],bx
        ret


code ends
     end start