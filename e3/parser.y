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

%token FOR WHILE IF ELSE INC DEC INT 
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
      stmt_list
      {
          printf("Program parsed successfully.\n");
      }
;

stmt_list:
      stmt_list stmt
    | stmt
;

stmt:
      expr_stmt
    | if_stmt
    | while_stmt
    | for_stmt
    | block
    
;

block:
      '{' stmt_list '}'
      {
          printf("Parsed block.\n");
      }
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
    | /* empty */
;

for_update:
      expr
    | /* empty */
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
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | '(' expr ')'
    | inc_dec_expr
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
    if (argc != 2) {
        printf("Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("File open failed");
        return 1;
    }

    printf("Parsing file: %s\n", argv[1]);
    printf("----------------------\n");

    yyparse();

    fclose(yyin);
    return 0;
}
