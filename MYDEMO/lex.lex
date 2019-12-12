%{
#include "parser.h"
#include "tree.h"
#include <string>
%}
%option     nounput
%option     noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z]
INTEGER     {DIGIT}+
WS          [ \t]+
EOL         \n
ADD         \+
SUB         -
MUL         \*
DIV         \/

%%
{WS}        {  }
{EOL}          { return EOL; }
<<EOF>>     { return 0; }
{INTEGER}	{ yylval = create_node("interger", false, yytext, atof(yytext)); return INTEGER; }
{ADD}         { return ADD; }
{SUB}         { return SUB; }
{MUL}         { return MUL; }
{DIV}         { return DIV; }
%%
