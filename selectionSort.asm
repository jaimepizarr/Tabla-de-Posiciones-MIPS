.text
.globl selectionSort

selectionSort:
    #a0: matriz
    #a1: matrizComparable
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)

    move $s0, $a0 #s0:matriz
    move $s1, $a1 #s1: mComparable

    add $s2, $zero, 0 #iFila

    whileMenor15:
        slti $t1, $s2, 15
        bne $t1, 1, endSelectionSort
            move $a0, $s1
            move $a1, $s2
            jal filaMayor
            move $s3, $v0 #t2 = jFila = filaMayor(mComp, iFila)
            move $a0, $s2
            move $a1, $s3
            move $a2, $s0
            jal swap
            move $a0, $s2
            move $a1, $s3
            move $a2, $s1
            jal swapMComp

            addi $s2, $s2, 1
            j whileMenor15
    
    endSelectionSort:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $ra, 16($sp)
        addi $sp, $sp, 20
        jr $ra






filaMayor:
#a0: matrizComparable            move $s3, $v0 #t2 = jFila = filaMayor(mComp, iFila)
#a1: lower
    addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)

    move $s0, $a0 #matrizComparble
    move $s1, $a1 #iMax
    addi $s2, $s1, 1 # i = lower+1
    whileIMenor16:
        slti $t0, $s2, 16
        bne $t0, 1, endFilaMenor
        
        li $t0, 12
        mul $t1 ,$s2, $t0 #12*i
        add $a0, $t1, $s0 #A0 matrizComp[i]
        mul $t0, $s1, $t0   
        add $a1, $t0, $s0 #A1 matrizComp[iMax]
        jal comparator
        bne $v0, 1, seguirComparando
            move $s1, $s2
        seguirComparando:
            addi $s2, $s2, 1 #i+=1
            j whileIMenor16

    endFilaMenor: 
        move $v0, $s1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $ra, 12($sp)
        addi $sp, $sp, 16

        jr $ra