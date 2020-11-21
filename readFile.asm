.data
file: .asciiz "TablaIni.txt"
buffer: .space 1024

cantidades: .word 0



matriz: .space 832

saltoLinea: .asciiz "\n"
coma: .asciiz ","

#Los nombres de los equipos tendran 20 bytes de espacio y los valores numericos tendran 4 bytes 
# Tenemos (20*1col + 4*8col)*16filas = 832 bytes

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

li $v0, 4
la $a0, buffer
syscall


#recorrer buffer
la $s0, buffer 


la $s1, saltoLinea
lb $s1, 0($s1)
la $s2, coma
lb $s2, 0($s2)
la $s3, matriz

li $s4, 3 #i
add $s4, $s4, $s0 # i + buffer


#Saltar encabezado
while:
    lb $t1, 0($s4) #t1 = buffer[i]

    
    bne $t1, $s1, thenFirst
        addi $s4,$s4,1
        j whileR
    
    thenFirst:
        addi $s4, $s4, 1 #anadir 1 a i
        

        
        j while
    
add $t4, $zero, $zero #iSaltosLinea
    
#Recorrer a partir de la 2da linea	
whileR:


    lb $t1, 0($s4) 
    beq $t1, 0, exit # buffer[i] != '\0'
	
	add $t5, $zero, $zero #iComas    
        whileSalto:
            lb $t1, 0($s4)
            bne $t1, $s1, then
                addi $t4, $t4, 1 #iSaltosLinea+=1
                addi $s4, $s4, 1
                
                
                j whileR
        
            then:
            
                addi $t8, $zero, 52
                mul $t8, $t4, $t8 #iFilas
                
                beq $t5, 0, elseNombre
                
                    add $s5, $zero, $zero
                    la $t7, cantidades
                    
                    li $t3, 0
                    sw $t3, 0($t7)

                    add $a0, $t7, $zero 
                    jal obtenerCampo
                    
                    add $a0, $t7, $zero
                    jal atoi # v0= entero 
                    
                    #$t9 -> matriz + ((20 + (iComas-2)*4)+ iFila)
                    addi $t9, $t5, -2
                    sll $t9, $t9, 2
                    addi $t9, $t9, 20
                    add $t9, $t9, $t8
                    add $t9, $s3, $t9
                    
                 
                    
                    sw $v0, 0($t9)
                    
                    #v0 -> entero
                    j whileSalto

                elseNombre:
                    add $s5, $t8, $zero # j($s5) = iFilas
                    add $a0, $s3, $zero # B = matriz
                    jal obtenerCampo
                    
                    j whileSalto



