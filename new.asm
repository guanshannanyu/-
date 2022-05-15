assume cs:code

data segment
dw 0,0
dw 200,200
dw 0001b
dw 40
dw 30
dw 10
dw 10
dw 30
dw 0
        mus_freg  dw 330,294,262,294,3 dup (330)     ;Ƶ�ʱ�
                dw 3 dup (294),330,392,392
                dw 330,294,262,294,4 dup (330)
                dw 294,294,330,294,262,-1
        mus_time  dw 6 dup (25),50                   ;���ı�
                dw 2 dup (25,25,50)
                dw 12 dup (25),100

        mus_1 dw 392,330,392,330
		 dw 392,330,262
		 dw 294,349,330,294
		 dw 392
		 dw 392,330,392,330
		 dw 392,330,262
		 dw 294,349,330,294
		 dw 262
		 dw 294,294,349,349
		 dw 330,262,392
		 dw 294,349,330,294
		 dw 392
		 dw 392,330,392,330
		 dw 392,330,262
		 dw 294,349,330,294
		 dw 262
		 dw -1

        time1 dw 3 dup(10h,10h,10h,10h,10h,10h,20h,10h,10h,10h,10h,40h)
		 dw 10h,10h,10h,10h,10h,10h,20h,10h,10h,10h,10h,20h
data ends

;----------���ֵ�ַ��-----------
ADDRESS MACRO A,B
     LEA SI,A
     LEA BP,DS:B
ENDM



stack segment
db 128 dup (0)
stack ends

code segment

start:    

        mov ax,data
        mov ds,ax
        mov ax,stack
        mov ss,ax
        mov sp,128  ;��ʼ�����洢��

        mov ax,0
        mov es,ax

        

try:    
        

        call wujiaoxin

work1:
        address mus_1, time1
        push es:[4*9]
        pop ds:[0]
        push es:[4*9+2]
        pop ds:[2]      ;����ԭ��int 9

        mov word ptr es:[9*4],offset zhongduan
        mov es:[4*9+2],cs

        call music

        push ds:[0]
        pop es:[9*4]
        push ds:[2]
        pop es:[9*4+2]  ;�ظ�ԭ����int 9�жϣ�������޷����õڶ�����֮�ᷢ��Ī������Ĵ���

        mov cx,ds:[20]
        cmp cx,1
        je endl


        jmp work1
endl:
        mov ax,4c00H
        int 21H



wujiaoxin proc

        push si
        push di
        push cx
        push dx
        push ax
        push bx
        push es

work:   mov al,12h      ;640*480 256��ͼ��ģʽ:  
        mov ah,0        ;�������趨��ʾģʽ�ķ������
        mov cx,ds:[4]
        mov bx,ds:[10]
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
        mov bx,ds:[12]
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
        mov bx,ds:[14]
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
        mov bx,ds:[16]
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
        mov bx,ds:[18]
huitu5:
        mov al,ds:[8] 
        mov ah,0ch
        dec cx
        dec dx       
        int 10h
        dec bx
        cmp bx,0
        jne huitu5

        pop es
        pop bx
        pop ax
        pop dx
        pop cx
        pop di
        pop si


        ret
wujiaoxin endp
zhongduan: 
        push si
        push di
        push cx
        push dx
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

        cmp al,01h
        jz  escfuben
jp6:
        cmp al,12h
        jz  enlarge1

jp7:
        cmp al,2eh
        jz  reduce

jp8:
        cmp al,32h
        jz  qingping

jp9:
        pop es
        pop bx
        pop ax
        pop dx
        pop cx
        pop di
        pop si
        
        push bx
        mov bx,ds:[20]
        cmp bx,2
        je chonghua
        cmp bx,1
        je chonghua
        pop bx
        call wujiaoxin

        iret
        
chonghua:
        
        pop bx
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

escfuben:
        mov ds:[20],1
        jmp jp6

enlarge1:

        mov bx,ds:[10]
        add bx,4
        mov ds:[10],bx

        mov bx,ds:[12]
        add bx,3
        mov ds:[12],bx

        mov bx,ds:[14]
        add bx,1
        mov ds:[14],bx

        mov bx,ds:[16]
        add bx,1
        mov ds:[16],bx

        mov bx,ds:[18]
        add bx,3
        mov ds:[18],bx

        jmp jp7

reduce:
        mov bx,ds:[10]
        sub bx,4
        mov ds:[10],bx

        mov bx,ds:[12]
        sub bx,3
        mov ds:[12],bx

        mov bx,ds:[14]
        sub bx,1
        mov ds:[14],bx

        mov bx,ds:[16]
        sub bx,1
        mov ds:[16],bx

        mov bx,ds:[18]
        sub bx,3
        mov ds:[18],bx

        jmp jp8

qingping:
        mov ax,12h
        int 10h
        
        mov ds:[20],2
        jmp jp9

;���������ӳ���
fashen proc 
     push ax
     push bx
     push cx
     push dx
     push di

     mov al, 0b6H
     out 43h, al    ;��ʼ��8253�����ڲ���Ƶ�����跽��

     mov dx, 12h
     mov ax, 348ch
     div di             ;����Ҫ����������Ƶ��

                        ;��8253�е�42H�˿�(Timer2)װ��һ��16λ�ļ���ֵ��533H��895/Ƶ�ʣ����Խ�����Ҫ����������Ƶ�ʡ�
                        ;��ȷ��̫�����ˣ�ȡ�˸�����ֵ 
     
     out 42h, al    
     mov al, ah
     out 42h, al        ;��Ƶ�ʴ���42�˿ڣ��Ա�������Ӧ��ֵ����������
                        


     in al, 61h
     mov ah, al
     or al, 3       ;��PB0,PB1��λ��1����������������
     out 61h, al
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
fashen endp

;��ʱ����
waitf proc 
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
;��������������
music proc 
      xor ax, ax
freg:
      mov di, [si]
      cmp di, 0FFFFH
      je jieshu
      mov bx, ds:[bp]
      
      mov cx,ds:[20]
      cmp cx,1
      je jieshu

      call fashen
      add si, 2
      add bp, 2
      jmp freg
jieshu:
      ret
music endp

code ends
end start