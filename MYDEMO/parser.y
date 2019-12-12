%{
#define YYSTYPE Node*
#include <iostream>
#include <string>
#include "tree.h"
#include "lex.c"

using namespace std;

Node* root;
void yyerror(const string msg) {
	// cout << "Error at line: " << line << ", column: " << col << endl;
	cerr << msg << endl;
}
%}

%token INTEGER EOL

// operator
%left ADD SUB MUL DIV // + - * /

%type input line exp

%%
input:    %empty 
        | input line
;

line:     EOL
        | exp EOL      { cout << $1->value << endl; }
;

exp:      INTEGER         { $$ = create_node("num", false, "", $1->value);  }
        | exp exp ADD   { $$ = create_node("num", false, "", $1->value+$2->value);        }
        | exp exp SUB  { $$ = create_node("num", false, "", $1->value-$2->value);      }
        | exp exp MUL  { $$ = create_node("num", false, "", $1->value*$2->value);     }
        | exp exp DIV   { $$ = create_node("num", false, "", $1->value/$2->value);    }
;
%%
