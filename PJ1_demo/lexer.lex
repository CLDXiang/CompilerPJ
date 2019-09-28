%{
#include "lexer.h"
#include <string>
std::string text = "";
int line_leng = 0;
int extra_n = 0;
int err_code = -1; // 0: a bad character (bell); 1: an unterminated string; 2: an unterminated comment;
%}
%option     nounput
%option     noyywrap
%s comment
%s string

DIGIT       [0-9]
LETTER      [a-zA-Z]
INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
WS          [ \t]+
NEWLINE     \n
RK          AND|ARRAY|BEGIN|BY|DIV|DO|ELSE|ELSIF|END|EXIT|FOR|IF|IN|IS|LOOP|MOD|NOT|OF|OR|OUT|PROCEDURE|PROGRAM|READ|RECORD|RETURN|THEN|TO|TYPE|VAR|WHILE|WRITE
COMMENT     \(\*
ID          {LETTER}[a-zA-Z0-9]*
OP          :=|<=|>=|<>|\+|-|\*|\/|\<|\>|=
DE          \[\<|\>\]|:|;|,|\.|\(|\)|\[|\]|\{|\}|\\
QUOTE       \"
BC          

%%
<INITIAL>{COMMENT}   BEGIN(comment); text = yytext; extra_n = 0;
<comment>[^*\n]*                     text += yytext; line_leng += yyleng; /* eat anything that's not a '*' */
<comment>\*[^*)\n]*                  text += yytext; line_leng += yyleng; /* eat up '*'s not followed by ')'s */
<comment>\n                          text += yytext; extra_n++; line_leng = 0;
<comment>\*\)                        text += yytext; line_leng += yyleng; BEGIN(INITIAL); return COMMENT;
<comment><<EOF>>                     err_code = 2; BEGIN(INITIAL); return ERR;
{RK}        return RK;
<INITIAL>{QUOTE}    BEGIN(string); text = yytext; extra_n = 0;
<string>[^\"\n]*                   text += yytext; line_leng += yyleng; /* eat anything that's not a '"' */
<string>\n                         text += yytext; extra_n++; line_leng = 0;
<string>{QUOTE}                    text += yytext; line_leng += yyleng; BEGIN(INITIAL); return STRING;
<string><<EOF>>                    err_code = 1; BEGIN(INITIAL); return ERR;
{WS}        return WS; // skip blanks and tabs
{NEWLINE}   return NEWLINE;
<<EOF>>     return T_EOF;
{INTEGER}	return INTEGER;
{REAL}		return REAL;
{ID}        return ID;
{OP}        return OP;
{DE}        return DE;
{BC}        err_code = 0; return ERR;
%%
