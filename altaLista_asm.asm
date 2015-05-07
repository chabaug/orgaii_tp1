
; ESTUDIANTE
	global estudianteCrear
	global estudianteBorrar
	global menorEstudiante
	global estudianteConFormato
	global estudianteImprimir
	
; ALTALISTA y NODO
	global nodoCrear
	global nodoBorrar
	global altaListaCrear
	global altaListaBorrar
	global altaListaImprimir

; AVANZADAS
	global edadMedia
	global insertarOrdenado
	global filtrarAltaLista

; AUXILIARES
	global string_copiar
	global string_longitud
	global string_menor
	global insertarAdelante
 
; YA IMPLEMENTADAS EN C
	extern string_iguales
	extern insertarAtras
	extern malloc
	extern free
	extern fopen
	extern fclose
	extern fputs
	extern fprintf
	extern printf

; /** DEFINES **/    >> SE RECOMIENDA COMPLETAR LOS DEFINES CON LOS VALORES CORRECTOS
	%define NULL 	0
	%define TRUE 	1
	%define FALSE 	0

	%define ALTALISTA_SIZE     		16
	%define OFFSET_PRIMERO 			0
	%define OFFSET_ULTIMO  			8

	%define NODO_SIZE     			24
	%define OFFSET_SIGUIENTE   		0
	%define OFFSET_ANTERIOR   		8
	%define OFFSET_DATO 			16

	%define ESTUDIANTE_SIZE  		20
	%define OFFSET_NOMBRE 			0
	%define OFFSET_GRUPO  			8
	%define OFFSET_EDAD 			16


section .rodata

	estudiante: DB "%s", 10, 9, "%s", 10, 9, "%u", 10,0
	append_mode: DB "a+",0
	vacia: DB "<vacia>", 10,0

section .data


section .text

;/** FUNCIONES OBLIGATORIAS DE ESTUDIANTE **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;---------------------------------------------------------------------------------------------------------------

	; estudiante *estudianteCrear( char *nombre, char *grupo, unsigned int edad );
	estudianteCrear:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14

		;Guardo los parametros
		mov rbx,  rdi	; *nombre
		mov r12,  rsi 	; *grupo
		mov r13d, edx	; edad

		;Reservo memoria
		mov edi, ESTUDIANTE_SIZE
		call malloc
		mov r14, rax	; r14 = puntero a la posicion donde se guardara el estudiante

		;Creo al estudiante copiando cada parametro con el auxiliar string_copiar
		;Nombre
		mov rdi, rbx			
		call string_copiar 		
		mov [r14+OFFSET_NOMBRE], rax	

		;Grupo
		mov rdi, r12			
		call string_copiar 		
		mov [r14+OFFSET_GRUPO], rax	

		;Edad (directamente despues del grupo, uso la mitad del registro)
		mov [r14+OFFSET_EDAD], r13d	
		
		; se devuelve en rax la direccion del struct estudiante creado
		mov rax, r14 			

		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; void estudianteBorrar( estudiante *e );
	estudianteBorrar:
		push rbp
		mov rbp, rsp
		push rbx
		sub rbp, 8 ;Tengo que alinear
		
		;Guardo los parametros
		mov rbx, rdi 

		;Libero cada espacio
		;Nombre
		mov rdi, [rbx+OFFSET_NOMBRE] 
		call free
	
		;Grupo
		mov rdi, [rbx+OFFSET_GRUPO]
		call free

		;Estudiante
		mov rdi, rbx
		call free
		
		add rbp, 8 ;Realineo
		pop rbx
		pop rbp
		ret

	; bool menorEstudiante( estudiante *e1, estudiante *e2 ){
	menorEstudiante:
		push rbp 
		mov rbp, rsp
		push rbx
		push r12
		push r13
		add rbp, 8 
		
		;Guardo los parametros
		mov rbx, rdi   ; *e1
		mov r12, rsi   ; *e2

		;Chequeo los nombres con el auxiliar string_iguales
 		mov rdi, [rbx+OFFSET_NOMBRE]	; rdi == *e1
		mov rsi, [r12+OFFSET_NOMBRE]	; rsi == *e2
		call string_iguales 			
		cmp rax, 0
		jne menorEstudiante.cmp_edad	; Si tienen el mismo nombre => chequeo edades, sino veo cual es menor

		;Chequeo los nombres con el auxiliar string_menor
		mov rdi, [rbx+OFFSET_NOMBRE]	; rdi == *e1
		mov rsi, [r12+OFFSET_NOMBRE]	; rsi == *e2
		call string_menor 		
		jmp menorEstudiante.terminar	; Tengo el nombre del menor estudiante

		menorEstudiante.cmp_edad:
			mov r13d, DWORD [rbx+OFFSET_EDAD]	; r13d == edad de e1
			cmp r13d, DWORD [r12+OFFSET_EDAD]	; Comparo con edad de e2
			jle menorEstudiante.ret_true		; Si edad de e1 es menor o igual, salto a devolver verdadero
			mov QWORD rax, FALSE			; Sino, devuelvo falso
			jmp menorEstudiante.terminar		; Termino

		menorEstudiante.ret_true:
			mov QWORD rax, TRUE

		menorEstudiante.terminar:

		sub rbp, 8
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; void estudianteConFormato( estudiante *e, tipoFuncionModificarString f )
	estudianteConFormato:
		push rbp
		mov rbp, rsp
		push rbx
		push r12

		;Guardo los parametros
		mov rbx, rdi	; *e
		mov r12, rsi	; f

		;Modifico el nombre
		mov rdi, [rbx+OFFSET_NOMBRE]	; rdi == nombre de e
		call r12

		;Modifico el nombre
		mov rdi, [rbx+OFFSET_GRUPO]	; rdi == grupo de e
		call r12

		pop r12
		pop rbx
		pop rbp
		ret
	
	; void estudianteImprimir( estudiante *e, FILE *file )
	estudianteImprimir:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		
		;Guardo los parametros
		mov rbx, rdi 	; *e
		mov r12, rsi	; *file

		;Paso los parametros a la funcion auxiliar fprintf
		mov rdi, r12					; rdi == *file
		mov rsi, estudiante				; Paso el formato de estudiante declarado en .rodata
		mov rdx, [rbx+OFFSET_NOMBRE]	; rdx == *nombre de e
		mov rcx, [rbx+OFFSET_GRUPO]		; rcd == *grupo de e
		mov r8, 0
		mov r8d, [rbx+OFFSET_EDAD]		; r8d == edad de e
		call fprintf					; Imprimo

		pop r12
		pop rbx
		pop rbp
		ret


;/** FUNCIONES DE ALTALISTA Y NODO **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;--------------------------------------------------------------------------------------------------------

	; nodo *nodoCrear( void *dato )
	nodoCrear:
		push rbp
		mov rbp, rsp
		push rbx
		sub rbp, 8
		
		;Guardo el parametro
		mov rbx, rdi	; *dato
		
		;Reservo memoria
		mov edi, NODO_SIZE  ; edi == tamaño de nodo
		call malloc	
		
		;Seteo los parametros del nodo
		mov QWORD [rax+OFFSET_SIGUIENTE], 0	; *siguiente == null
		mov QWORD [rax+OFFSET_ANTERIOR], 0	; *anterior == null
		mov [rax+OFFSET_DATO], rbx			; *dato == rbx

		add rbp,8
		pop rbx
		pop rbp
		ret

	; void nodoBorrar( nodo *n, tipoFuncionBorrarDato f )
	nodoBorrar:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		
		;Guardo los parametros
		mov rbx, rdi ; *n
		mov r12, rsi ; f

		;Borro el dato
		mov rdi, [rbx+OFFSET_DATO]	; rdi == dato de n
		call r12					;Llamo a tipoFuncionBorrarDato
		
		;Libero el nodo
		mov rdi, rbx				; rdi == *n
		call free
		
		pop r12
		pop rbx
		pop rbp
		ret

	; altaLista *altaListaCrear( void )
	altaListaCrear:
		push rbp
		mov rbp, rsp
		
		;Reservo memoria
		mov rdi, ALTALISTA_SIZE			; rdi == tamaño de lista
		call malloc

		;Seteo los parametros de la lista
		mov QWORD [rax+OFFSET_PRIMERO], 0 	; *primero == null
		mov QWORD [rax+OFFSET_ULTIMO],  0	; *ultimo == null

		pop rbp
		ret

	; void altaListaBorrar( altaLista *l, tipoFuncionBorrarDato f )
	altaListaBorrar:
		push rbp
		mov rbp,rsp
		push rbx
		push r12
		push r13
		push r14

		;Guardo los parametros
		mov rbx, rdi 	; rbx == *l
		mov r12, rsi 	; r12 == f

		altaListaBorrar.loop:
			cmp QWORD [rbx+OFFSET_PRIMERO], NULL 	; Recorro los nodos hasta que el puntero 
			je altaListaBorrar.free_lista 
		
			;Acomodo los nodos
			mov r13, [rbx+OFFSET_PRIMERO]			; r13 == primer nodo
			mov r14, [r13+OFFSET_SIGUIENTE]			; r14 == segundo nodo
			mov QWORD [rbx+OFFSET_PRIMERO], r14		; Apunto la direccion del primero al segundo nodo

			;Borro el nodo
			mov rdi, r13							; rdi == r13 (primer nodo)
			mov rsi, r12 							; rsi == f
			call nodoBorrar						
			jmp altaListaBorrar.loop				; Loopeo

		altaListaBorrar.free_lista:
			mov rdi, rbx							; rdi == rbx (puntero a lista)
			call free 								; Libero memoria

		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; void altaListaImprimir( altaLista *l, char *archivo, tipoFuncionImprimirDato f )
	altaListaImprimir:
		push rbp
		mov rbp,rsp
		push rbx
		push r12
		push r13
		push r14

		;Guardo los parametros
		mov rbx, rdi 	; rbx == *l
		mov r12, rsi 	; r12 == *archivo
		mov r13, rdx 	; r13 == f

		;Abro el archivo
		mov rdi, r12 			;rdi == *archivo
		mov rsi, append_mode 	;Paso el modo append declarado en .rodata
		call fopen 				;Llamo a fopen para abrir el archivo
		mov r12, rax			;rax == r12 (puntero al archivo abierto)
		
		;Chequeo si la lista tiene nodos
		cmp QWORD [rbx+OFFSET_PRIMERO], NULL 	;Esta vacia?
		je altaListaImprimir.print_vacia		;Si esta vacia => salta a .print_vacia
		mov rbx, [rbx+OFFSET_PRIMERO]			;Sino rbx == *primer nodo
		
		altaListaImprimir.print_nodo:
			mov rdi, [rbx+OFFSET_DATO]				;rdi == dato del nodo
			mov rsi, r12							;rsi == *archivo
			call r13						 		;Imprimo el dato
			cmp QWORD [rbx+OFFSET_SIGUIENTE], NULL	;El siguiente es NULL?
			je altaListaImprimir.terminar			;Si es null => salta a .terminar
			mov rbx, [rbx+OFFSET_SIGUIENTE]			;Sino rbx === *siguiente nodo
			jmp altaListaImprimir.print_nodo		;Loopeo

		altaListaImprimir.print_vacia:
			mov rdi, vacia
			mov rsi, r12
			call fputs

		altaListaImprimir.terminar:		
			mov rdi, r12				;rdi == *archivo
			call fclose					;Cierro el archivo

		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret


;/** FUNCIONES AVANZADAS **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;----------------------------------------------------------------------------------------------

	; float edadMedia( altaLista *l )
	edadMedia:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14

		;Guardo los parametros
		mov rbx, rdi		;rbx == *l

		;Seteo contadores
		mov QWORD r12, 0	;Sumatoria de edades
		mov QWORD r13, 0	;Contador de nodos

		;Chequeo si la lista tiene nodos
		cmp QWORD [rbx+OFFSET_PRIMERO], NULL 	;Esta vacia?
		je edadMedia.vacia						;Si esta vacia => salta a .vacia
		mov rbx, [rbx+OFFSET_PRIMERO]			;Sino, apunto al primer nodo para calcular
		
		edadMedia.sum_nodo:
			inc r13									;Incremento el contador de nodos
			mov r14, [rbx+OFFSET_DATO]
			add r12d, [r14+OFFSET_EDAD]				;Sumo la edad a la sumatoria de edades
			cmp QWORD [rbx+OFFSET_SIGUIENTE], 0		;Existe siguiente nodo?
			je edadMedia.div_edad					;Si no existe => tengo todos y salto a dividir
			mov rbx, [rbx+OFFSET_SIGUIENTE]		 	;Si existe, lo copio a rbx
			jmp edadMedia.sum_nodo 					;Loopeo
		
		edadMedia.vacia:
			subss xmm0, xmm0
			jmp edadMedia.terminar

		edadMedia.div_edad:
			cvtsi2ss xmm1, r13					;Convierto el contador de elementos a un float
			cvtsi2ss xmm0, r12					;Convierto la sumatoria de las edades a un float
			divss xmm0, xmm1					;Divido

		edadMedia.terminar:

		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f )
	insertarOrdenado:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		sub rbp, 8

		;Guardo los parametros
		mov rbx, rdi	;rbx == *l
		mov r12, rsi 	;r12 == *dato
		mov r13, rdx	;r13 == f

		;Chequeo si es vacia
		cmp QWORD [rbx+OFFSET_PRIMERO], NULL 	;Es vacia?
		je insertarOrdenado.puntero_lista		;Si es vacia, agrego el puntero a lista

		;Chequeo el ultimo
		mov rdi, r12							;rdi == *dato
		mov rsi, [rbx+OFFSET_ULTIMO]			;rsi == ultimo nodo
		mov rsi, [rsi+OFFSET_DATO]				;rsi == *dato
		call r13								;Comparo
		cmp QWORD rax, FALSE					;Es menor al dato?
		je insertarOrdenado.ultimo				;Si lo es => voy al ultimo

		;Comparo el primero
		mov rdi, r12 							;rdi == *dato
		mov rsi, [rbx+OFFSET_PRIMERO]			;rsi == primer nodo
		mov rsi, [rsi+OFFSET_DATO]				;rsi == *dato
		call r13								;Comparo
		cmp QWORD rax, TRUE 					;Es menor?
		je insertarOrdenado.primero 			;Si lo es => pongo el primero
		mov rbx, [rbx+OFFSET_PRIMERO]			;Sino muevo a rbx el puntero al siguiente

		insertarOrdenado.buscarPosiciones: 	
			mov rdi, r12							;rdi == *dato
			mov rsi, [rbx+OFFSET_SIGUIENTE]			;rsi == siguiente nodo
			mov rsi, [rsi+OFFSET_DATO]				;rsi == *dato
			call r13								;Comparo
			cmp QWORD rax, TRUE 					;El siguiente es mayor?
			je insertarOrdenado.insertar			;Si lo es => lo inserto
			mov rbx, [rbx+OFFSET_SIGUIENTE]			;Sino, voy al siguiente nodo (rbx == *siguiente nodo)
			jmp insertarOrdenado.buscarPosiciones 	;Loopeo

		insertarOrdenado.puntero_lista:		
			mov rdi, r12					;rdi == *dato
			call nodoCrear					;Creo un nodo nuevo con el dato, lo pongo primero y ultimo
			mov [rbx+OFFSET_PRIMERO], rax	
			mov [rbx+OFFSET_ULTIMO], rax	
			jmp insertarOrdenado.terminar

		insertarOrdenado.ultimo:			
			mov rdi, rbx					;rdi == *l
			mov rsi, r12					;rsi == *dato
			call insertarAtras				;Lo inserto atras llamando a la funcion insertarAtras
			jmp insertarOrdenado.terminar

		insertarOrdenado.primero:				
			mov rdi, rbx			 		;rdi == *l
			mov rsi, r12			 		;rsi == *dato
			call insertarAdelante	 			;Lo inserto adelante llamando a la funcion insertarAdelante
			jmp insertarOrdenado.terminar 	

		insertarOrdenado.insertar:		
			mov rdi, r12						;rdi == *dato
			call nodoCrear						;Hago un nodo con el dato en rax
			mov [rax+OFFSET_ANTERIOR], rbx		;Pongo como anterior al nodo actual
			mov r13, [rbx+OFFSET_SIGUIENTE] 	;Muevo a r13 el puntero al siguiente nodo
			mov [rax+OFFSET_SIGUIENTE], r13		;Lo pongo como siguiente del nuevo nodo
			mov [rbx+OFFSET_SIGUIENTE], rax 	;Pongo al nodo actual como siguiente al nuevo nodo
			mov [r13+OFFSET_ANTERIOR], rax 		;Pongo como anterior del siguiente nodo al nuevo nodo

		insertarOrdenado.terminar:

		add rbp, 8	
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; void filtrarAltaLista( altaLista *l, tipoFuncionCompararDato f, void *datoCmp )
	filtrarAltaLista:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r15

		;Guardo los parametros
		mov rbx, rdi	;rbx == *l
		mov r12, rsi 	;r12 == f
		mov r13, rdx	;r13 == *datoCmp

		;Es vacia?
		cmp QWORD [rbx+OFFSET_PRIMERO], NULL 	
		je filtrarAltaLista.terminar			;Si es vacia, termine
		mov r15, [rbx+OFFSET_PRIMERO]			;Sino, apunto al primer nodo

		filtrarAltaLista.comparar:
			mov rdi, [r15+OFFSET_DATO]				;rdi == puntero al dato del nodo
			mov rsi, r13							;rsi == *datoCmp
			call r12								;Llamo a tipoFuncionCompararDato
			cmp QWORD rax, FALSE 					;Si da falso => borro el nodo
			je filtrarAltaLista.borrar				
			cmp QWORD [r15+OFFSET_SIGUIENTE], NULL 	;Chequeo si hay siguiente
			je filtrarAltaLista.terminar 			;Si no hay, termine
			mov r15, [r15+OFFSET_SIGUIENTE]			;Si hay, muevo el puntero
			jmp filtrarAltaLista.comparar			;Loopeo

		filtrarAltaLista.borrar:					;r15 = puntero del nodo a borrar
			cmp QWORD [r15+OFFSET_ANTERIOR], NULL 	;Me fijo si hay anterior
			je filtrarAltaLista.primero 			;Si no hay tengo que borrar el primerNodo
			cmp QWORD [r15+OFFSET_SIGUIENTE], NULL 	;Me fijo si hay siguiente
			je filtrarAltaLista.ultimo  			;Si no hay tengo que borrar el ultimo nodo
			mov rdi, [r15+OFFSET_ANTERIOR]			;Muevo a rdi el puntero al nodo anterior
			mov rsi, [r15+OFFSET_SIGUIENTE]			;Muevo a rdi el puntero al siguiente nodo
			mov [rdi+OFFSET_SIGUIENTE], rsi			;Pongo como nodo siguiente del anterior al nodo siguiente (nodo_a_borar->anterior->siguiente = nodo_a_borrar->siguiente)
			mov [rsi+OFFSET_ANTERIOR], rdi			;Pongo como nodo anterior del siguiente al nodo anterior (nodo_a_borrar->siguiente->anterior = nodo_a_borrar->anterior)
			mov rdi, r15							;Muevo el puntero al nodo a borrar en rdi
			mov QWORD r15, [r15+OFFSET_SIGUIENTE]	;Muevo el puntero al siguiente nodo a r15
			mov rsi, estudianteBorrar				;Muevo un puntero a la funcion estudianteBorrar
			call nodoBorrar 						;Borro el nodo que tenia que borrar
			jmp filtrarAltaLista.comparar			;Me fijo si el siguiente nodo cumple con la condicion

		filtrarAltaLista.primero:					;r15 = puntero del nodo a borrar, rbx = puntero a la lista
			mov rdi, [r15+OFFSET_SIGUIENTE]			;Muevo a rdi el puntero al siguiente nodo
			mov [rbx+OFFSET_PRIMERO], rdi			;Pongo como primer nodo al siguiente nodo
			cmp QWORD [r15+OFFSET_SIGUIENTE], NULL 	;Si no hay siguiente
			je filtrarAltaLista.unico				;Entonces tengo que borrar el unico nodo de la lista
			mov QWORD [rdi+OFFSET_ANTERIOR], NULL 	;sino seteo el anterior del siguiente en null (nodo_a_borrar->siguiente->anterior = NULL)
			mov rdi, r15							;Muevo el puntero al nodo a borra a rdi
			mov r15, [r15+OFFSET_SIGUIENTE]			;Muevo el puntero al siguiente a r15
			mov rsi, estudianteBorrar				;Muevo un puntero a la funcion estudianteBorrar
			call nodoBorrar 						;Borro el nodo
			jmp filtrarAltaLista.comparar			;Me fijo si el siguiente nodo cumple con la condicion

		filtrarAltaLista.ultimo:					;r15 = puntero del nodo a borrar, rbx = el puntero a lista
			mov rdi, [r15+OFFSET_ANTERIOR]			;Muevo a rdi el puntero al anterior
			mov QWORD [rdi+OFFSET_SIGUIENTE], NULL 	;Seteo a null el siguiente del nodo anterior

		filtrarAltaLista.unico:
			mov [rbx+OFFSET_ULTIMO], rdi			;Muevo el puntero al ultimo nodo al nodo anterior	
			mov rdi, r15 							;Muevo a rdi el puntero al nodo a borrar
			mov rsi, estudianteBorrar				;Muevo a rsi un puntero a la funcion estudianteBorrar
			call nodoBorrar 

		filtrarAltaLista.terminar:

		pop r15
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret		

;/** FUNCIONES AUXILIARES **/
;----------------------------

	; unsigned char string_longitud( char *s )
	string_longitud:
		; el puntero a char esta en rdi
		push rbp
		mov rbp, rsp

		mov rax, 0 	; inicializo el contador

		string_longitud.sumar:		; ciclo que suma direccion a direccion
			cmp BYTE [rdi+rax], 0		; chequea si el byte de la direccion del string es cero
			jz string_longitud.terminar	; if [rdi+rax] == 0 => terminar
			inc rax				; else rax++
			jmp string_longitud.sumar	; repite

		string_longitud.terminar:	; cuando termina el ciclo
			pop rbp
			ret
	
	; en rax tengo la longitud del string

	
	string_copiar: 
		; en rdi esta el puntero al char;
		;rax va a guardar el puntero a la primer dirección de la string pasada por copia
		push rbp 
		mov rbp, rsp
		push rbx
		push r12
		
		;Guardo los parametros
		mov rbx, rdi	;rbx == *c
		
		; Calculo la longitud del string a copiar
		call string_longitud 	
		mov r12, rax 		
		inc r12
		
		; Reservo memoria
		mov rdi, r12	; Pido el tamaño del string
		call malloc	
		mov BYTE [rax+r12-1], 0
		dec r12
		cmp r12, 0
		jz string_copiar.terminar	; si vale cero, termino
		mov rcx, r12 			; el contador tiene el tamaño del string para copiar desde atras 
		string_copiar.loop:
			mov r12b, [rbx+rcx-1]
			mov [rax+rcx-1], r12b
			loop string_copiar.loop

		string_copiar.terminar:

		pop r12
		pop rbx
		pop rbp
		ret
	

	;bool string_menor( char *s1, char *s2 );
	string_menor: 
		push rbp 
		mov rbp, rsp
		push rbx
		sub rbp, 8

		mov rbx, 0 ;rbx = contador
		
		string_menor.iguales:
		 	mov cl, BYTE [rdi+rbx]		;cl == *s1
		 	cmp cl, BYTE [rsi+rbx]		;Comparo con *s2
			jl string_menor.true		;*s1<*s2 => TRUE
			jg string_menor.false		;*s1>*s2 => FALSE
			cmp cl, 0			;*s1== 0 => FALSE
			jz string_menor.false	
			inc rbx				;rbx++
			jmp string_menor.iguales	;Loopeo

		string_menor.true:
		 	mov QWORD rax, TRUE		;rax == TRUE
		 	jmp string_menor.terminar
		
		string_menor.false:
		 	mov QWORD rax, FALSE		;rax == FALSE

		string_menor.terminar:

		add rbp, 8
		pop rbx
		pop rbp
		ret

	;void insertarAdelante(altaLista* l, dato* d);
	insertarAdelante:

		push rbp
		mov rbp, rsp
		push rbx
		push r12
	
		;Guardo los parametros
		mov rbx, rdi ;rbx == *l 
		mov r12, rsi ;r12 == *d

		;Creo el nodo
		mov rdi, r12		;rdi == *d
		call nodoCrear		
		
		;Chequeo si es vacia la lista
		cmp WORD [rbx+OFFSET_PRIMERO], 0	;Si es vacia, agrego el nodo
		jz insertarAdelante.uno			
		
		;Si no es vacia
		mov r12, [rbx+OFFSET_PRIMERO]		;r12 == *primero
		mov [rbx+OFFSET_PRIMERO], rax 		;puntero al nuevo nodo
		mov [r12+OFFSET_ANTERIOR], rax		;puntero al anterior del ex-primer nodo == nuevo nodo
		mov [rax+OFFSET_SIGUIENTE], r12		;puntero al siguiente == ex-primer nodo
		jmp insertarAdelante.terminar
		
		insertarAdelante.uno:
			mov [rbx+OFFSET_PRIMERO], rax	;nuevo nodo == primer nodo
			mov [rbx+OFFSET_ULTIMO], rax	;nuevo nodo == ultimo nodo

		insertarAdelante.terminar:

		pop r12
		pop rbx
		pop rbp
		ret


