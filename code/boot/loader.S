%include "system.inc"
org LOADER_ADDRESS

mov bx,0x02
mov ax,loaderready
mov bp,ax
mov ax,0x1301
mov cx,0x26
mov dx,0x0400
int 0x10

mov word [GDTR_ADDRESS],GDT_SIZE
mov dword [GDTR_ADDRESS+0x02],GDT_ADDRESS
mov dword [GDT_PTR],GDT_ADDRESS
mov dword [DWORD_DATA1],0x00000000
call writegdt
call writegdt
mov dword [DWORD_DATA1],0x80007fff
call writegdt
mov dword [DWORD_DATA1],0x0040920b
call writegdt
mov dword [DWORD_DATA1],INT_ADDRESS1
call writegdt
mov dword [DWORD_DATA1],INT_ADDRESS2
call writegdt
mov dword [DWORD_DATA1],INT_CODE1
call writegdt
mov dword [DWORD_DATA1],INT_CODE2
call writegdt
mov dword [DWORD_DATA1],SYS_PARAMETER1
call writegdt
mov dword [DWORD_DATA1],SYS_PARAMETER2
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

mov dword [DWORD_DATA1],iamodeopen
mov word [WORD_DATA1],0x0032
mov dword [DWORD_DATA2],0x00000460
mov byte [BYTE_DATA1],0x02
call writescreen

jmp $

mov dword [GDT_ADDRESS+0x14],INT_ADDRESS2-0x0200

loaderready db "[SUCCESS][LOADER] The loader is ready."
gdtready db "[SUCCESS][LOADER] The GDT is ready."
apinready db "[SUCCESS][LOADER] The A20 was successfully opened."
memoryready db "[SUCCESS][LOADER] The memory reading is complete."
iamodeopen db "[SUCCESS][LOADER] Enter IA-32(32bin/protect) mode."

writegdt:
mov ecx,[GDT_PTR]
mov eax,[DWORD_DATA1]
mov dword [ecx],eax
add cx,0x04
mov [GDT_PTR],ecx
ret

writescreen:
mov eax,0x08
mov es,eax
mov ecx,[DWORD_DATA1]
mov eax,[DWORD_DATA2]
mov dl,[ecx]
add ecx,0x01
mov [DWORD_DATA1],ecx
mov dh,[BYTE_DATA1]
mov word [es:eax],dx
add eax,0x02
mov [DWORD_DATA2],eax
mov ax,[WORD_DATA1]
sub ax,0x01
mov [WORD_DATA1],ax
cmp ax,0x00
jne writememory
ret

movememory:
mov 

endtag:
