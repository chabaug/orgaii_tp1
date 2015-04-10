#include <stdbool.h>
#include <stdio.h>


/** Tipos altaLista, nodo y estudiante **/

	typedef struct lista_t {
		struct nodo_t	*primero;
		struct nodo_t	*ultimo;
	} __attribute__((__packed__)) altaLista;

	typedef struct nodo_t {
		struct nodo_t	*siguiente;
		struct nodo_t	*anterior;
		void			*dato;
	} __attribute__((__packed__)) nodo;

	typedef struct estudiante_t {
		char			*nombre;
		char			*grupo;
		unsigned int	edad; 
	} __attribute__((__packed__)) estudiante;        


/** Definiciones de punteros a funciones **/

	typedef void (*tipoFuncionBorrarDato) (void*);
	typedef void (*tipoFuncionImprimirDato) (void*, FILE*);
	typedef bool (*tipoFuncionCompararDato) (void*, void*);
	typedef void (*tipoFuncionModificarString) (char*);


/** Funciones de estudiante **/

	estudiante *estudianteCrear( char *nombre, char *grupo, unsigned int edad );
	void estudianteBorrar( estudiante *e );
	bool menorEstudiante( estudiante *e1, estudiante *e2 );
	void estudianteConFormato( estudiante *e, tipoFuncionModificarString f );
	void estudianteImprimir( estudiante *e, FILE *file );


/** Funciones de altaLista y nodo **/

	nodo *nodoCrear( void *dato );
	void nodoBorrar( nodo *n, tipoFuncionBorrarDato f );
	altaLista *altaListaCrear( void );
	void altaListaBorrar( altaLista *l, tipoFuncionBorrarDato f );
	void altaListaImprimir( altaLista *l, char *archivo, tipoFuncionImprimirDato f );
	

/** Funciones Avanzadas **/

	float edadMedia( altaLista *l );
	void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f );
	void filtrarAltaLista( altaLista *l, tipoFuncionCompararDato f, void *datoCmp );


/** Funciones Auxiliares Sugeridas **/

	unsigned char string_longitud( char *s );
	char *string_copiar( char *s );
	bool string_menor( char *s1, char *s2 );


/** Funciones Auxiliares ya implementadas en C **/

	bool string_iguales( char *s1, char *s2 );											
	void insertarAtras( altaLista *l, void *dato );
