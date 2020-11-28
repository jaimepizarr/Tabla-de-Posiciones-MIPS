.text

#$a0: local
#$a1: visita
#$a2: golLocal
#$a3: golV
.globl actualizarEquipo

actualizarEquipo:
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)

    addi $s0, $a0, 20 #local
    addi $s1, $a1, 20 #visita
    move $s2, $a2 #golLocal
    move $s3, $a3 #golV

    lw $t0, 4($s0) #local[1]
    addi $t0, $t0, 1
    sw $t0, 4($s0) #local[1]+=1

    lw $t1, 4($s1) #visita[1]
    addi $t1, $t1, 1
    sw $t1, 4($s1) #visita[1]+=1

    move $a0, $s0
    move $a1, $s2
    move $a2, $s3
    jal actualizarDatosGoles

    move $a0, $s1
    move $a1, $s3
    move $a2, $s2
    jal actualizarDatosGoles

    slt $t2, $s3, $s2
    bne $t2, 1, validarSiMayor
        move $a0, $s0
        move $a1, $s1
        jal actDatPartidos
        j endActEquipo

    validarSiMayor:
        slt $t2, $s2, $s3
        bne $t2, 1, golIguales
            move $a0, $s1
            move $a1, $s0
            jal actDatPartidos
            j endActEquipo

    golIguales:
        move $a0, $s0
        jal actualizarEmpate

        move $a0, $s1
        jal actualizarEmpate

    endActEquipo:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $ra, 16($sp)
        addi $sp, $sp, 20

        jr $ra



actualizarEmpate:
#a0: equipo
    lw $t0, 0($a0)
    addi $t0, $t0, 1
    sw $t0, 0($a0)

    lw $t0, 12($a0)
    addi $t0, $t0, 1
    sw $t0, 12($a0)

    jr $ra

actualizarDatosGoles:
    #a0: equipo
    #a1: gFav
    #a2: gC
    sub $t0, $a1, $a2

    lw $t1, 20($a0) #equipo[5] ~ equipo[GF]
    add $t1, $t1, $a1
    sw $t1, 20($a0) #equipo[GF] += gFav

    lw $t1, 24($a0) #equipo[6] ~ equipo[GC]
    add $t1, $t1, $a2
    sw $t1, 24($a0) #equipo[GC] += gC

    lw $t1, 28($a0) #equipo[7] ~ equipo[GD]
    add $t1, $t1, $t0
    sw $t1, 28($a0)

    jr $ra

actDatPartidos:
    #a0: winner
    #a1: loser
    lw $t0, 0($a0)
    addi $t0, $t0, 3
    sw $t0, 0($a0)

    lw $t0, 8($a0)
    addi $t0, $t0, 1
    sw $t0, 8($a0)

    lw $t0, 16($a1)
    addi $t0, $t0, 1
    sw $t0, 16($a1)

    jr $ra
