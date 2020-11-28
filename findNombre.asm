
.text

.globl findNombre

findNombre:
    addi, $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $ra, 8($sp)
    #$a0 -> matriz
    #$a1 -> nombre
    move $s1, $a0
    add $s0, $zero, $zero #i
    move $s2, $a2 
    lb $s2, 0($s2) #salto Linea

    whileR2: 
        slti $t1, $s0, 832
        beq $t1, 1, true
            addi $v0, $zero, -1 #return -1
            j exitFind
        true:
            add $a0, $s1, $s0 #matriz* + i
            jal equalsNombre
            beq $v0, 1, encontrado
                addi $s0, $s0, 52
                j whileR2 
            
            encontrado:
                add $v0, $s1, $s0 #matriz* +  i
                j exitFind
    exitFind:
        
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $ra, 8($sp)
        addi, $sp, $sp, 12 

        jr $ra
        


equalsNombre:
    #$a0 -> nombreM[0]
    #$a1 -> nombre
    add $t1, $zero, $zero #i
    whileMenor20:
        slti $t4, $t1, 20
        beq $t4, 1, continuar
            li $v0 1
            jr $ra
            
        continuar:
            add $t2, $a0, $t1 #nombreM[i]
            add $t3, $a1, $t1 #nombre[i]
            lb $t2, 0($t2)
            lb $t3, 0($t3)
            bne $t3, $s2, contCompare
            	li $t1, 20
            	j whileMenor20
            contCompare:
            bne $t2, $t3, diferentes
                addi $t1, $t1, 1
                j whileMenor20
            diferentes:
                addi $v0, $zero, -1
                jr $ra
