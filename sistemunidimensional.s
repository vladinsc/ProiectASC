.data
mem: .space 1000
formatString: .asciz "%ld\n"
aux: .long 0
.text

.global main
main:
lea mem, %edi
mov aux, %ecx

loop3:
mov %ecx, aux
mov %ecx, (%edi, %ecx, 1)
mov (%edi, %ecx, 1), %edx
push %edx
push $formatString
call printf
pop %ebx
pop %ebx
mov aux, %ecx
add $1, %ecx
cmp $1001, %ecx
jne loop3


exit:
movl $1, %eax
xorl %ebx, %ebx
int $0x80
