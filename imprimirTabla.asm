.text
#$a0 direccion de memoria de matriz
#$a1  "\n"
#$a2  ","

.globl imprimirTabla

imprimirTabla:

addi $sp, $sp, -20
sw $s1, 16($sp)
sw $s2, 12($sp)
sw $s3, 8($sp) 
sw $s4, 4($sp)
sw $s5, 0($sp)


li $s1, 52 #longitud de la filas
add $s3, $zero, $zero #i
move $s2, $a0 #matriz
move $s3, $a1 # "\n"
move $s5, $a2 # ","
add $s4, $zero, $zero

whilePrueba:
    slti $t1, $s4, 832
    bne $t1, $zero, recorrer
    j exitPrueba

    recorrer:

        div $s4, $s1
        mfhi $t2
        bne $t2, 0, elsePrueba
            
            li $v0, 11
            move $a0, $s3
            syscall
            
            j RecorrerPalabra

        elsePrueba:
            
            li $v0, 11
            move $a0, $s5
            syscall
            
            j RecorrerNumero

        
            
            
            
RecorrerNumero:

    li $t2, 0
    add $t2, $s2, $s4

    lw $t3, 0($t2)

    li $v0, 1
    move $a0, $t3
    syscall


    addi $s4, $s4, 4

    j whilePrueba




RecorrerPalabra:

    li $t3, 0 #j
    whilemenor20:
        slti $t4, $t3, 20
        beq $t4, 1, imprimirChar
            j whilePrueba

        imprimirChar:
            add $t5, $s2, $s4

            lb $t5, 0($t5)
            
            li $v0, 11
            move $a0, $t5
            syscall
            addi $s4, $s4, 1
            addi $t3, $t3, 1
            j whilemenor20
        


exitPrueba:
	jr $ra

