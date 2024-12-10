.data
mem: .space 2048
textnrop: .asciz "Numarul de operatii de efectuat este: %ld\n"
text: .asciz "introdu nr de op:"
formatInput: .asciz "%ld\n"
aux: .long 0
nrop: .space 4
x: .space 2
addt: .asciz "ADD\n"
get: .asciz "GET\n"
delete: .asciz "DELETE\n"
defrag: .asciz "DEFRAGMENTATION\n"
.text


.global main
main:
lea mem, %edi
mov aux, %ecx

init:
mov %ecx, aux
movl $0, (%edi, %ecx)
mov aux, %ecx
add $1, %ecx
cmp $1024, %ecx
jle init

#Introducere nr de operatii
push $nrop
push $formatInput
call scanf
pop %ebx
pop %ebx
xor %ecx, %ecx
mov %ecx, aux

# Numarul de operatii de efectuat este:
push nrop
push $textnrop
call printf
pop %edx
pop %edx

# loop intrare
mov nrop, %ecx
loopintrare:
mov %ecx, nrop
push $x
push $formatInput
call scanf
pop %edx
pop %edx
xor %edx, %edx
mov x, %edx
mov x, %eax
cmp $1, %eax
je addet
cmp $2, %edx
je getet
cmp $3, %edx
je delet
cmp $4, %edx
je defraget
jmp revintrare

addet:
push $addt
call printf
pop %ebx
jmp revintrare

getet:
push $get
call printf
pop %ebx
jmp revintrare

delet:
push $delete
call printf
pop %ebx
jmp revintrare

defraget:
push $defrag
call printf
pop %ebx
jmp revintrare

revintrare:
mov nrop, %ecx
sub $1, %ecx 
cmp $0, %ecx
jne loopintrare

pushl $0
call fflush
popl %ebx

exit:
movl $1, %eax
xorl %ebx, %ebx
int $0x80
