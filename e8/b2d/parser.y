%{
#include <stdio.h>
#include <stdlib.h>

double frac = 0.0;   // fractional part
double base = 0.5;   // keeps track of 1/2, 1/4, 1/8...

extern int yylex();
void yyerror(const char* s);
%}

%union {
    int num;
}

%token <num> ZERO ONE
%token POINT

%type <num> X B
%type <num> Y

%start L

%%

L:
    X POINT Y   { printf("Decimal: %f\n", $1 + frac); frac = 0; base = 0.5; }
  | X           { printf("Decimal: %d\n", $1); }
  ;

X:
    X B   { $$ = $1 * 2 + $2; }
  | B     { $$ = $1; }
  ;

Y:
    B Y   { frac += $1 * base; base /= 2; }
  |       { /* empty */ }
  ;

B:
    ZERO  { $$ = 0; }
  | ONE   { $$ = 1; }
  ;

%%

void yyerror(const char* s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter binary number: ");
    yyparse();
    return 0;
}