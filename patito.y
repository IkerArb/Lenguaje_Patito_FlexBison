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
	PROG ID ';' v bloque { cout << "done with a snazzle file!" << endl; }
	;
v:
  %empty
  | vars
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
  '{' d '}'
  ;

d:
  %empty
  | estatuto e
  ;

e:
  %empty
  | d
  ;

estatuto:
  asignacion
  | condicion
  | escritura
  ;

asignacion:
  ID '=' expresion
  ;

expresion:
  exp i
  ;

i:
  %empty
  | '>' exp
  | '<' exp
  | '<>' exp
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
  | m varcte
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
  ID
  | CTEED
  | CTEEF

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
