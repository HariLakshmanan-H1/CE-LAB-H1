%{
    #include <stdio.h>
%}


DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
NUM         {DIGIT}+(\.{DIGIT}+)?
WS          [ \t\n]+


KEYWORDS    "if"|"else"|"while"|"for"|"int"|"float"|"return"|"void"|"char"
RELOP       "=="|"!="|"<="|">="|"<"|">"
ASSIGN      "="
ARITH       "+"|"-"|"*"|"/"
LOGIC       "&&"|"||"|"!"
SYMBOLS     [; , ( ) { } \[ \] .]

%%

{WS}          { /* Skip whitespace */ }
{KEYWORDS}    { printf("KEYWORD:   %s\n", yytext); }
{RELOP}       { printf("REL_OP:    %s\n", yytext); }
{ARITH}       { printf("ARITH_OP:  %s\n", yytext); }
{LOGIC}       { printf("LOGIC_OP:  %s\n", yytext); }
{ASSIGN}      { printf("ASSIGN_OP: %s\n", yytext); }
{ID}          { printf("ID:        %s\n", yytext); }
{NUM}         { printf("CONSTANT:  %s\n", yytext); }
{SYMBOLS}     { printf("SYMBOL:    %s\n", yytext); }

.             { printf("UNKNOWN:   %s\n", yytext); }

%%

int yywrap() { return 1; }

int main(int argc, char *argv[]) {
    if (argc > 1) yyin = fopen(argv[1], "r");
    yylex();
    return 0;
}
