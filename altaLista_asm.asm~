
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


section .data


section .text

;/** FUNCIONES OBLIGATORIAS DE ESTUDIANTE **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;---------------------------------------------------------------------------------------------------------------

	; estudiante *estudianteCrear( char *nombre, char *grupo, unsigned int edad );
	estudianteCrear:
		;push rbp
		;mov rbp, rsp
		;push rbx
		;push r12
		;push r13
		;push r14
		;push r15

		;Guardo los parametros
		mov rbx,  rdi	; *nombre
		mov r12,  rsi 	; *grupo
		mov r13d, edx	; edad

		;Reservo memoria
		mov edi, ESTUDIANTE_SIZE
		call malloc
		mov r14, rax	; r14 = puntero a la posicion donde se guardara el estudiante

		;Creo al estudiante copiando cada parametro
		
		;pop r15
		;pop r14
		;pop r13
		;pop r12
		;pop rbx
		;pop rbp
		;ret

	; void estudianteBorrar( estudiante *e );
	estudianteBorrar:
		; COMPLETAR AQUI EL CODIGO

	; bool menorEstudiante( estudiante *e1, estudiante *e2 ){
	menorEstudiante:
		; COMPLETAR AQUI EL CODIGO

	; void estudianteConFormato( estudiante *e, tipoFuncionModificarString f )
	estudianteConFormato:
		; COMPLETAR AQUI EL CODIGO
	
	; void estudianteImprimir( estudiante *e, FILE *file )
	estudianteImprimir:
		; COMPLETAR AQUI EL CODIGO


;/** FUNCIONES DE ALTALISTA Y NODO **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;--------------------------------------------------------------------------------------------------------

	; nodo *nodoCrear( void *dato )
	nodoCrear:
		; COMPLETAR AQUI EL CODIGO

	; void nodoBorrar( nodo *n, tipoFuncionBorrarDato f )
	nodoBorrar:
		; COMPLETAR AQUI EL CODIGO

	; altaLista *altaListaCrear( void )
	altaListaCrear:
		; COMPLETAR AQUI EL CODIGO

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
	
