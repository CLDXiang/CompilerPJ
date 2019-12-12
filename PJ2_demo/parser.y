%{
#define YYSTYPE Node*
#include <iostream>
#include <string>
#include "tree.h"
#include "lex.c"

using namespace std;

Node* root;
void yyerror(const string msg) {
	cout << "Error at line: " << line << ", column: " << col << endl;
	cerr << msg << endl;
}
%}

%token INTEGER REAL STRING ID

// operator
%right ASSIGN // :=
%left LT GT EQ ADD SUB MUL DIV // < > = + - * /
%left LE GE NEQ // <= >= <>

// delimiter
%token COLON SEMICOLON COMMA DOT LPAREN RPAREN LSBRACK RSBRACK LBRACE RBRACE BACKSLASH /* : ; , . ( ) [ ] { } \ */
%token LARRAY RARRAY // [< >]

// reserverd keywords
%token AND ARRAY BEGIN BY DIV DO ELSE ELSIF END EXIT FOR IF IN IS
%token LOOP MOD NOT OF OR OUT PROCEDURE PROGRAM READ RECORD RETURN THEN TO TYPE
%token VAR WHILE WRITE

%type program, body
%type declaration
%type statement
%type var-decl type-decl procedure-decl
%type type, component
%type expression
%type formal-params

%type declaration-list statement-list
%type var-decl-list type-decl-list procedure-decl-list
%type component-list
%type comma-id-list

%%
program: 
  %empty { $$ = nullptr; }
  | PROGRAM IS body SEMICOLON { $$ = create_node("program"); $$->add_childs({$1, $2, $3, $4}); }
  ;
body:
  declaration-list BEGIN statement-list END { $$ = create_node("body"); $$->add_childs({$1, $2, $3, $4}); }
  ;
declaration:
  VAR var-decl-list { $$ = create_node("declaration"); $$->add_childs({$1, $2}); }
  | TYPE type-decl-list { $$ = create_node("declaration"); $$->add_childs({$1, $2}); }
  | PROCEDURE procedure-decl-list { $$ = create_node("declaration"); $$->add_childs({$1, $2}); }
  ;
var-decl:
  ID comma-id-list COLON type ASSIGN expression SEMICOLON { $$ = create_node("var-decl"); $$->add_childs({$1, $2, $3, $4, $5, $6, $7}); }
  | ID comma-id-list ASSIGN expression SEMICOLON { $$ = create_node("var-decl"); $$->add_childs({$1, $2, $3, $4, $5}); }
  ;
type-decl:
  ID IS type SEMICOLON { $$ = create_node("type-decl"); $$->add_childs({$1, $2, $3, $4}); }
  ;
procedure-decl:
  ID formal-params COLON type IS body SEMICOLON { $$ = create_node("procedure-decl"); $$->add_childs({$1, $2, $3, $4, $5, $6, $7}); }
  | ID formal-params IS body SEMICOLON { $$ = create_node("procedure-decl"); $$->add_childs({$1, $2, $3, $4, $5}); }
  ;
type:
  ID { $$ = create_node("type"); $$->add_childs({$1}); }
  | ARRAY OF type { $$ = create_node("type"); $$->add_childs({$1, $2, $3}); }
  | RECORD component component-list END { $$ = create_node("type"); $$->add_childs({$1, $2, $3, $4}); }
  ;
component:
  ID COLON type SEMICOLON { $$ = create_node("component"); $$->add_childs({$1, $2, $3, $4}); }
  ;

declaration-list:
  %empty { $$ = nullptr; }
  | declaration declaration-list { $$ = create_node("declaration-list", true); $$->add_childs({$1, $2}); }
  ;
statement-list:
  %empty { $$ = nullptr; }
  | statement statement-list { $$ = create_node("statement-list", true); $$->add_childs({$1, $2}); }
  ;
var-decl-list:
  %empty { $$ = nullptr; }
  | var-decl var-decl-list { $$ = create_node("var-decl-list", true); $$->add_childs({$1, $2}); }
  ;
type-decl-list:
  %empty { $$ = nullptr; }
  | type-decl type-decl-list { $$ = create_node("type-decl-list", true); $$->add_childs({$1, $2}); }
  ;
procedure-decl-list:
  %empty { $$ = nullptr; }
  | procedure-decl procedure-decl-list { $$ = create_node("procedure-decl-list", true); $$->add_childs({$1, $2}); }
  ;
component-list:
  %empty { $$ = nullptr; }
  | component component-list { $$ = create_node("component-list", true); $$->add_childs({$1, $2}); }
  ;
%%
