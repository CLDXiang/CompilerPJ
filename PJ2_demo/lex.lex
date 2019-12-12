%{
#include "parser.h"
#include <string>
std::string text = "";
int line = 1, col = 1;
%}
%option     nounput
%option     noyywrap
%s SC_comment
%s SC_string

DIGIT       [0-9]
LETTER      [a-zA-Z]
INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
WS          [ \t]+
RK          AND|ARRAY|BEGIN|BY|DIV|DO|ELSE|ELSIF|END|EXIT|FOR|IF|IN|IS|LOOP|MOD|NOT|OF|OR|OUT|PROCEDURE|PROGRAM|READ|RECORD|RETURN|THEN|TO|TYPE|VAR|WHILE|WRITE
COMMENT     \(\*
ID          {LETTER}[a-zA-Z0-9]*
OP          :=|<=|>=|<>|\+|-|\*|\/|\<|\>|=
DE          \[\<|\>\]|:|;|,|\.|\(|\)|\[|\]|\{|\}|\\
QUOTE       \"
BC          

%%
<INITIAL>{COMMENT}   BEGIN(comment); text = yytext; extra_n = 0;
<SC_comment>[^*\n]*                     text += yytext; line_leng += yyleng; /* eat anything that's not a '*' */
<SC_comment>\*[^*)\n]*                  text += yytext; line_leng += yyleng; /* eat up '*'s not followed by ')'s */
<SC_comment>\n                          text += yytext; extra_n++; line_leng = 0;
<SC_comment>\*\)                        text += yytext; line_leng += yyleng; BEGIN(INITIAL); return COMMENT;
<SC_comment><<EOF>>                     err_code = 2; BEGIN(INITIAL); return ERR;
{RK}        return RK;
<INITIAL>{QUOTE}    BEGIN(string); text = yytext; extra_n = 0;
<SC_string>[^\"\n]*                   text += yytext; /* eat anything that's not a '"' */
<SC_string>\n                         text += yytext; extra_n++; line_leng = 0; err_code = 1; BEGIN(INITIAL); return ERR;
<SC_string>{QUOTE}                    text += yytext; BEGIN(INITIAL); return STRING;
<SC_string><<EOF>>                    err_code = 1; BEGIN(INITIAL); return ERR;
{WS}        {  }
\n          { line++; col = 1; return EOL; }
<<EOF>>     { return 0; }
{INTEGER}	{ yylval.val = atof(yytext); col += strlen(yytext); return INTEGER; }
{REAL}		{ yylval.val = atof(yytext); col += strlen(yytext); return REAL; }
{ID}        return ID;
"+"         { col += strlen(yytext); return ADD; }
"-"         { col += strlen(yytext); return SUB; }
"*"         { col += strlen(yytext); return MUL; }
"/"         { col += strlen(yytext); return DIV; }
"("         { col += strlen(yytext); return LPAREN; }
")"         { col += strlen(yytext); return RPAREN; }
{DE}        return DE;
{BC}        err_code = 0; return ERR;
%%
