%{
#include "parser.h"
#include "tree.h"
#include <string>
#include <iostream>
std::string text = "";
int line = 1, col = 1;

%}
%option     nounput
%option     noyywrap
%x SC_comment
%x SC_string

DIGIT       [0-9]
LETTER      [a-zA-Z]

INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
QUOTE       \"
ID          {LETTER}[a-zA-Z0-9]*

BACKSLASH   \\

WS          [ \t]+
COMMENT     \(\*
BC          

%%
":="                    yylval = create_node("ASSIGN", false, yytext); return ASSIGN;
"<"                     yylval = create_node("LT", false, yytext); return LT;
">"                     yylval = create_node("GT", false, yytext); return GT;
"="                     yylval = create_node("EQ", false, yytext); return EQ;
"+"                     yylval = create_node("ADD", false, yytext); return ADD;
"-"                     yylval = create_node("SUB", false, yytext); return SUB;
"*"                     yylval = create_node("MUL", false, yytext); return MUL;
"/"                     yylval = create_node("DIVIDE", false, yytext); return DIVIDE;
"<="                    yylval = create_node("LE", false, yytext); return LE;
">="                    yylval = create_node("GE", false, yytext); return GE;
"<>"                    yylval = create_node("NEQ", false, yytext); return NEQ;

":"                     yylval = create_node("COLON", false, yytext); hide_node(yylval); return COLON;
";"                     yylval = create_node("SEMICOLON", false, yytext); hide_node(yylval); return SEMICOLON;
","                     yylval = create_node("COMMA", false, yytext); hide_node(yylval); return COMMA;
"."                     yylval = create_node("DOT", false, yytext); hide_node(yylval); return DOT;
"("                     yylval = create_node("LPAREN", false, yytext); hide_node(yylval); return LPAREN;
")"                     yylval = create_node("RPAREN", false, yytext); hide_node(yylval); return RPAREN;
"["                     yylval = create_node("LSBRACK", false, yytext); hide_node(yylval); return LSBRACK;
"]"                     yylval = create_node("RSBRACK", false, yytext); hide_node(yylval); return RSBRACK;
"{"                     yylval = create_node("LBRACE", false, yytext); hide_node(yylval); return LBRACE;
"}"                     yylval = create_node("RBRACE", false, yytext); hide_node(yylval); return RBRACE;
{BACKSLASH}             yylval = create_node("BACKSLASH", false, yytext); hide_node(yylval); return BACKSLASH;

"[<"                    yylval = create_node("LARRAY", false, yytext); hide_node(yylval); return LARRAY;
">]"                    yylval = create_node("RARRAY", false, yytext); hide_node(yylval); return RARRAY;

AND                     yylval = create_node("AND", false, yytext); hide_node(yylval); return AND;
ARRAY                   yylval = create_node("ARRAY", false, yytext); hide_node(yylval); return ARRAY;
BEGIN                   yylval = create_node("BEGIN", false, yytext); hide_node(yylval); return RK_BEGIN;
BY                      yylval = create_node("BY", false, yytext); hide_node(yylval); return BY;
DIV                     yylval = create_node("DIV", false, yytext); hide_node(yylval); return DIV;
DO                      yylval = create_node("DO", false, yytext); hide_node(yylval); return DO;
ELSE                    yylval = create_node("ELSE", false, yytext); hide_node(yylval); return ELSE;
ELSIF                   yylval = create_node("ELSIF", false, yytext); hide_node(yylval); return ELSIF;
END                     yylval = create_node("END", false, yytext); hide_node(yylval); return END;
EXIT                    yylval = create_node("EXIT", false, yytext); hide_node(yylval); return EXIT;
FOR                     yylval = create_node("FOR", false, yytext); hide_node(yylval); return FOR;
IF                      yylval = create_node("IF", false, yytext); hide_node(yylval); return IF;
IN                      yylval = create_node("IN", false, yytext); hide_node(yylval); return IN;
IS                      yylval = create_node("IS", false, yytext); hide_node(yylval); return IS;
LOOP                    yylval = create_node("LOOP", false, yytext); hide_node(yylval); return LOOP;
MOD                     yylval = create_node("MOD", false, yytext); hide_node(yylval); return MOD;
NOT                     yylval = create_node("NOT", false, yytext); hide_node(yylval); return NOT;
OF                      yylval = create_node("OF", false, yytext); hide_node(yylval); return OF;
OR                      yylval = create_node("OR", false, yytext); hide_node(yylval); return OR;
OUT                     yylval = create_node("OUT", false, yytext); hide_node(yylval); return OUT;
PROCEDURE               yylval = create_node("PROCEDURE", false, yytext); hide_node(yylval); return PROCEDURE;
PROGRAM                 yylval = create_node("PROGRAM", false, yytext); hide_node(yylval); return PROGRAM;
READ                    yylval = create_node("READ", false, yytext); hide_node(yylval); return READ;
RECORD                  yylval = create_node("RECORD", false, yytext); hide_node(yylval); return RECORD;
RETURN                  yylval = create_node("RETURN", false, yytext); hide_node(yylval); return RETURN;
THEN                    yylval = create_node("THEN", false, yytext); hide_node(yylval); return THEN;
TO                      yylval = create_node("TO", false, yytext); hide_node(yylval); return TO;
TYPE                    yylval = create_node("TYPE", false, yytext); hide_node(yylval); return TYPE;
VAR                     yylval = create_node("VAR", false, yytext); hide_node(yylval); return VAR;
WHILE                   yylval = create_node("WHILE", false, yytext); hide_node(yylval); return WHILE;
WRITE                   yylval = create_node("WRITE", false, yytext); hide_node(yylval); return WRITE;

{WS}                    
\n                      
<INITIAL><<EOF>>        return 0;

{INTEGER}	            yylval = create_node("INTEGER", false, yytext, atof(yytext)); return INTEGER;

{REAL}                  yylval = create_node("REAL", false, yytext, atof(yytext)); return REAL;

<INITIAL>{QUOTE}        BEGIN(SC_string); text = yytext;
<SC_string>[^\"\n]*     text += yytext; /* eat anything that's not a '"' */
<SC_string>{QUOTE}      text += yytext; BEGIN(INITIAL); yylval = create_node("STRING", false, text); return STRING;
<SC_string>\n           cout << "[Lexical Analysis Failed] reach EOL in a string" << endl; return 0;
<SC_string><<EOF>>      cout << "[Lexical Analysis Failed] reach EOF in a string" << endl; return 0;

{ID}                    yylval = create_node("ID", false, yytext); return ID;

<INITIAL>{COMMENT}      BEGIN(SC_comment);
<SC_comment>[^*\n]*     /* eat anything that's not a '*' */
<SC_comment>\*[^*)\n]*  /* eat up '*'s not followed by ')'s */
<SC_comment>\n          
<SC_comment>\*\)        BEGIN(INITIAL);
<SC_comment><<EOF>>     cout << "[Lexical Analysis Failed] reach EOL in a comment" << endl; return 0;

{BC}                    cout << "[Lexical Analysis Failed] unrecognized character" << endl; return 0;
%%
