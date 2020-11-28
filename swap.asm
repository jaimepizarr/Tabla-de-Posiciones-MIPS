.data
.align 2
temp: .space 52
tempMComp: .space 12

.text

.globl swap
.globl swapMComp

swap:
    #$a0-> numero fila1
    #$a1-> numero fila2
    #$a2-> matriz
    
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    la $s3, temp

    mul $s0,$s0, 52
    mul $s1,$s1, 52

    add $s0, $s0, $s2 #matriz + 52*fila1
    add $s1, $s1, $s2 #matriz + 52*fila2

    move $a0, $s0
    move $a1, $s3
    jal moverFilas #temp = matriz[fila1]

    move $a0, $s1
    move $a1, $s0
    jal moverFilas #matriz[fila1] = matriz[fila2]

    move $a0, $s3
    move $a1, $s1
    jal moverFilas #matriz[fila2] = temp

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20

    jr $ra

moverFilas:
    #$a0-> &f_origen
    #$a1-> &f_destino
    add $t0, $zero, $zero #i=0
    whilePalabra:
        add $t2, $t0, $a0 
        add $t3, $t0, $a1 
        slti $t1, $t0, 20
        bne $t1, 1, llenarNumeros	# if $t0 > 20 then llenarNumeros

            lb $t2, 0($t2) #f_origen[i]
            sb $t2, 0($t3) #f_destino[i] = f_origen[i]
            addi $t0, $t0, 1
            j whilePalabra

    llenarNumeros:
        add $t2, $t0, $a0 
        add $t3, $t0, $a1     
        slti $t1, $t0, 52
        bne $t1, 1, endMoverFilas
            lw $t2, 0($t2) #f_origen[i:i+4]
            sw $t2, 0($t3) #f_destino[i:i+4] = f_origen[i:i+4]
            addi $t0, $t0, 4
            j llenarNumeros

    endMoverFilas:
        jr $ra


swapMComp:
    #$a0-> numero fila1
    #$a1-> numero fila2
    #$a2-> matriz

    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    la $s3, tempMComp

    mul $s0,$s0, 12
    mul $s1,$s1, 12

    add $s0, $s0, $s2 #matriz + 12*fila1
    add $s1, $s1, $s2 #matriz + 12*fila2

    move $a0, $s0
    move $a1, $s3
    jal moverFilasComp

    move $a0, $s1
    move $a1, $s0
    jal moverFilasComp #matriz[fila1] = matriz[fila2]

    move $a0, $s3
    move $a1, $s1
    jal moverFilasComp #matriz[fila2] = temp

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20

    jr	$ra	
    


moverFilasComp:
    #$a0-> &f_origen
    #$a1-> &f_destino
    add $t0, $zero, $zero #i=0

    whileIndMenor12:
        slti $t1, $t0, 12
        bne $t1, 1, returnMoverFilasComp
            add $t2, $t0, $a0 
            add $t3, $t0, $a1
            lw $t2, 0($t2) #f_origen[i:i+4]
            sw $t2, 0($t3) #f_destino[i:i+4] = f_origen[i:i+4]
            addi $t0, $t0, 4
            j whileIndMenor12

    
    returnMoverFilasComp:
        jr $ra 
