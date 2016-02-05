%{
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()
%}
%%
"PROG"                                              {cout << "Found PROG: "<<yytext<<endl;}
"IF"                                                {cout << "Found IF: " << yytext <<endl;}
"THEN"                                              {cout << "Found THEN: "<< yytext <<endl;}
"ELSE"                                              {cout << "Found ELSE: "<< yytext << endl;}
"PROC"                                              {cout << "Found PROC: "<< yytext << endl;}
"END"                                               {cout << "Found END: "<< yytext << endl;}
"INT"                                               {cout << "Found INT: "<< yytext << endl;}
"FLOAT"                                             {cout << "Found FLOAT: "<< yytext << endl;}
"WHILE"                                             {cout << "Found WHILE: "<< yytext << endl;}
"READ"                                              {cout << "Found READ: "<< yytext << endl;}
"WRITE"                                             {cout << "Found WRITE: "<< yytext << endl;}
[+]                                                  {cout << "Found + : "<< yytext << endl;}
[/]                                                  {cout << "Found / : "<< yytext << endl;}
[*]                                                  {cout << "Found * : "<< yytext << endl;}
[-]                                                   {cout << "Found - : "<< yytext << endl;}
[<][>]                                                  {cout << "Found <> : "<< yytext << endl;}
[<][=]                                                  {cout << "Found <= : "<< yytext << endl;}
[>][=]                                                  {cout << "Found >= : "<< yytext << endl;}
[=]                                                   {cout << "Found = : "<< yytext << endl;}
[<]                                                   {cout << "Found < : "<< yytext << endl;}
[>]                                                   {cout << "Found > : "<< yytext << endl;}
[;]                                                   {cout << "Found ; : "<< yytext << endl;}
[(]                                                 {cout << "Found ( : "<< yytext << endl;}
[)]                                                  {cout << "Found ) : "<< yytext << endl;}
[{]                                                   {cout << "Found { : "<< yytext << endl;}
[}]                                                   {cout << "Found } : "<< yytext << endl;}
[:]                                                   {cout << "Found : : "<< yytext << endl;}
['][^\n]*[']                                          {cout << "Found a string: " << yytext << endl;}
[/][*](.|\n)*[*][/]                                   {cout << "Found a comment: "<< yytext <<endl;}
[ \n\t]                                             ;
[A-Za-z]([_]?([a-zA-Z]|[0-9]))*                      {cout << "Found an id: "<< yytext << endl; }
[0-9]+                                              { cout << "Found a decimal integer: " << yytext << endl; }
(0|1)+b                                             { cout << "Found a binary number: "<< yytext << endl;}
[0-9]+[a-fA-F0-9]*[hH]                         {cout << "Found a hexadecimal number: "<< yytext <<endl;}
[0-9]+([eE]([+]|[-])?|[.][0-9]+[eE]([+]|[-])?|[.])[0-9]+  {cout << "Found a floating point constant: "<<yytext<<endl;}
%%
int main(int, char**) {
	// lex through the input:
	yylex();
}
