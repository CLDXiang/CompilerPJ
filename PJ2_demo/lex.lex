%{
#include "parser.h"
#include "tree.h"
#include <string>
#include <iostream>
std::string text = "";
int line = 1, col = 1;
#define TRACK_LOCATION_LA yylloc.first_line = yylloc.last_line = line; yylloc.first_column = col; col += strlen(yytext); yylloc.last_column = col; set_location(yylval, yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column);

void print_la_error(string msg);
void check_integer(char* s);
void check_string(string text);
void check_id(char* s);
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
":="                    yylval = create_node("ASSIGN", false, yytext); TRACK_LOCATION_LA; return ASSIGN;
"<"                     yylval = create_node("LT", false, yytext); TRACK_LOCATION_LA; return LT;
">"                     yylval = create_node("GT", false, yytext); TRACK_LOCATION_LA; return GT;
"="                     yylval = create_node("EQ", false, yytext); TRACK_LOCATION_LA; return EQ;
"+"                     yylval = create_node("ADD", false, yytext); TRACK_LOCATION_LA; return ADD;
"-"                     yylval = create_node("SUB", false, yytext); TRACK_LOCATION_LA; return SUB;
"*"                     yylval = create_node("MUL", false, yytext); TRACK_LOCATION_LA; return MUL;
"/"                     yylval = create_node("DIVIDE", false, yytext); TRACK_LOCATION_LA; return DIVIDE;
"<="                    yylval = create_node("LE", false, yytext); TRACK_LOCATION_LA; return LE;
">="                    yylval = create_node("GE", false, yytext); TRACK_LOCATION_LA; return GE;
"<>"                    yylval = create_node("NEQ", false, yytext); TRACK_LOCATION_LA; return NEQ;

":"                     yylval = create_node("COLON", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return COLON;
";"                     yylval = create_node("SEMICOLON", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return SEMICOLON;
","                     yylval = create_node("COMMA", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return COMMA;
"."                     yylval = create_node("DOT", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return DOT;
"("                     yylval = create_node("LPAREN", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return LPAREN;
")"                     yylval = create_node("RPAREN", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return RPAREN;
"["                     yylval = create_node("LSBRACK", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return LSBRACK;
"]"                     yylval = create_node("RSBRACK", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return RSBRACK;
"{"                     yylval = create_node("LBRACE", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return LBRACE;
"}"                     yylval = create_node("RBRACE", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return RBRACE;
{BACKSLASH}             yylval = create_node("BACKSLASH", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return BACKSLASH;

"[<"                    yylval = create_node("LARRAY", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return LARRAY;
">]"                    yylval = create_node("RARRAY", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return RARRAY;

AND                     yylval = create_node("AND", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return AND;
ARRAY                   yylval = create_node("ARRAY", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return ARRAY;
BEGIN                   yylval = create_node("BEGIN", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return RK_BEGIN;
BY                      yylval = create_node("BY", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return BY;
DIV                     yylval = create_node("DIV", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return DIV;
DO                      yylval = create_node("DO", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return DO;
ELSE                    yylval = create_node("ELSE", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return ELSE;
ELSIF                   yylval = create_node("ELSIF", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return ELSIF;
END                     yylval = create_node("END", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return END;
EXIT                    yylval = create_node("EXIT", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return EXIT;
FOR                     yylval = create_node("FOR", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return FOR;
IF                      yylval = create_node("IF", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return IF;
IN                      yylval = create_node("IN", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return IN;
IS                      yylval = create_node("IS", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return IS;
LOOP                    yylval = create_node("LOOP", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return LOOP;
MOD                     yylval = create_node("MOD", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return MOD;
NOT                     yylval = create_node("NOT", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return NOT;
OF                      yylval = create_node("OF", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return OF;
OR                      yylval = create_node("OR", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return OR;
OUT                     yylval = create_node("OUT", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return OUT;
PROCEDURE               yylval = create_node("PROCEDURE", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return PROCEDURE;
PROGRAM                 yylval = create_node("PROGRAM", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return PROGRAM;
READ                    yylval = create_node("READ", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return READ;
RECORD                  yylval = create_node("RECORD", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return RECORD;
RETURN                  yylval = create_node("RETURN", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return RETURN;
THEN                    yylval = create_node("THEN", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return THEN;
TO                      yylval = create_node("TO", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return TO;
TYPE                    yylval = create_node("TYPE", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return TYPE;
VAR                     yylval = create_node("VAR", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return VAR;
WHILE                   yylval = create_node("WHILE", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return WHILE;
WRITE                   yylval = create_node("WRITE", false, yytext); hide_node(yylval); TRACK_LOCATION_LA; return WRITE;

{WS}                    col += strlen(yytext);
\n                      col = 1; line++;
<INITIAL><<EOF>>        return 0;

{INTEGER}	            yylval = create_node("INTEGER", false, yytext, atof(yytext)); check_integer(yytext); TRACK_LOCATION_LA; return INTEGER;

{REAL}                  yylval = create_node("REAL", false, yytext, atof(yytext)); TRACK_LOCATION_LA; return REAL;

<INITIAL>{QUOTE}        BEGIN(SC_string); text = yytext;
<SC_string>[^\"\n]*     text += yytext; /* eat anything that's not a '"' */
<SC_string>{QUOTE}      text += yytext; BEGIN(INITIAL); yylval = create_node("STRING", false, text); check_string(text); yylloc.first_line = yylloc.last_line = line; yylloc.first_column = col; col += text.length(); yylloc.last_column = col; set_location(yylval, yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column); return STRING;
<SC_string>\n           print_la_error("Reach EOL in a string"); return 0;
<SC_string><<EOF>>      print_la_error("Reach EOF in a string"); return 0;

{ID}                    yylval = create_node("ID", false, yytext); check_id(yytext); TRACK_LOCATION_LA; return ID;

<INITIAL>{COMMENT}      BEGIN(SC_comment); text = yytext;
<SC_comment>[^*\n]*     text += yytext; /* eat anything that's not a '*' */
<SC_comment>\*[^*)\n]*  text += yytext; /* eat up '*'s not followed by ')'s */
<SC_comment>\n          col = 1; line++; text = "";
<SC_comment>\*\)        text += yytext; col += text.length(); BEGIN(INITIAL);
<SC_comment><<EOF>>     print_la_error("Reach EOL in a comment"); return 0;

{BC}                    print_la_error("Unrecognized character"); return 0;
%%

void print_la_error(string msg) {
    cout << "[Lexical Analysis Failed] " << msg << " (line: " << line << ", column: " << col << ")" << endl;
}

void check_integer(char* s) {
    if (strlen(s)>10 || (strlen(s)==10 && strncmp(s, "4294967295", 10) > 0))
        print_la_error("An out of range integer");
}

void check_string(string text) {
    if (text.find('\t') != std::string::npos)
        print_la_error("An invalid string with tab in it");
    else if (text.length() > 257)
        print_la_error("An overly long string (more than 255 characters)");
}

void check_id(char* s) {
    if (strlen(s) > 255)
        print_la_error("An overly long identifier (more than 255 characters)");
}