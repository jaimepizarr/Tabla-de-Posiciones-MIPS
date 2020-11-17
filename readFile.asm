.data
file: .asciiz "TablaIni.txt"
buffer: .space 1024
saltoLinea: .asciiz "\n"
coma: .asciiz ","

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
la $t1, buffer 
la $t2, saltoLinea



#imprimir el archivo
li $v0, 4
la $a0, buffer
syscall


#Cerrar el archivo
li $v0, 16
move $a0, $s0
syscall



