.data
x: .space 4
y: .space 4
suma: .space 4
formatIntrare: .asciz "%ld %ld"
formatString: .asciz "Suma numerelor x:%ld si y:%ld este: %ld\n"
.text
.global main
main:
push $x
push $y
push $formatIntrare
call scanf
pop %ebx
pop %ebx
pop %ebx

mov x, %eax
add y, %eax
mov %eax, suma

push suma
push x 
pushl y
pushl $formatString
call printf
popl %ebx
popl %ebx

push $0
call fflush
pop %ebx

movl $1, %eax
xorl %ebx, %ebx
int $0x80
