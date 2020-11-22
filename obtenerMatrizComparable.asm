.data 
matrizComparable: .space 192  
.align 2

.text

.globl obtenerMatrizComparable

#$a0: &matriz
obtenerMatrizComparable:
    addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)


    la $s0, matrizComparable
    li $s1, 0 #i
    # 12 bytes por fila en MatrizComparable
    li $s2, 0 #j

    whileR3:
        slti $t0, $s1,  832
        beq $t0, 1, llenarMatriz
            
            lw $s0, 0($sp)
            lw $s1, 4($sp)
            lw $s2, 8($sp)
            lw $ra, 12($sp)
            addi $sp, $sp, 16

            move $v0, $s0 #return matrizComparable
            
            jr $ra 
        
        llenarMatriz:

            li $a1, 20
            li $a2, 1
            jal llenarCeldaMC

            li $a1, 48
            li $a2, 2
            jal llenarCeldaMC

            li $a1, 40
            li $a2, 3
            jal llenarCeldaMC

            addi $s1, $s1, 52
            addi $s2, $s2, 12

            j whileR3



            
            




llenarCeldaMC:
#$a0 matriz
#$a1 Byte inicial
#$a2 col MatrizComparable

#$s1 i
#$s2 j (multiplo de 12)
#$s0 matrizComparable

    add $t0, $s1, $a1
    add $t0, $t0, $a0
    lw $t0, 0($t0) #$t0 = matriz[i+20:i+23]

    add $t1, $s2, $s0 #matrizComparable[j]
    sll $t2, $a2, 2 #col * 4
    add $t1, $t1, $t2
    sw $t0, 0($t1) # matrizComparable[j][col] = $t$0

    jr $ra