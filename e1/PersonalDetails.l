%{
#include <stdio.h>
%}

/* Definitions for patterns */
TITLE       (Mr\.|Mrs\.|Miss\.|Dr\.)
NAME        {TITLE}[[:space:]][a-zA-Z]+([\t][a-zA-Z]+)*
EMAIL       [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
AADHAR      [2-9][0-9]{3}[[:space:]][0-9]{4}[[:space:]][0-9]{4}|[2-9][0-9]{11}
MOBILE      [6-9][0-9]{9}
WHITESPACE  [ \t\n]+

%%

{NAME}        { printf("Found Name with Title: %s\n", yytext); }
{EMAIL}       { printf("Found Email: %s\n", yytext); }
{AADHAR}      { printf("Found Aadhar Number: %s\n", yytext); }
{MOBILE}      { printf("Found Mobile Number: %s\n", yytext); }
{WHITESPACE}  { /* Ignore whitespace */ }
.             { /* Ignore other characters */ }

%%

int yywrap() {
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    yylex();
    return 0;
}