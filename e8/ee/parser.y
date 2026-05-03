%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int yylex();
void yyerror(const char *s);
%}

%union {
    int num;
}

%token <num> digit
%type <num> S E T F G

%start S

%%

S : E                { printf("Answer = %d\n", $1); }
  ;

E : E '+' T          { $$ = $1 + $3; }
  | E '-' T          { $$ = $1 - $3; }
  | T                { $$ = $1; }
  ;

T : T '*' F          { $$ = $1 * $3; }
  | F                { $$ = $1; }
  ;

F : G '^' F          { $$ = (int)pow($1, $3); }
  | G                { $$ = $1; }
  ;

G : '(' E ')'        { $$ = $2; }
  | digit            { $$ = $1; }
  ;

%%

void yyerror(const char *s)
{
    printf("Invalid Expression\n");
}

int main()
{
    printf("Enter expression:\n");
    yyparse();
    return 0;
}