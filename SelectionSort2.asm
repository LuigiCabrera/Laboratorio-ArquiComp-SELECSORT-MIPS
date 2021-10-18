.data
	arr: .space 40
	init: .asciiz "Init array:\n"
	elem: .asciiz " element: " 
	parray: .asciiz "\nOrigin Array:\n"
	psort: .asciiz "\n\nSorted Array:\n"
	coma: .asciiz ", "

.text
.globl __start
__start:
la $a0, init
li $v0, 4
syscall 		# Imprime init array

la $s1, arr		# PUNTERO A ARRAY EN $s1
addiu $t0, $zero, 10	# $t0 = n_elementos
addiu $t1, $zero, 0	# INDICE inicializado en $t1 = 0

loop:
	addiu $a0, $t1, 0
	li $v0, 1
	syscall 	# Numero de elemento
	
	la $a0, elem
	li $v0, 4
	syscall 	# Imprime " element: "
	
	li $v0, 5
	syscall		# Recibe numero
	
	add $t2, $t1, $t1
	add $t2, $t2, $t2	# Cuatriplicar el indice para acceder al array con bytes
	add $t2, $t2, $s1 	# AHORA $t2 GUARDA LA DIRECCION DE MEMORIA DEL ELEMENTYO A ACCEDER
	
	sw $v0, 0($t2)		# Guarda numero en la direccion
	
	addiu $t1, $t1, 1	# Aumenta el indice (4)
	
	beq $t1, $t0, done_loop # Termina si el numero de elementos = 10
	j loop
	
done_loop:

# -------------------------- PRINT Origin array ----------------------------

la $a0, parray
li $v0, 4
syscall 	# Imprime "Origin Array\n"

jal print_arr

		
# -------------------------- PRINT RESULTING ARRAY ----------------------------
		
la $a0, psort
li $v0, 4
syscall 	# Imprime "Sorted Array\n"

addi $s2, $t0, 0
jal Sort

jal print_arr

# ---------------------------------------------------------------------

li $v0,10
syscall

Sort: 	# FUNCION MAX PARA ORDENAMIENTO ORDENA ARRAY
	# $s1 = Direccion del array
	# $t0 = Size del array
	# $s3 = DIRECCION DONDE ESTA EL MAYOR ELEMENTO
	
	# $s2 = size del sub array (va disminuyendo)
	# $s5 = PUNTERO A ULTIMA POSICION DEL ARRAY (VA disminuyendo)
	
	addiu $s2, $t0, 0  	# GUARDAMO QUE SIZE DEL SUB ARRAY = 10 (al principio)
	
	add $t1, $t0, $zero	# Indice = $t1 = Numero inicial de elementos = 10
	add $t1, $t1, $t1
	add $t1, $t1, $t1 	# Cuatruplicamos el indice bytes
	
	add $s5, $t1, $s1
	add $s5, $s5, -4	# Puntero a ultima posicion del array (Va disminuyendo)
	loop2_:
		beq $s1, $s5 done2_ # Si Solo queda un elemento, terminar
		
		
		add $t7, $zero, $ra
		jal Max
		add $ra, $zero, $t7
		
		
		lw $t5, 0($s3) 	# Cargamos el mas grande
		lw $t6, 0($s5)	# Cargamos el ultimo elemento
		
		# LOS CAMIAMOS
		sw $t6, 0($s3) # Guardamos El ultimo elemento en la posicion del mas grande
		sw $t5, 0($s5) # Guardamos El elemento mas grande ne la ultima pos
		
		addi $s2, $s2, -1
		add $s5, $s5, -4
						
		j loop2_
		
	done2_:
	jr $ra
	

Max: # FUNCION MAX PARA ORDENAMIENTO adquiere mayor elemento de una array
	# $s1 = Direccion del array
	# $s2 = Size del array (RECORTED ARRAY)
	# $s3 = DIRECCION DONDE ESTA EL MAYOR ELEMENTO
	# $t4 = MAX MAS GRANDE HASTA AHORA
	
	addiu $t1, $zero, 0	# INDICE inicializado en $t1 = 0
				# Indice en bytes = $t2
				# VALOR DEL ELEMENTO ACTUAL DEL ARRAY = $t3
				# BOOL que indica si hay nuevo max = $t5
				
	add $s3, $zero, $s1	# Set direction of max element in first element
	loop_:
		add $t1, $t1, 1		# Suma 1 al indice
		beq $t1, $s2, done_	# Si se llego al final de la lista terminar
		
		add $t2, $t1, $t1
		add $t2, $t2, $t2	# Cuatriplicar el indice para acceder al array con bytes
		add $t2, $t2, $s1 	# AHORA $t2 GUARDA LA DIRECCION DE MEMORIA DEL ELEMENTYO A ACCEDER
		
		lw $t3, 0($t2)		# Cargamos el elemento actual del array en $t3
		lw $t4, 0($s3)		# Cargamos el elemento mas grane hasta hora en $t4
			
		slt $t5, $t4, $t3	# Se guarda resultado en $t5
		beq $t5, $zero, loop_	# SI NO ES MAS GRANDE, Continua al loop
		
		add $s3, $zero, $t2	# Guardamos la DIRECCION del NUEVO elemento mas grande
		j loop_
	done_:
	jr $ra

print_arr:
	# $s1 = Direccion de memoria del array
	# $t0 = nuemro de elementos de array
	# Se usara auxiliarmente $t1 como indice, $t2 para almacenar direccion y $t3
	addiu $t1, $zero, 0	# $t1 = index = 0
				# $t2 = index (bytes)
	loop2:	
		add $t2, $t1, $t1
		add $t2, $t2, $t2	 # Cuatriplicar el indice para acceder al array con bytes
		add $t2, $t2, $s1 	# AHORA $t2 GUARDA LA DIRECCION DE MEMORIA DEL ELEMENTYO A ACCEDER
	
		lw $t3, 0($t2)		# Carga dato del array
	
		move $a0, $t3
		li $v0, 1
		syscall 		# Imprime elemento de array
	
		addi $t1, $t1, 1	 # Sumar 1 a indice
		beq $t1, $t0, done_loop2 # Si el indice de bytes es 40 Termina loop
	
		la $a0, coma	
		li $v0, 4
		syscall 		# Imprime una coma
	
		j loop2
	
	done_loop2:
		jr $ra
	

	
	