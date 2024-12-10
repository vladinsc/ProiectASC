.data
formatInput: .asciz "%d\n"
n: .space 2
.text
.global main
main: 
push $n
push $formatInput
call scanf
pop %edx
pop %edx

push n
push $formatInput
call printf
pop %edx
pop %edx

push $0
call fflush
pop %edx

mov $1, %eax
mov $0, %ebx
int $0x80