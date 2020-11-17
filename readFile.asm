.data
file: .asciiz "TablaIni.txt"
buffer: .space 1024

matriz: .space 576

saltoLinea: .asciiz "\n"
coma: .asciiz ","

#Los nombres de los equipos tendran 20 bytes de espacio y los valores numericos tendran 2 bytes 
# Tenemos (20*1col + 2*8col)*16filas = 576 bytes

.text

.globl leerArchivo

leerArchivo:
#abrir archivo 
li $v0, 13 #numero servicio para abrir archivo
la $a0, file #hacer el load del nombre del archivo en a0
li $a1, 0 #guardar el flag 0 indicando que es de lectura
syscall
move $s0, $v0 #guardar la direccion en s0

#leer archivo 
li $v0, 14 # numero de servicio para leer archivo
move $a0, $s0 #mover el addres a a0
la $a1, buffer #poner el address del buffer en a1
li $a2, 1024 #ubicar el tamaño max de la entrada
syscall

#recorrer buffer
li $t0, 3 #i
la $t1, buffer 
la $t2, saltoLinea
lb $t2, 0($t2)
la $t3, coma
lb $t3, 0($t3)
la $t4, matriz



while:
	add $t6, $t0, $t1
	lb $t7, 0($t6)

#	imprimir char
#	li $v0, 11
#	move $a0, $t8
#	syscall 
	
	bne $t7, $t2, then
	addi $t0,$t0,1
	j whileR
	
	then:
	addi $t0, $t0, 1 #anadir 1 a i
	j while
	
	
whileR:
	
	slti $t5, $t0, 1024
	beq $t5, $zero, exit
	
	add $t6, $t0, $t1
	lb $t7, 0($t6)
	
		

#imprimir el archivo
#li $v0, 4
#la $a0, buffer
#syscall

exit:
#Cerrar el archivo
li $v0, 16
move $a0, $s0
syscall



