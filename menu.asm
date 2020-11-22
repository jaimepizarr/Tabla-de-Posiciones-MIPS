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



la $a0, entryEquipo1
li $v0, 4
syscall

#Pedir Equipo Local
la $a0, equipoLocal
li $a1, 20
li $v0, 8
syscall

#encontrar fila del equipo
move $a0, $s1
la $a1, equipoLocal
la, $a2, saltoLinea
jal findNombre


move $t1, $v0 #direccion de memoria

li $v0, 1
move $a0, $t1
syscall	


exit:
li $v0, 10
syscall

