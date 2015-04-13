
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
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14
		push r15



		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

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

	
		
