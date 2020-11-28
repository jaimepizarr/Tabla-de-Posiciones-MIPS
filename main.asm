.data
usuario: .space 2
equipoLocal: .space 20
equipoVisitante: .space 20
golesLocal: .space 4
golesVisita: .space 4

bienvenida: .asciiz "Bienvenido al menu de partidos, por favor ingrese el numero de la opcion que desea: \n"
merror: .asciiz "Ingrese una opcion valida del 1 al 3: \n"
merrorNumeric: .asciiz "Ingrese un valor numerico \n"
gracias: .asciiz "Gracias, regrese pronto \n"
saltoLinea: .asciiz "\n"
coma: .asciiz ","
opcionSort: .asciiz "1. Mostrar la tabla ordenada\n"
opcionInput: .asciiz "2. Ingresos de partidos\n"
opcionSlice: .asciiz "3. Mostrar los 3 mejores\n"
opcionSalida: .asciiz "4. Salir\n"
opcionEquipoLocal: .asciiz "Ingrese el equipo Local: \n"
opcionEquipoVisita: .asciiz "Ingrese el equipo Visitante: \n"
entryGolLocal: .asciiz "Ingrese los goles del Equipo Local: \n"
entryGolVisit: .asciiz "Ingrese los goles del Equipo Visitante: \n"


.text 
main:
    # *usuario -> $s0
    # usuario -> $s1
    # matriz -> $s2
    # saltoLinea -> $s4

    li $s1, 1
    la $a0, saltoLinea
    la $a1, coma 
    jal leerArchivo
    move $s2, $v0 #matriz
    whileMain:
        move $a0, $s2
        jal obtenerMatrizComparable
        move $s3, $v0 #matrizComparable 
        move $a0, $s2 #matriz
        move $a1, $s3
        jal selectionSort
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

ingresarPartido:
        #s1: fila_Local*
        #s2: fila_Visita*
        #s3: goles local
        #s4: goles Visita
        #a0: matriz
        addi $sp, $sp, -24
        sw $ra, 0($sp) #guardamos la direccion del return
        sw $s0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)
        sw $s3, 16($sp)
        sw $s4, 20($sp)

        move $s0, $a0

        PedirLocal:
            la $a0, opcionEquipoLocal #Pedir Equipo Local
            li $v0, 4
            syscall 

            la $a0, equipoLocal #Entry Equipo Local
            li $a1, 20
            li $v0, 8
            syscall

            move $a0, $s0
            la $a1, equipoLocal
            la $a2, saltoLinea
            jal findNombre #Ir a buscar fila del equipo Local
            move $s1, $v0

            bne $s1, -1,  PedirVisita #Validar si el equipo existía
                move $a0, $s0 
                li $a1, 16
                jal getBestTeams #Mostrar todos los equipos disponibles
                j PedirLocal #Volver a pedir el equipo local

        PedirVisita:
            la $a0, opcionEquipoVisita #Pedir Equipo Visitante
            li $v0, 4
            syscall

            la $a0, equipoVisitante #Entry Equipo Visita
            li $a1, 20
            li $v0, 8
            syscall

            move $a0, $s0
            la $a1, equipoVisitante
            la $a2, saltoLinea
            jal findNombre #Buscar fila equipo Visita
            move $s2, $v0

            bne $s2, -1, PedirGolesLocal #Validar si equipo existia
                move $a0, $s0
                li $a1, 16
                jal getBestTeams #Mostrar todos los equipos disponibles
                j PedirVisita #Volver a pedir equipo Visita

        PedirGolesLocal:
            #Pedir Goles local
            la $a0, entryGolLocal
            li $v0, 4
            syscall

            #Entrada Goles Local
            la $a0, golesLocal
            li $a1, 4
            li $v0, 8
            syscall

            la $a0, golesLocal
            jal isNumeric #Validar si la entrada es numerica
            move $t4, $v0
            bne $t4, 0, convertGolesLoc 

                la $a0, merrorNumeric #mostrar mensaje de error
                li $v0, 4
                syscall
                j PedirGolesLocal #Volver a pedir Goles

            convertGolesLoc:
                la $a0, golesLocal
                jal atoi #Cast a int
                move $s3, $v0 #t2-> goles Local
        
        PedirGolesVisita:
            #Pedir Goles Visita
            la $a0, entryGolVisit
            li $v0, 4
            syscall

            #Entrada Goles Local
            la $a0, golesVisita
            li $a1, 4
            li $v0, 8
            syscall

            la $a0, golesVisita
            jal isNumeric #validar si la entrada es numerica
            move $t4, $v0
            bne $t4, 0, convertGolesVisit 

                la $a0, merrorNumeric  #Mostrar msje Error
                li $v0, 4
                syscall
                j PedirGolesVisita #volver a pedir goles Visita

            convertGolesVisit:
                la $a0, golesVisita
                jal atoi #Cast a int 
                move $s4, $v0 #t3 -> goles Visita

            move $a0, $s1
            move $a1, $s2
            move $a2, $s3
            move $a3, $s4
            jal actualizarEquipo #Actualizar datos tabla

            #Mandar a ordenar la tabla
            
            lw $ra, 0($sp)
            lw $s0, 4($sp)
            lw $s1, 8($sp)
            lw $s2, 12($sp)
            lw $s3, 16($sp)
            lw $s4, 20($sp)
            addi $sp, $sp, 24    
            jr $ra	# jump to $ra

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
