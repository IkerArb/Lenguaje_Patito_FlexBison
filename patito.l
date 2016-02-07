%{
#include <iostream>
#include "patito.tab.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
%}
%%
"PROG"                                              {return PROG;}
"IF"                                                {return IF;}
"THEN"                                              {return THEN;}
"ELSE"                                              {return ELSE;}
"PROC"                                              {return PROC;}
"END"                                               {return END;}
"INT"                                               {return INT;}
"FLOAT"                                             {return FLOAT;}
"WHILE"                                             {return WHILE;}
"READ"                                              {return READ;}
"PRINT"                                             {return PRINT;}
"VAR"																								{return VAR;}
[+]                                                  {return '+';}
[/]                                                  {return '/';}
[*]                                                  {return '*';}
[-]                                                   {return '-';}
[<][>]                                                  {return yytext;}
[<][=]                                                  {return yytext;}
[>][=]                                                  {return yytext;}
[=]                                                   {return '=';}
[<]                                                   {return '<';}
[>]                                                   {return '>';}
[;]                                                   {return ';';}
[(]                                                 {return '(';}
[)]                                                  {return ')';}
[{]                                                   {return '{';}
[}]                                                   {return '}';}
[:]                                                   {return ':';}
[,]																										{return ',';}
\"[^\n"]*\"                                         {yylval.sval = yytext; return CTES;}
\/\*([^*]|\n|[*][^\/])*\*\/                                 {yylval.sval = yytext; return COMMENT;}
[ \n\t]                                             ;
[A-Za-z]([_]?([a-zA-Z]|[0-9]))*                      {yylval.sval = yytext; return ID; }
[0-9]+                                              { yylval.ival = atoi(yytext); return CTEED; }
(0|1)+b                                             { yylval.sval = yytext; return CTEEB;}
[0-9]+[a-fA-F0-9]*[hH]                         {yylval.sval = yytext; return CTEEH;}
[0-9]+([eE]([+]|[-])?|[.][0-9]+[eE]([+]|[-])?|[.])[0-9]+  {yylval.fval = atof(yytext); return CTEF;}
%%
