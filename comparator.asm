# $a0: A0
# $a1: A1



.globl comparator

comparator:
    
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    
    li $s0, 0 #i=0
    whileMenor3:    
        slti $t0, $s0, 3 #i<3
        bne $t0, 1, sonIguales

            sll $t1, $s0, 2 #i*4
            add $t2, $t1, $a0 #A0 + i*4
            lw $t2, 0($t2) #A0[i]

            add $t3, $t1, $a1 #A1 + i*4
            lw $t3, 0($t3) #A1[i]

            bne $t2, $t3, verSiMenor #A[0] == A[1]
                addi $s0, $s0, 1
                j whileMenor3

            verSiMenor: 
                slt $t4, $t2, $t3
                bne $t4, 1, esMayor  #A[0] < A[1]
                    addi $v0, $zero, -1
                    j returnComparator
                esMayor:                #A[0] > A[1]
                    addi $v0, $zero, 1
                    j returnComparator
                    
        sonIguales:
            addi $v0, $zero, 0 #return 0 
            j returnComparator

    returnComparator:
        lw $s0, 0($sp)
        addi $sp, $sp, 4

        jr $ra
        
