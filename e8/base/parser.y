%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int case_count = 0;

extern int yylex();
extern FILE *yyin;
void yyerror(const char *s);
%}

%union {
    int num;
    char *id;
    char *str;
}

%token IF ELSE PRINTF
%token OP CP SC COM EQ PLUS

%left PLUS 

%token <id> ID
%token <num> NUM
%token <str> STRING
%type <str> expr

%start program

%%

program
    : if_block elif_blocks else_block
      {
        printf("\nVALID PROGRAM\n");
      }
    ;

if_block
    : IF OP ID EQ NUM CP
      {
        case_count = 0;
        printf("switch(%s)\n{\n", $3);
        printf("case %d:\n", case_count);
      }
      stmt
    ;

elif_blocks
    : elif_blocks elif_block
    | /* empty */
    ;

elif_block
    : ELSE IF OP ID EQ NUM CP
      {
        case_count++;
        printf("case %d:\n", case_count);
      }
      stmt
    ;

else_block
    : ELSE
      {
        printf("default:\n");
      }
      stmt
      {
        printf("}\n");
      }
    | /* optional else */
      {
        printf("}\n");
      }
    ;

stmt
    : PRINTF OP STRING COM expr CP SC
      {
        printf("    printf(%s, %s);\n", $3, $5);
        printf("    break;\n");
      }
    | PRINTF OP STRING CP SC
      {
        printf("    printf(%s);\n", $3);
        printf("    break;\n");
      }
    ;

expr
    : ID                { $$ = $1; }
    | NUM               { 
                          char buffer[20];
                          sprintf(buffer, "%d", $1);
                          $$ = strdup(buffer);
                        }
    | expr PLUS expr    {
                          char *temp = malloc(strlen($1)+strlen($3)+2);
                          sprintf(temp, "%s+%s", $1, $3);
                          $$ = temp;
                        }
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error\n");
}

int main(int argc, char *argv[])
{

    yyin = fopen(argv[1], "r");

    yyparse();

    fclose(yyin);
}