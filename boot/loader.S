%include "boot.inc"
org LOADER_ADDRESS

mov bx,0x02
mov ax,loaderready
mov bp,ax
mov ax,0x1301
mov cx,0x26
mov dx,0x0400
int 0x10

mov dword [GDT_PTR],GDT_ADDRESS
mov dword [GDT_DATA],0x00000000
call writegdt
call writegdt
mov dword [GDT_DATA],0x8000ffff
call writegdt
mov dword [GDT_DATA],0x0040920b
call writegdt
lgdt [GDTR_ADDRESS]

mov bx,0x02
mov ax,gdtready
mov bp,ax
mov ax,0x1301
mov cx,0x23
mov dx,0x0500
int 0x10

in al,0x92
or al,0x02
out 0x92,al

mov bx,0x02
mov ax,apinready
mov bp,ax
mov ax,0x1301
mov cx,0x32
mov dx,0x600
int 0x10

mov eax,cr0
or eax,0x01
mov cr0,eax

mov dword [SCREEN_DATA],iamodeopen
mov word [SCREEN_SIZE],0x0032
mov dword [SCREEN_DEST],0x00000460
mov byte [SCREEN_COLOR],0x02
mov eax,0x08
mov es,eax
call writememory

jmp $

loaderready db "[SUCCESS][LOADER] The loader is ready."
gdtready db "[SUCCESS][LOADER] The GDT is ready."
apinready db "[SUCCESS][LOADER] The A20 was successfully opened."
memoryready db "[SUCCESS][LOADER] The memory reading is complete."
iamodeopen db "[SUCCESS][LOADER] Enter IA-32(32bin/protect) mode."

GDTR_ADDRESS dw GDT_SIZE
dd GDT_ADDRESS
GDT_PTR dd 0x00
GDT_DATA dd 0x00
SCREEN_DATA dd 0x00
SCREEN_COLOR db 0x00
SCREEN_SIZE dw 0x00
SCREEN_DEST dd 0x00
MEMORY_SIZE dd 0x00

writegdt:
mov ecx,[GDT_PTR]
mov eax,[GDT_DATA]
mov dword [ecx],eax
add cx,0x04
mov [GDT_PTR],ecx
ret

writememory:
mov ecx,[SCREEN_DATA]
mov eax,[SCREEN_DEST]
mov dl,[ecx]
add ecx,0x01
mov [SCREEN_DATA],ecx
mov dh,[SCREEN_COLOR]
mov word [es:eax],dx
add eax,0x02
mov [SCREEN_DEST],eax
mov ax,[SCREEN_SIZE]
sub ax,0x01
mov [SCREEN_SIZE],ax
cmp ax,0x00
jne writememory
ret
