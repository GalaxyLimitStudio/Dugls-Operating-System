%include "boot.inc"
org 0x7c00

mov ax,cs
mov ds,ax
mov es,ax
mov ss,ax
mov fs,ax
mov bx,0x00
mov sp,0x7c00

mov ax,0x0600 
mov cx,0x0000
mov dx,0x184f
int 0x10 

mov ax,mbrstring00
mov bp,ax
mov cx,0x0b
mov dx,0x0000
mov ax,0x1301
mov bx,0x0f
int 0x10
mov ax,mbrstring01
mov bp,ax
mov ax,0x1301
mov cx,0x37
mov dx,0x000b
mov bx,0x09
int 0x10
mov ax,VERSION_NUMBER
mov bp,ax
mov ax,0x1301
mov dx,0x0100
mov cx,VERSION_SIZE
mov bx,0x0f
int 0x10
mov ax,mbrstring20
mov bp,ax
mov ax,0x1301
mov dx,0x0200
mov cx,0x3a
int 0x10

READ_LOADER:
mov dx,0x0080
mov ax,0x08
mov cx,0x0003
mov bx,LOADER_ADDRESS
mov ah,0x02
mov al,LOADER_SIZE
int 0x13
jnc READY_LOADER
mov dx,0x0000
mov ax,0x0000
int 0x13
jmp READ_LOADER

READY_LOADER:
mov ax,mbrdisk
mov bp,ax
mov ax,0x1301
mov dx,0x0300
mov ecx,0x2d
mov bx,0x02
int 0x10

jmp LOADER_ADDRESS

mbrstring00 db "Welcome to "
mbrstring01 db "Dubhe at Galaxy Limit Studio Operating System (DuglsOS)"
%include "version.inc"
mbrstring20 db "The operating system is starting up, please wait a moment."
mbrdisk db "[SUCCESS][MBR] The loader reads successfully."
times 510 - ($ - $$) db 0
db 0x55,0xaa
