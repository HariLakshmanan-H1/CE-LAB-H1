%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern FILE *yyin;
void yyerror(const char *s);
%}

%union {
    int num;
    char *id;
}

%token INT RETURN
%token WHILE FOR IF ELSE INC DEC
%token <id> ID
%token <num> NUM
%token LE GE EQ NE

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%left '<' '>' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%right '='
%right INC DEC

%%

program:
      external_list
      {
          printf("Program parsed successfully.\n");
      }
      |stmt_list
;



external_list:
      external_list external
    | external
;

external:
      declaration
    | function_def
;

declaration:
      INT ID ';'
      {
          printf("Global declaration: int %s\n", $2);
          free($2);
      }
;

function_def:
      INT ID '(' param_list ')' compound_stmt
      {
          printf("Function definition: %s\n", $2);
          free($2);
      }
;

param_list:
      param
    | /* empty */
;

param:
      INT ID '[' ']'
      {
          printf("Array parameter: int %s[]\n", $2);
          free($2);
      }
;

compound_stmt:
      '{' local_decls stmt_list '}'
      {
          printf("Parsed function body.\n");
      }
;

local_decls:
      local_decls local_decl
    | /* empty */
;

local_decl:
      INT ID ';'
      {
          printf("Local Usage: int %s\n", $2);
          free($2);
      }
      | INT ID '=' expr ';'
      {
          printf("Local declaration: int %s\n", $2);
          free($2);
      }
;

stmt_list:
      stmt_list stmt
    | stmt
;

stmt:
      expr_stmt
    | while_stmt
    | for_stmt
    | if_stmt
    | block
    | return_stmt
;

return_stmt:
      RETURN expr ';'
      {
          printf("Return statement.\n");
      }
;

block:
      '{' stmt_list '}'
      {
          printf("Parsed block.\n");
      }
;

while_stmt:
      WHILE '(' condition ')' stmt
      {
          printf("Parsed while loop.\n");
      }
;

for_stmt:
      FOR '(' for_init ';' condition ';' for_update ')' stmt
      {
          printf("Parsed for loop.\n");
      }
;

for_init:
      expr
    | INT ID '=' expr 
      {
          printf("Local declaration: int %s\n", $2);
          free($2);
      }
    | /* empty */
;

for_update:
      expr
    | /* empty */
;

if_stmt:
      IF '(' condition ')' stmt %prec LOWER_THAN_ELSE
      {
          printf("Parsed if statement.\n");
      }
    | IF '(' condition ')' stmt ELSE stmt
      {
          printf("Parsed if-else statement.\n");
      }
;

expr_stmt:
      expr ';'
      {
          printf("Parsed expression statement.\n");
      }
;

condition:
      expr '<' expr
    | expr '>' expr
    | expr LE expr
    | expr GE expr
    | expr EQ expr
    | expr NE expr
;

expr:
      ID '=' expr
      {
          printf("Assignment to %s\n", $1);
          free($1);
      }
    | ID '[' NUM ']'
      {
          printf("Array access: %s[%d]\n", $1, $3);
          free($1);
      }
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | inc_dec_expr
    | '(' expr ')'
    | ID
      {
          printf("Variable reference: %s\n", $1);
          free($1);
      }
    | NUM
      {
          printf("Number constant: %d\n", $1);
      }
;

inc_dec_expr:
      ID INC
      {
          printf("Increment: %s++\n", $1);
          free($1);
      }
    | ID DEC
      {
          printf("Decrement: %s--\n", $1);
          free($1);
      }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");

    yyparse();

    fclose(yyin);
}
