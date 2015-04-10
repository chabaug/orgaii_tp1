#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include "altaLista.h"

altaLista* getAltaListaMixta( int );
void altaListaReverso( altaLista* );
void testearInvariante( altaLista*, char* );
void estudianteImprimirCatedra( estudiante*, FILE* );
float EPS = 0.001;
void string_a_oracion( char* );
void string_reverse_case( char* );
bool mismoGrupo( estudiante*, estudiante* );
void altaListaConFormato( altaLista*, tipoFuncionModificarString );
bool mayorEstudiante( estudiante*, estudiante* );
altaLista *armarGrupo( altaLista*, char* );
altaLista *altaListaCopiar( altaLista* );
char *archivoCaso1 =  "salida.caso1.txt";
char *archivoCaso2 =  "salida.caso2.txt";
char *archivoCasoN =  "salida.casoN.txt";
void caso1Elemento();
void caso2Elementos();
void casoNElementos();

int main() {
  srand(20140831);
  remove("salida.caso1.txt");
  caso1Elemento();
  remove("salida.caso2.txt");
  caso2Elementos();
  remove("salida.casoN.txt");
  casoNElementos();
  return 0;
}

altaLista* getAltaListaMixta( int nmax ){
	altaLista* res = altaListaCrear();

	char* grupos[] = { "Vacio Vegetariano Con Morcilla Desangrada", "Vacio", "Tira De Asado", "Sanguche Vegetariano", 
						"Parrillita De Vegetales", "Parrillada para Dos", "Nalga", "Mollejas", 
						"Matambrito Tiernizado", "La Hamburguesa Unica", "Entrania", "Costillitas", 
						"Chinchupan", "Bondolita Al Limon", "Bondiola", "Bife De Chorizo" };
	
	char* estudiantes[] = { "abel", "agustina", "alejandro", 
							"zaida", "alexander", "alfredo", 
							"andreas", "antonella", "augusto", "belen", "carolina", 
							"christian", "emiliano", "enrique", 
							"fabian", "fabricio", "facundo", "federico",
							"fernando", "francisco", "franco", "gabriel", 
							"german", "gisela", "gomez", "gustavo",
							"hector","ignacio", "javier", "jose", "julian", 
							"leila", "luis rolando", "manuel", 
							"martin", "martin esteban","matias", 
							"maximiliano", "miguel ignacio", "natalia", 
							"nicolas", "pablo", "patricio", "paula", 
							"sebastian", "sebastian matias", "tomas", "catriel" };

	unsigned int edades[] = { 18, 19, 20, 21, 22, 23, 24, 30, 35, 40, 45 };

	for( int i = 0 ; i < nmax ; i++ ){
		estudiante *nuevoEstudiante = estudianteCrear( 	estudiantes[rand()%48], 
											grupos[rand()%16], 
											edades[rand()%11] );
		insertarOrdenado( res, nuevoEstudiante, (tipoFuncionCompararDato)menorEstudiante );
	}
	return res;
}

void altaListaReverso( altaLista *l ){
	if( (l == NULL) || (l->primero == NULL) )
		return;
	nodo *viejoPrimero = l->primero;
	l->primero = l->ultimo;
	l->ultimo = viejoPrimero;
	nodo *nodoActual = l->primero;
	nodo *viejoAnterior = nodoActual->anterior;
	while( viejoAnterior != NULL ){
		nodoActual->siguiente = viejoAnterior;
		nodo *viejoAnteriorAnterior = viejoAnterior->anterior;
		viejoAnterior->anterior = nodoActual;
		nodoActual = viejoAnterior;
		viejoAnterior = viejoAnteriorAnterior;        
	}
	(l->ultimo)->siguiente = NULL;
	(l->primero)->anterior = NULL;
	return;
}

void testearInvariante( altaLista* l, char *archivo ){
	altaListaReverso( l ); 
	altaListaImprimir( l, archivo, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
	altaListaReverso( l ); 
}

void estudianteImprimirCatedra( estudiante *e, FILE *file ){
	fprintf( file, "%s | ", e->nombre );
	fprintf( file, "%s | ", e->grupo );
	fprintf( file, "%d\n", e->edad );
	return;
}

void string_a_oracion( char *s ){
	s[0] = toupper( s[0] );
	for (unsigned int i = 1; i < strlen(s); i++)
		s[i] = tolower( s[i] );
}

void string_reverse_case( char *s ){
	for (unsigned int i = 0; i < strlen(s); i++)
		if( isupper( s[i] ) ) s[i] = tolower( s[i] );
			else s[i] = toupper( s[i] );
}

altaLista *altaListaCopiar( altaLista *l ){
	altaLista *nuevaLista = altaListaCrear();
	nodo *n = l->primero;
	while( n != NULL ){
		estudiante *nuevoEstudiante = estudianteCrear( ((estudiante*)(n->dato))->nombre, ((estudiante*)(n->dato))->grupo, ((estudiante*)(n->dato))->edad );
		insertarAtras( nuevaLista, nuevoEstudiante );
		n = n->siguiente;
	}
	return nuevaLista;
}

bool mismoGrupo( estudiante *e1, estudiante *e2 ){
	if( string_iguales( e1->grupo, e2->grupo) )
		return true;
	return false;
}

void altaListaConFormato( altaLista *l, tipoFuncionModificarString f ){
	nodo *n = l->primero;
	while( n != NULL ){
		estudianteConFormato( n->dato, f );
		n = n->siguiente;
	}
	return;
}

bool mayorEstudiante( estudiante *e1, estudiante *e2 ){
	return !menorEstudiante( e1, e2 );
}

altaLista *armarGrupo( altaLista *l, char *grupo ){
	// 1) COPIA: me genero copia de la lista para no modificarlo con el FILTRAR
		altaLista *nuevaLista = altaListaCopiar( l );
	// 2) ORACION: paso todos sus estudiantes al formato oracion
		altaListaConFormato( nuevaLista, string_a_oracion );
		// genero un estudiante cualquiera con el GRUPO que me interesa, NOMBRE y EDAD no me interesan porque voy a usar MismoGrupo. Paso el estudiante al formato oracion
		estudiante *estudianteConGrupo = estudianteCrear( "NO-ME-IMPORTA", grupo, 99 ); estudianteConFormato( estudianteConGrupo, string_a_oracion );
	// 3) FILTRO: filtro la lista y me quedaron sólo los que tienen = grupo
		filtrarAltaLista( nuevaLista, (tipoFuncionCompararDato)mismoGrupo, estudianteConGrupo );
	// 4) ORDENO: genero la nueva lista de retorno en la que voy a insertar ordenado
		altaLista *listaFinal = altaListaCrear(); nodo *ni = nuevaLista->primero;
		while( ni != NULL ){
			estudiante *nuevoEstudiante = estudianteCrear( ((estudiante*)(ni->dato))->nombre, ((estudiante*)(ni->dato))->grupo, ((estudiante*)(ni->dato))->edad );
			insertarOrdenado( listaFinal, nuevoEstudiante, (tipoFuncionCompararDato)menorEstudiante );
			ni = ni->siguiente;
		}		
	// 5) BORRO: borro las cosas que cree son dinamicas...
		estudianteBorrar( estudianteConGrupo ); altaListaBorrar( nuevaLista,(tipoFuncionBorrarDato)estudianteBorrar );
	// 6) RETORNO: 
		return listaFinal;
}

void caso1Elemento(){
	FILE *pFile; altaLista *A = altaListaCrear();
	estudiante *PascualConFormato = estudianteCrear( "pascual", "alto grupo", 21 );
	pFile = fopen ( archivoCaso1, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO ESTUDIANTE-CON-FORMATO\n", pFile ); fclose( pFile );
	estudianteConFormato( PascualConFormato, string_a_oracion );
	pFile = fopen ( archivoCaso1, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO INSERTAR-ORDENADO\n", pFile ); fclose( pFile );
	insertarOrdenado( A, PascualConFormato, (tipoFuncionCompararDato)menorEstudiante );
	altaListaImprimir( A, archivoCaso1, (tipoFuncionImprimirDato)estudianteImprimir );
  	pFile = fopen ( archivoCaso1, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO EDAD-MEDIA\n", pFile ); fclose( pFile );
  	pFile = fopen ( archivoCaso1, "a" ); fprintf( pFile, "edadMedia: %2.5f\n", edadMedia( A ) ); fclose( pFile );
  	pFile = fopen ( archivoCaso1, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO ESTUDIANTE-IMPRIMIR\n", pFile ); fclose( pFile );
	pFile = fopen ( archivoCaso1, "a" ); estudianteImprimir( PascualConFormato, pFile ); fclose( pFile );
	pFile = fopen ( archivoCaso1, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO ALTALISTA-IMPRIMIR\n", pFile ); fclose( pFile );
	altaListaImprimir( A, archivoCaso1, (tipoFuncionImprimirDato)estudianteImprimir );
	altaListaImprimir( A, archivoCaso1, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
  	pFile = fopen ( archivoCaso1, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO ALTALISTA-FILTRAR\n", pFile ); fclose( pFile );
	altaLista *B = armarGrupo( A, "grupo" );
	altaListaImprimir( B, archivoCaso1, (tipoFuncionImprimirDato)estudianteImprimir );
	altaLista *C = armarGrupo( A, "alto grupo" );
	altaListaImprimir( C, archivoCaso1, (tipoFuncionImprimirDato)estudianteImprimir );
	estudiante *Pascualito = estudianteCrear( "pascua", "alto grupo", 22 );
	estudianteConFormato( Pascualito, string_a_oracion );
	filtrarAltaLista( A, (tipoFuncionCompararDato)menorEstudiante, Pascualito );
	altaListaImprimir( A, archivoCaso1, (tipoFuncionImprimirDato)estudianteImprimir );
  	pFile = fopen ( archivoCaso1, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO INVARIANTE DE ALTALISTA\n", pFile ); fclose( pFile );
  	testearInvariante( C, archivoCaso1 );
  	pFile = fopen ( archivoCaso1, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO BORRAR ESTUDIANTE Y ALTALISTA\n", pFile ); fclose( pFile );
	estudianteBorrar( Pascualito );
	altaListaBorrar( A, (tipoFuncionBorrarDato)estudianteBorrar );
	altaListaBorrar( B, (tipoFuncionBorrarDato)estudianteBorrar );
	altaListaBorrar( C, (tipoFuncionBorrarDato)estudianteBorrar );
}

void caso2Elementos() {
	FILE *pFile; altaLista* A = altaListaCrear();
	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO MENOR-ESTUDIANTE\n", pFile ); fclose( pFile );
	estudiante *Abel = estudianteCrear( "ABEL", "VACIO", 22 );
	estudiante *Agustina = estudianteCrear( "AGUSTINA", "TIRA DE ASADO", 23 );
	estudiante *HermanaAgustina = estudianteCrear( "AGUSTINA", "CHULETTA", 24 );
	assert( menorEstudiante( Abel, Agustina ) );
	assert( !menorEstudiante( HermanaAgustina, Agustina ) );
	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO INSERTAR-ORDENADO\n", pFile ); fclose( pFile );
	insertarOrdenado( A, Abel, (tipoFuncionCompararDato)menorEstudiante );
	insertarOrdenado( A, Agustina, (tipoFuncionCompararDato)menorEstudiante );
	altaListaImprimir( A, archivoCaso2, (tipoFuncionImprimirDato)estudianteImprimir );
  	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO EDAD-MEDIA\n", pFile ); fclose( pFile );
  	pFile = fopen ( archivoCaso2, "a" ); fprintf( pFile, "edadMedia: %2.5f\n", edadMedia( A ) ); fclose( pFile );
  	assert( fabsf( edadMedia( A ) - 22.500 ) < EPS );
	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO ESTUDIANTE-CON-FORMATO\n", pFile ); fclose( pFile );
	altaListaConFormato( A, string_a_oracion ); altaListaConFormato( A, string_reverse_case );
  	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO INVARIANTE DE ALTALISTA\n", pFile ); fclose( pFile );
  	testearInvariante( A, archivoCaso2 );
  	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO ALTALISTA-FILTRAR\n", pFile ); fclose( pFile );
	altaLista *B = armarGrupo( A, "tira de asado" );
	altaListaImprimir( B, archivoCaso2, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
  	pFile = fopen ( archivoCaso2, "a" ); fputs( ".................\n", pFile ); fclose( pFile );
	altaLista *C = armarGrupo( A, "vacio" );
	altaListaImprimir( C, archivoCaso2, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
  	pFile = fopen ( archivoCaso2, "a" ); fputs( ".................\n", pFile ); fclose( pFile );
	altaLista *D = armarGrupo( A, "chuletta" );
	altaListaImprimir( D, archivoCaso2, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
	estudiante *OtraHermanaAgustina = estudianteCrear( "AGUSTINA", "provoletta", 22 );
	estudianteConFormato( OtraHermanaAgustina, string_a_oracion );
	estudianteConFormato( OtraHermanaAgustina, string_reverse_case );
	pFile = fopen ( archivoCaso2, "a" ); fputs( "....antes.......\n", pFile ); fclose( pFile );
	altaListaImprimir( A, archivoCaso2, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
	filtrarAltaLista( A, (tipoFuncionCompararDato)menorEstudiante, OtraHermanaAgustina );
	pFile = fopen ( archivoCaso2, "a" ); fputs( "....despues.......\n", pFile ); fclose( pFile );
	altaListaImprimir( A, archivoCaso2, (tipoFuncionImprimirDato)estudianteImprimir );
  	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO INVARIANTE DE ALTALISTA\n", pFile ); fclose( pFile );
  	testearInvariante( A, archivoCaso2 );
  	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO ALTALISTA-FILTRAR\n", pFile ); fclose( pFile );
	insertarOrdenado( A, OtraHermanaAgustina, (tipoFuncionCompararDato)menorEstudiante );
	estudiante *PrimaAgustina = estudianteCrear( "valeria", "chinchulin", 29 );
	estudiante *Andres = estudianteCrear( "andres", "chorizo", 15 );
	estudianteConFormato( PrimaAgustina, string_a_oracion ); estudianteConFormato( PrimaAgustina, string_reverse_case ); estudianteConFormato( Andres, string_a_oracion ); estudianteConFormato( Andres, string_reverse_case );
	insertarOrdenado( A, PrimaAgustina, (tipoFuncionCompararDato)menorEstudiante );
	pFile = fopen ( archivoCaso2, "a" ); fputs( "....antes.......\n", pFile ); fclose( pFile );
	altaListaReverso( A ); altaListaImprimir( A, archivoCaso2, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
	filtrarAltaLista( A, (tipoFuncionCompararDato)menorEstudiante, Andres );
	pFile = fopen ( archivoCaso2, "a" ); fputs( "....despues.......\n", pFile ); fclose( pFile );
	altaListaImprimir( A, archivoCaso2, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
  	pFile = fopen ( archivoCaso2, "a" ); fputs( ">>>>>>>>>>>>>>>> PROBANDO INVARIANTE DE ALTALISTA\n", pFile ); fclose( pFile );
  	testearInvariante( A, archivoCaso2 );
	estudianteBorrar( HermanaAgustina ); estudianteBorrar( Andres );
	altaListaBorrar( A, (tipoFuncionBorrarDato)estudianteBorrar );
	altaListaBorrar( B, (tipoFuncionBorrarDato)estudianteBorrar );
	altaListaBorrar( C, (tipoFuncionBorrarDato)estudianteBorrar );
	altaListaBorrar( D, (tipoFuncionBorrarDato)estudianteBorrar );
}

void casoNElementos() {
	FILE *pFile; pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO INSERTAR-ORDENADO\n", pFile ); fclose( pFile );
 	altaLista* Todos = getAltaListaMixta( 5000 ); altaListaImprimir( Todos, archivoCasoN, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
  	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO EDAD-MEDIA\n", pFile ); fclose( pFile );
	assert( fabsf( edadMedia( Todos ) - 27.099 ) < EPS );
	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO ESTUDIANTE-CON-FORMATO\n", pFile ); fclose( pFile );
	altaListaConFormato( Todos, string_a_oracion );
  	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO INVARIANTE DE ALTALISTA\n", pFile ); fclose( pFile );
  	testearInvariante( Todos, archivoCasoN );
  	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO ALTALISTA-FILTRAR\n", pFile ); fclose( pFile );
	altaLista *grupoParrilladaParaDos = armarGrupo( Todos, "parrillada para dos" );
	altaLista *grupoMatambritoTiernizado = armarGrupo( Todos, "matambrito tiernizado" );
	altaLista *grupoParrillitaDeVegetales = armarGrupo( Todos, "parrillita de vegetales" );
	altaListaImprimir( grupoParrilladaParaDos, archivoCasoN, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
	altaListaImprimir( grupoMatambritoTiernizado, archivoCasoN, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
	altaListaImprimir( grupoParrillitaDeVegetales, archivoCasoN, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
  	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO EDAD-MEDIA\n", pFile ); fclose( pFile );
	assert( fabsf( edadMedia( grupoParrilladaParaDos ) - 26.641 ) < EPS );
	assert( fabsf( edadMedia( grupoMatambritoTiernizado ) - 27.104 ) < EPS );
	assert( fabsf( edadMedia( grupoParrillitaDeVegetales ) - 27.306 ) < EPS );
  	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO ALTALISTA-FILTRAR\n", pFile ); fclose( pFile );
	estudiante *Pamela = estudianteCrear( "pamela", "chinchulin", 18 ); estudianteConFormato( Pamela, string_a_oracion );
	pFile = fopen ( archivoCasoN, "a" ); fputs( "........................antes.......\n", pFile ); fclose( pFile );
	altaListaImprimir( grupoParrillitaDeVegetales, archivoCasoN, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
	filtrarAltaLista( grupoParrillitaDeVegetales, (tipoFuncionCompararDato)menorEstudiante, Pamela );
	pFile = fopen ( archivoCasoN, "a" ); fputs( "........................despues.......\n", pFile ); fclose( pFile );
	altaListaImprimir( grupoParrillitaDeVegetales, archivoCasoN, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
  	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO INVARIANTE DE ALTALISTA\n", pFile ); fclose( pFile );
	testearInvariante( grupoParrillitaDeVegetales, archivoCasoN );
  	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO ALTALISTA-FILTRAR\n", pFile ); fclose( pFile );
	altaListaReverso( grupoMatambritoTiernizado );
	estudiante *HermanaZaida = estudianteCrear( "zaira", "matambrito a la fugazetta", 30 ); estudianteConFormato( HermanaZaida, string_a_oracion );
	estudiante *MamaZaida = estudianteCrear( "zafiro", "matambrito a la napolitana", 57 ); estudianteConFormato( MamaZaida, string_a_oracion );
	insertarAtras( grupoMatambritoTiernizado, HermanaZaida );
	pFile = fopen ( archivoCasoN, "a" ); fputs( "........................antes.......\n", pFile ); fclose( pFile );
	altaListaImprimir( grupoMatambritoTiernizado, archivoCasoN, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
	filtrarAltaLista( grupoMatambritoTiernizado, (tipoFuncionCompararDato)mayorEstudiante, MamaZaida );
	pFile = fopen ( archivoCasoN, "a" ); fputs( "........................despues.......\n", pFile ); fclose( pFile );
	altaListaImprimir( grupoMatambritoTiernizado, archivoCasoN, (tipoFuncionImprimirDato)estudianteImprimirCatedra );
  	pFile = fopen ( archivoCasoN, "a" ); fputs( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PROBANDO INVARIANTE DE ALTALISTA\n", pFile ); fclose( pFile );
  	testearInvariante( grupoMatambritoTiernizado, archivoCasoN );
  	estudianteBorrar( MamaZaida ); estudianteBorrar( Pamela );
	altaListaBorrar( grupoParrilladaParaDos, (tipoFuncionBorrarDato)estudianteBorrar );
	altaListaBorrar( grupoMatambritoTiernizado, (tipoFuncionBorrarDato)estudianteBorrar );
	altaListaBorrar( grupoParrillitaDeVegetales, (tipoFuncionBorrarDato)estudianteBorrar );
	altaListaBorrar( Todos, (tipoFuncionBorrarDato)estudianteBorrar );
}

