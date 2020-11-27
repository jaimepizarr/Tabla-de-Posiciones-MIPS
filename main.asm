.data
usuario: .space 2
bienvenida: .asciiz "Bienvenido al menu de partidos, por favor ingrese el numero de la opcion que desea: \n"
merror: .asciiz "Ingrese una opcion valida del 1 al 3: \n"
gracias: .asciiz "Gracias, regrese pronto \n"
saltoLinea: .asciiz "\n"
coma: .asciiz ","
opcionSort: .asciiz "1. Mostrar la tabla ordenada\n"
opcionInput: .asciiz "2. Ingresos de partidos\n"
opcionSlice: .asciiz "3. Mostrar los 3 mejores\n"
opcionSalida: .asciiz "4. Salir\n"

.text 
main:
    # *usuario -> $s0
    # usuario -> $s1
    # matriz -> $s2
    # coma -> $s3
    # saltoLinea -> $s4

    li $s1, 1
    whileMain:
        la $a0, saltoLinea
        la $a1, coma 
        jal leerArchivo
        move $s2, $v0
        bne $s1, 4, presentarMenu
        j exitMain

    presentarMenu:
        la $a0, bienvenida
        jal showMenu
        move $a0, $v0
        jal validarNumero
        move $a0, $v0
        jal validarRango
        #verificando si es una opcion
        move $s1, $v0
        beq $s1, 1, opMostrarTabla
        beq $s1, 2, opPartidos
        beq $s1, 3, opMostrar3Mejores
        beq $s1, 4, exitMain
        opMostrarTabla:
            move $a0, $s2
            la $t1, saltoLinea
            lb $a1, 0($t1)
            la $t2, coma
            lb $a2, 0($t2)
            jal imprimirTabla
            la $t1, saltoLinea
            lb $a0, 0($t1)
            li $v0, 11
            syscall
            j whileMain
        opPartidos:
        move $a0, $s2
        jal ingresarPartido
            
        j whileMain
        opMostrar3Mejores:
            move $a0, $s2
            li $a1, 3
            jal getBestTeams
            j whileMain

showMenu:
    li $v0, 4
    syscall
    la $a0, opcionSort
    syscall
    la $a0, opcionInput
    syscall
    la $a0, opcionSlice
    syscall
    la $a0, opcionSalida
    syscall
    #Pedir numero
    la $a0, usuario
    li $a1, 4
    li $v0, 8 #read string
    move $t0, $a0
    syscall
    la $a0, saltoLinea
    li $v0, 4   
    syscall
    move $v0, $t0
    jr $ra



validarNumero:
# *usuario -> $s0

    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $ra, 4($sp)
    move $s0, $a0 
    whileValNum:
        move $a0, $s0
        jal isNumeric
        beq $v0, 0, noEntero
        #isEntero
            move $a0, $s0
            jal atoi # me devuelve el entero
            lw $s0, 0($sp)
            lw $ra, 4($sp)   
            addi $sp, $sp,8
            jr $ra

        noEntero:
            la $a0, merror
            jal showMenu #print error message and read string
            move $s0, $v0
            j whileValNum

validarRango:
# *usuario -> a0
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    move $s0, $a0

 
    whileOptionInvalid:
        addi $t0, $zero, 1
   	addi $t1, $zero, 4
        blt $s0, $t0, noRangoValido
        bgt $s0, $t1, noRangoValido

    move $v0, $s0
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
        noRangoValido:
            la $a0, merror
            jal showMenu
            move $a0, $v0
            jal validarNumero
            move $s0, $v0
            j whileOptionInvalid

isNumeric:
# *usuario -> a0
# i -> t0
# usuario[i] -> t1

    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    move $s0, $a0 #s0 = *usuario
    add $t0, $zero, $zero

    whileRPalabra:
        add $t1, $s0, $t0
        lb $t1, 0($t1) # d = usuario[i]
        
        move $a0, $t1
        jal isVacioAndSalto
        move $t2, $v0
        beq $t2, 1, noNull
        
        beq $t0, $zero, cadenaNull
            addi $v0, $zero, 1
            j returnIsNumeric


        cadenaNull:
            add $v0, $zero, $zero
	    j returnIsNumeric

        noNull:
            slti $t2, $t1, 58        # asegurar que el digito es menor a 9
            slti $t3, $t1, 48        
            beq $t2, $zero, buEntero
            bne $t3, $zero, buEntero
                addi $t0, $t0, 1
                j whileRPalabra
            buEntero:
                add $v0, $zero, $zero
                
	
	returnIsNumeric:
	    lw $ra, 0($sp)
        lw $s0, 4($sp)
	    addi $sp, $sp, 8
	    
	    jr $ra


isVacioAndSalto:
#a0 -> d
    bne $a0, 0, valSalto
        j fail
    
    valSalto:
        beq $a0, 10, fail
        li $v0, 1
        jr $ra 

    fail:
        li $v0, 0
        jr $ra




exitMain:
    li $v0, 4        
    la $a0, gracias
    syscall
    li $v0, 10
    syscall
