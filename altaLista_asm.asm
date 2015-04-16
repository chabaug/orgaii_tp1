
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
		mov rdi, r12					; paso como primer parametro el puntero al archivo
		mov rsi, estudiante	; paso el puntero al formato del string (char*)
		mov rdx, [rbx+OFFSET_NOMBRE]	; paso el puntero al nombre
		mov rcx, [rbx+OFFSET_GRUPO]		; paso el puntero al grupo
		mov r8, 0
		mov r8d, [rbx+OFFSET_EDAD]		; paso el entero
		
		;llamo a printf
		call fprintf

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
		mov [rax+OFFSET_DATO], rbx		; *dato == rbx

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
		call r12			;Llamo a tipoFuncionBorrarDato
		
		;Libero el nodo
		mov rdi, rbx			; rdi == *n
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
		; COMPLETAR AQUI EL CODIGO

	; void altaListaImprimir( altaLista *l, char *archivo, tipoFuncionImprimirDato f )
	altaListaImprimir:
		; COMPLETAR AQUI EL CODIGO


;/** FUNCIONES AVANZADAS **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;----------------------------------------------------------------------------------------------

	; float edadMedia( altaLista *l )
	edadMedia:
		; COMPLETAR AQUI EL CODIGO

	; void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f )
	insertarOrdenado:
		; COMPLETAR AQUI EL CODIGO

	; void filtrarAltaLista( altaLista *l, tipoFuncionCompararDato f, void *datoCmp )
	filtrarAltaLista:
		; COMPLETAR AQUI EL CODIGO

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
		mov rbx, rdi	;Backup de puntero al string
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
	
