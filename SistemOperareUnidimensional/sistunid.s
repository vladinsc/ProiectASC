.data
formatInput: .asciz "%hu\n"
formatOutput: .asciz "%hu\n"
stringEroareIndiceOp: .asciz "Eroare indice operatie\n"
indiceop: .word 0
eroareSpatiuAdaugare: .asciz "Nu exsita pentru a adauga fisierul.\n"
formatAfisareADD: .asciz "%ld: (%ld, %ld)\n"
formatInterval: .asciz "(%hu, %hu)\n"
xxx: .space 4
nrop: .word 0
nropadd: .word 0
fd: .byte 0
_f_size: .word 0
_f_size_ondisk: .word 0
a: .word 0
b: .word 0
aux: .word 0
yyy: .space 8
mem: .space 1024
.text
_get_f_size_ondisk:

pushl %ebp
movl %esp, %ebp

xor %eax, %eax
xor %edx, %edx
movw _f_size, %ax
mov $8, %ebx
div %ebx 
cmp $0, %edx
jne curest
jmp fararest

curest: 
add $1, %eax

fararest:
# movw %ax, _f_size_ondisk

popl %ebp
ret


getfunction: 

pushl %ebp
movl %esp, %ebp

movb fd, %dl    # file decriptor = dl
movw $-1, a
movw $-1, b
mov $-1, %ecx
loop_get:
add $1, %ecx
cmp $1024, %ecx
je exit_get
xor %eax, %eax
movb (%edi, %ecx), %al
cmp %eax, %edx
jne loop_get
movw %cx, a
movw %cx, b
cmp $1023, %ecx
je exit_get
loop_get2:
movw %cx, b
add $1, %ecx 
cmp $1024, %ecx
je exit_get 
movb (%edi, %ecx), %al 
cmp %eax, %edx
je loop_get2 
xor %edx, %edx
movw a, %dx
cmp $-1, %dx
je exit_getfr
xor %edx, %edx
exit_get:
movw b, %dx
push b
movw a, %dx
push a
push $formatInterval
call printf
pop %edx
pop %edx
pop %edx
exit_getfr:
popl %ebp 
ret


afisare_memorie: 

pushl %ebp
movl %esp, %ebp

xor %ecx, %ecx
xor %eax, %eax
loop_afisare_memorie: 
movb (%edi, %ecx), %al
movw %cx, aux
cmp $0, %al
je nu_avem_fisier

movb $0, fd
movb %al, fd
xor %eax, %eax
xor %ebx, %ebx
xor %ecx, %ecx
xor %edx, %edx
call getfunction
xor %edx, %edx
movw b, %dx
movw %dx, aux
nu_avem_fisier:
xor %ecx, %ecx
movw aux, %cx
add $1, %ecx
cmp $1024, %ecx
jne loop_afisare_memorie

popl %ebp
ret

.global main

main:

lea mem, %edi
xor %ecx, %ecx
init: 
movw %cx, aux
movb $0, (%edi, %ecx)
movw aux, %cx
add $1, %cx
cmp $1024, %cx 
jne init

# movb $1, 3(%edi)
# movb $1, 4(%edi)
# movb $1, 5(%edi)

# citire nrop 
push $nrop
push $formatInput
call scanf
pop %edx 
pop %edx

push nrop
push $formatOutput
call printf
pop %edx 
pop %edx


xor %ecx, %ecx
xor %ebx, %ebx

movw nrop, %cx
loop_principal:
xor %ebx, %ebx

push $indiceop
push $formatInput
call scanf
pop %edx
pop %edx

movw indiceop, %bx

# add
cmp $1, %bx
je etadd
# get
cmp $2, %bx
je etget
# delete
cmp $3, %bx
je etdelete
# defragmentare
cmp $4, %bx
je etdefrag
# indice operatie gresit
cmp $4, %bx 
jg eroare_indice_op
# ----
etadd: 
push $1
push $formatOutput
call printf
pop %edx
pop %edx
xor %ecx, %ecx
# citire nropadd
push $nropadd
push $formatInput
call scanf
pop %edx
pop %edx

movw nropadd, %cx

loop_add: 
movb $0, fd
movw $0, _f_size
movw $0, _f_size_ondisk
cmp $0, %ecx
je exit_loop_add
# citire filedecriptor (fd)
sub $1, %ecx 
movw %cx, nropadd
push $fd
push $formatInput
call scanf
pop %edx
pop %edx

xor %ebx, %ebx
movb fd, %bl

push %bx
push $formatOutput
call printf
pop %edx
pop %edx

# Citire dimensiune fisier in kb
push $_f_size
push $formatInput
call scanf
pop %edx
pop %edx

movw _f_size, %bx

pushw %bx
push $formatOutput
call printf
pop %edx
popw %dx

# calculare dimensiune fisier pe disk

call _get_f_size_ondisk

movw %ax, _f_size_ondisk

push _f_size_ondisk
push $formatOutput
call printf
pop %edx
pop %edx

verificaSpatiuLiber:
xor %ecx, %ecx
xor %ebx, %ebx
xor %edx, %edx
loop_verificare_spatiu_liber:
movw _f_size_ondisk, %dx # dx = _f_size_ondisk
movb (%edi, %ecx), %bl 
cmp $0, %bl
je a_da
add $1, %ecx
cmp $1024, %ecx
jne loop_verificare_spatiu_liber
jmp exit_loop_verificare_spatiu_liber
a_da: 
movw %cx, a
sub $1, %dx
b_loop: 
cmp $0, %dx 
je b_da
add $1, %cx
cmp $1024, %ecx
je exit_loop_verificare_spatiu_liber
movb (%edi,%ecx), %bl 
cmp $0, %bl
jne loop_verificare_spatiu_liber

sub $1, %dx
cmp $0, %dx
jne b_loop
jmp b_da

b_da: 
movw %cx, b




exit_loop_verificare_spatiu_liber:
cmp $0, %dx
jne nu_exista_spatiu
jmp cont_loop_add
nu_exista_spatiu:
 movw $-1, a 
 movw $-1, b 
 xor %edx, %edx
 push $eroareSpatiuAdaugare
 call printf 
 pop %edx
xor %edx, %edx
jmp exit_loop_add
cont_loop_add:
xor %ecx, %ecx
movw a, %cx
movw b, %dx
loop_modificare_spatiu_add:
xor %ebx, %ebx
movw fd, %bx
movb %bl, (%edi, %ecx)
add $1, %cx
cmp %dx, %cx
jle loop_modificare_spatiu_add

afisare_add:
xor %eax, %eax
movw b, %ax
pushl %eax
xor %eax, %eax
movw a, %ax
pushl %eax
xor %eax, %eax
movb fd, %al
pushl %eax
push $formatAfisareADD
call printf
pop %edx
popl %edx
popl %edx
popl %edx
xor %edx, %edx
exit_loop_add:
movw nropadd, %cx
cmp $0, %cx
jne loop_add
jmp contloop_principal



etget:  # !!! De Adaugat cazul in care fisierul nu exista !!! 
push $2
push $formatOutput
call printf
pop %edx
pop %edx

movb $0, fd
push $fd
push $formatInput
call scanf
pop %edx 
pop %edx

xor %edx, %edx
xor %ecx, %ecx
xor %ebx, %ebx

call getfunction

jmp contloop_principal

etdelete: 
push $3
push $formatOutput
call printf
pop %edx
pop %edx




jmp contloop_principal

etdefrag: 
push $4
push $formatOutput
call printf
pop %edx
pop %edx

jmp contloop_principal

eroare_indice_op: 
push $stringEroareIndiceOp
call printf
pop %edx

jmp contloop_principal

contloop_principal: 
# continuare loop principal 
xor %ecx, %ecx
movw nrop, %cx
sub $1, %cx
movw %cx, nrop
cmp $0, %cx
jne loop_principal 

xor %ecx, %ecx

call afisare_memorie

xor %eax, %eax
xor %ebx, %ebx
xor %ecx, %ecx
xor %edx, %edx

 afisare_spatiu:
movw %cx, aux
xor %edx, %edx
movb (%edi, %ecx), %dl
push %dx
push $formatOutput
call printf
pop %edx
pop %edx
movw aux, %cx
add $1, %cx
cmp $1024, %cx 
jne afisare_spatiu

push $0
call fflush
pop %edx

exit: 
mov $1, %eax
mov $0, %ebx
int $0x80
