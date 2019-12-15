%{
#define YYSTYPE Node*
#include <iostream>
#include <string>
#include "tree.h"
#include "lex.c"

using namespace std;

Node* root;
void yyerror(const string msg) {
	cout << "Error at line: " << yylloc.first_line << ", column: " << yylloc.first_column << endl;
	cerr << msg << endl;
}
%}

%locations

%token INTEGER REAL STRING ID

// operator
%right ASSIGN // :=
%left LT GT EQ ADD SUB MUL DIVIDE // < > = + - * /
%left LE GE NEQ // <= >= <>

// delimiter
%token COLON SEMICOLON COMMA DOT LPAREN RPAREN LSBRACK RSBRACK LBRACE RBRACE BACKSLASH /* : ; , . ( ) [ ] { } \ */
%token LARRAY RARRAY // [< >]

// reserverd keywords
%token AND ARRAY RK_BEGIN BY DIV DO ELSE ELSIF END EXIT FOR IF IN IS
%token LOOP MOD NOT OF OR OUT PROCEDURE PROGRAM READ RECORD RETURN THEN TO TYPE
%token VAR WHILE WRITE

%type program body
%type declaration
%type statement
%type var-decl type-decl procedure-decl
%type type component
%type expression
%type formal-params fp-section
%type l-value actual-params write-params write-expr
%type number unary-op binary-op comp-values array-values array-value

%type declaration-list statement-list
%type var-decl-list type-decl-list procedure-decl-list
%type component-list
%type comma-id-list
%type comma-l-value-list
%type elseif-list
%type comma-write-expr-list comma-expression-list
%type semicolon-id-assign-expression-list

%%
program: 
  %empty { $$ = nullptr; }
  | PROGRAM IS body SEMICOLON { $$ = create_node("program"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); root = $$; }
  ;
body:
  declaration-list RK_BEGIN statement-list END { $$ = create_node("body"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  ;
declaration:
  VAR var-decl-list { $$ = create_node("declaration"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  | TYPE type-decl-list { $$ = create_node("declaration"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  | PROCEDURE procedure-decl-list { $$ = create_node("declaration"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  ;
var-decl:
  ID comma-id-list COLON type ASSIGN expression SEMICOLON { $$ = create_node("var-decl"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6, $7}); }
  | ID comma-id-list ASSIGN expression SEMICOLON { $$ = create_node("var-decl"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5}); }
  ;
type-decl:
  ID IS type SEMICOLON { $$ = create_node("type-decl"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  ;
procedure-decl:
  ID formal-params COLON type IS body SEMICOLON { $$ = create_node("procedure-decl"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6, $7}); }
  | ID formal-params IS body SEMICOLON { $$ = create_node("procedure-decl"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5}); }
  ;
type:
  ID { $$ = create_node("type"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | ARRAY OF type { $$ = create_node("type"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3}); }
  | RECORD component component-list END { $$ = create_node("type"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  ;
component:
  ID COLON type SEMICOLON { $$ = create_node("component"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  ;
formal-params:
  LPAREN fp-section semicolon-fp-section-list RPAREN { $$ = create_node("formal-params"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  | LPAREN RPAREN { $$ = create_node("formal-params"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  ;
fp-section:
  ID comma-id-list COLON type { $$ = create_node("fp-section"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  ;
statement:
  l-value ASSIGN expression SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  | ID actual-params SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3}); }
  | READ LPAREN l-value comma-l-value-list RPAREN SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6}); }
  | WRITE write-params SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3}); }
  | IF expression THEN statement-list elseif-list END SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6, $7}); }
  | IF expression THEN statement-list elseif-list ELSE statement-list END SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6, $7, $8, $9}); }
  | WHILE expression DO statement-list END SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6}); }
  | LOOP statement-list END SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  | FOR ID ASSIGN expression TO expression DO statement-list END SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6, $7, $8, $9, $10}); }
  | FOR ID ASSIGN expression TO expression BY expression DO statement-list END SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}); }
  | EXIT SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  | RETURN SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  | RETURN expression SEMICOLON { $$ = create_node("statement"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3}); }
  ;
write-params:
  LPAREN write-expr comma-write-expr-list RPAREN { $$ = create_node("write-params"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  | LPAREN RPAREN { $$ = create_node("write-params"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); } // TODO: 可能后面要考虑规约顺序
  ;
write-expr:
  STRING { $$ = create_node("write-expr"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | expression { $$ = create_node("write-expr"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  ;
expression:
  number { $$ = create_node("expression"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | l-value { $$ = create_node("expression"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | LPAREN expression RPAREN { $$ = create_node("expression"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3}); }
  | unary-op expression { $$ = create_node("expression"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  | expression binary-op expression { $$ = create_node("expression"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3}); }
  | ID actual-params { $$ = create_node("expression"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  | ID comp-values { $$ = create_node("expression"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  | ID array-values { $$ = create_node("expression"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  ;
l-value:
  ID { $$ = create_node("l-value"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | l-value LSBRACK expression RSBRACK { $$ = create_node("l-value"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  | l-value DOT ID { $$ = create_node("l-value"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3}); }
  ;
actual-params:
  LPAREN expression comma-expression-list RPAREN { $$ = create_node("actual-params"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  | LPAREN RPAREN { $$ = create_node("actual-params"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2}); }
  ;
comp-values:
  LBRACE ID ASSIGN expression semicolon-id-assign-expression-list RBRACE { $$ = create_node("comp-values"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4, $5, $6}); }
  ;
array-values:
  LARRAY array-value comma-array-value-list RARRAY { $$ = create_node("array-values"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3, $4}); }
  ;
array-value:
  expression { $$ = create_node("array-value"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | expression OF expression { $$ = create_node("array-value"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1, $2, $3}); }
  ;
number:
  INTEGER { $$ = create_node("number"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | REAL { $$ = create_node("number"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  ;
unary-op:
  ADD { $$ = create_node("unary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | SUB { $$ = create_node("unary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | NOT { $$ = create_node("unary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  ;
binary-op:
  ADD { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | SUB { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | MUL { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | DIVIDE { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | DIV { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | MOD { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | OR { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | AND { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | GT { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | LT { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | EQ { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | GE { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | LE { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  | NEQ { $$ = create_node("binary-op"); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); $$->add_childs({$1}); }
  ;

declaration-list:
  %empty { $$ = nullptr; }
  | declaration declaration-list { $$ = create_node("declaration-list", true); $$->add_childs({$1, $2}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
statement-list:
  %empty { $$ = nullptr; }
  | statement statement-list { $$ = create_node("statement-list", true); $$->add_childs({$1, $2}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
var-decl-list:
  %empty { $$ = nullptr; }
  | var-decl var-decl-list { $$ = create_node("var-decl-list", true); $$->add_childs({$1, $2}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
type-decl-list:
  %empty { $$ = nullptr; }
  | type-decl type-decl-list { $$ = create_node("type-decl-list", true); $$->add_childs({$1, $2}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
procedure-decl-list:
  %empty { $$ = nullptr; }
  | procedure-decl procedure-decl-list { $$ = create_node("procedure-decl-list", true); $$->add_childs({$1, $2}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
component-list:
  %empty { $$ = nullptr; }
  | component component-list { $$ = create_node("component-list", true); $$->add_childs({$1, $2}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
comma-id-list:
  %empty { $$ = nullptr; }
  | COMMA ID comma-id-list { $$ = create_node("comma-id-list", true); $$->add_childs({$1, $2, $3}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
semicolon-fp-section-list:
  %empty { $$ = nullptr; }
  | SEMICOLON fp-section semicolon-fp-section-list { $$ = create_node("semicolon-fp-section-list", true); $$->add_childs({$1, $2, $3}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
comma-l-value-list:
  %empty { $$ = nullptr; }
  | COMMA l-value comma-l-value-list { $$ = create_node("comma-l-value-list", true); $$->add_childs({$1, $2, $3}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
elseif-list:
  %empty { $$ = nullptr; }
  | ELSIF expression THEN statement-list elseif-list { $$ = create_node("elseif-list", true); $$->add_childs({$1, $2, $3, $4, $5}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
comma-write-expr-list:
  %empty { $$ = nullptr; }
  | COMMA write-expr comma-write-expr-list { $$ = create_node("comma-write-expr-list", true); $$->add_childs({$1, $2, $3}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
comma-expression-list:
  %empty { $$ = nullptr; }
  | COMMA expression comma-expression-list { $$ = create_node("comma-expression-list", true); $$->add_childs({$1, $2, $3}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
semicolon-id-assign-expression-list:
  %empty { $$ = nullptr; }
  | SEMICOLON ID ASSIGN expression semicolon-id-assign-expression-list { $$ = create_node("semicolon-id-assign-expression-list", true); $$->add_childs({$1, $2, $3, $4, $5}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
comma-array-value-list:
  %empty { $$ = nullptr; }
  | COMMA array-value comma-array-value-list { $$ = create_node("comma-array-value-list", true); $$->add_childs({$1, $2, $3}); set_location($$, @$.first_line, @$.first_column, @$.last_line, @$.last_column); }
  ;
%%
