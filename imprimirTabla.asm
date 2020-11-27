.data
saltoLinea: .asciiz "\n"
coma: .asciiz ","

.text
#$a0 direccion de memoria de matriz
#$a1  "\n"
#$a2  ","

.globl imprimirTabla
.globl getBestTeams
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
lw $s1, 16($sp)
lw $s2, 12($sp)
lw $s3, 8($sp) 
lw $s4, 4($sp)
lw $s5, 0($sp)
addi $sp, $sp, 20

	jr $ra

recorrerPalabra:
    # a0 matriz
    # a1 i
    
    move $t0, $a0 #matriz
    move $t1, $a1 #i
    add $t2, $zero, $zero #j
    addi $t4, $zero, 20
    whileREquipo:
        blt $t2, $t4, imprimirCaracter
            jr $ra
        imprimirCaracter:
            add $t3, $t0, $t1
            add $t3, $t3, $t2
            lb  $a0, 0($t3)
            li $v0, 11
            syscall
            addi $t2, $t2, 1
            j whileREquipo
            
getBestTeams:
    #a0 -> matriz
    #a1 -> numero de mejores equipos
    addi $sp, $sp, -28
    sw $s0, 0($sp) #matriz
    sw $s1, 4($sp) #nequipos
    sw $s2, 8($sp) #longitud filas 52
    sw $s3, 12($sp) # i
    sw $s4, 16($sp) #salto linea
    sw $s5, 20($sp) #coma
    sw $ra, 24($sp) 

    move $s0, $a0
    move $s1, $a1
    li $s2, 52
    li $s3, 0 #fila
    la $s4, saltoLinea 
    la $s5, coma 

    whileRFilas:
        blt $s3, $s1, getTeam
            lw $s0, 0($sp)
            lw $s1, 4($sp) 
            lw $s2, 8($sp) 
            lw $s3, 12($sp) 
            lw $s4, 16($sp) 
            lw $s5, 20($sp)
            lw $ra, 24($sp) #coma
            addi $sp, $sp, 28
            jr $ra
        getTeam:
            mul $t0,$s3,52 #indice inicial de la palabra en la matriz
            move $a0, $s0
            move $a1, $t0
            jal recorrerPalabra
            la $t1, saltoLinea
            lb $a0, 0($t1)
            li $v0, 11
            syscall
            addi $s3, $s3, 1
            j whileRFilas

