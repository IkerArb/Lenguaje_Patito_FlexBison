%{
#include <cstdio>
#include <iostream>
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	float fval;
	char *sval;
}

%token PROG
%token IF
%token THEN
%token ELSE
%token PROC
%token END
%token INT
%token FLOAT
%token WHILE
%token READ
%token PRINT
%token VAR
%token NOTEQ
%token LTEQ
%token GTEQ

// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <ival> CTEED
%token <fval> CTEF
%token <sval> CTES
%token <sval> CTEEB
%token <sval> ID
%token <sval> COMMENT
%token <sval> CTEEH

%%
// this is the actual grammar that bison will parse, but for right now it's just
// something silly to echo to the screen what bison gets from flex.  We'll
// make a real one shortly:
programa:
	PROG ID ';' v bloque { cout << "done with the file!" << endl; }
	;
v:
  %empty
  | vars {cout << "declared variable"<<endl;}
  ;

vars:
  VAR a
  ;

a:
  b ':' tipo ';' f
  ;

f:
  %empty
  | a
  ;

b:
  ID c
  ;

c:
  %empty
  | ',' b
  ;

tipo:
  INT
  | FLOAT
  ;

bloque:
  '{' d '}' {cout << "bloque codificado exitosamente"<<endl;}
  ;

d:
  %empty {cout << "se acabó el bloque"<<endl;}
  | estatuto d {cout << "se manda a llamar a estatuto"<<endl;}
  ;

estatuto:
  asignacion {cout << "estatuto de asignacion"<< endl;}
  | condicion
  | escritura
  ;

asignacion:
  ID '=' expresion ';'{cout<< "se asignó la variable "<<$1<<endl;}
  ;

expresion:
  exp i
  ;

i:
  %empty
  | '>' exp
  | '<' exp
  | NOTEQ exp
  ;

escritura:
  PRINT '(' g ')' ';'
  ;

g:
  expresion h
  | CTES h
  ;

h:
  %empty
  | ',' g
  ;

exp:
  termino k
  ;

k:
  %empty
  | '+' exp
  | '-' exp
  ;

factor:
  '(' expresion ')'
  | m varcte {cout << "factor reconocido correctamente"<<endl;}
  ;

m:
  %empty
  | '+'
  | '-'
  ;

condicion:
  IF '(' expresion ')' bloque j ';'
  ;

j:
  %empty
  | ELSE bloque
  ;

termino:
  factor l
  ;

l:
  %empty
  | '*' termino
  | '/' termino
  ;

varcte:
  ID {cout << "se encontró un id "<<$1<<endl;}
  | CTEED {cout << "se encontró una variable decimal "<<$1<<endl;}
  | CTEF {cout << "se encontró una variable flotante "<<$1<<endl;}

%%

int main(int argc, char* argv[]) {
	// open a file handle to a particular file:
	FILE *myfile = fopen(argv[1], "r");
	// make sure it's valid:
	if (!myfile) {
		cout << "Error reading file" << endl;
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;

  // parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
}

void yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}
