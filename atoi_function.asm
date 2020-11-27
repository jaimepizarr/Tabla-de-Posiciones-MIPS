.text
.globl atoi
# Funcion que recibe un numero en string y hace el cast a int

atoi:
    or      $v0, $zero, $zero   # res = 0
    or      $t1, $zero, $zero   # esNegativo = false
    lb      $t0, 0($a0)
    bne     $t0, '-', entero
    addi    $t1, $zero, 1       # esNegativo = true
    addi    $a0, $a0, 1
entero:
    lb      $t0, 0($a0)
    slti    $t2, $t0, 58        # asegurar que el digito es menor a 9
    slti    $t3, $t0, 48        
    beq     $t2, $zero, notEntero
    bne     $t3, $zero, notEntero   # asegurar que el digito es mayor a 0
    sll     $t2, $v0, 1
    sll     $v0, $v0, 3
    add     $v0, $v0, $t2       # res * 10
    addi    $t0, $t0, -48       # transformar ascii a entero
    add     $v0, $v0, $t0       # res = res * 10 + str[i] - '0';
    addi    $a0, $a0, 1         # ++res
    j   entero
notEntero:
    beq     $t1, $zero, salida    # si es negativo 
    sub     $v0, $zero, $v0
salida:
    jr      $ra         # return
