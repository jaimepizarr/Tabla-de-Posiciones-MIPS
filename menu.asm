.data 
.align 2
equipoLocal: .space 20
equipoVisitante: .space 20
golesLocal: .space 4
golesVisita: .space 4
bienvenida: .asciiz "Bienvenido a la Tabla de Posiciones del Campeonato Ecuatoriano \n"
opcion1: .asciiz "1. Mostrar tabla ordenada \n"
opcion2: .asciiz "2. Ingresar Partido \n "
entryEquipo1: .asciiz "Ingrese el equipo Local: \n"
entryEquipo2: .asciiz "Ingrese el equipo Visitante: \n"
entryGolLocal: .asciiz "Ingrese los goles del Equipo Local: \n"
entryGolVisit: .asciiz "Ingrese los goles del Equipo Visitante: \n"

saltoLinea: .asciiz "\n"
coma: .asciiz ","

.text

la $a0, bienvenida
li $v0, 4
syscall


#Cargar matriz:
la $a0, saltoLinea
la $a1, coma
jal leerArchivo
move $s1, $v0

#swap 
li $a0, 0
li $a1, 1
move $a2, $s1
jal swap

#imprimirTabla
move $a0, $s1
la $t1, saltoLinea
lb $a1, 0($t1)
la $t2, coma
lb $a2, 0($t2)
jal imprimirTabla

#la $a0, entryEquipo1
#li $v0, 4
#syscall

#Pedir Equipo Local
#la $a0, equipoLocal
#li $a1, 20
#li $v0, 8
#syscall


#matriz Comparable
#move $a0, $s1
#jal obtenerMatrizComparable
#move $s2, $v0



#comparar 2 y 8
#li $t0, 24 #fila 2
#li $t1, 96 #fila 8
#add $t0, $s2, $t0 
#add $t1, $s2, $t1
#move $a0, $t1
#move $a1, $t0
#jal comparator

#move $a0, $v0
#li $v0, 1
#syscall

#encontrar fila del equipo
#move $a0, $s1
#la $a1, equipoLocal
#la, $a2, saltoLinea
#jal findNombre


#move $t1, $v0 #direccion de memoria

#li $v0, 1
#move $a0, $t1
#syscall	



validacionOpciones:
	#a0 numeroOpcion


validacionNumeros:
	# goles




exit:
li $v0, 10
syscall









