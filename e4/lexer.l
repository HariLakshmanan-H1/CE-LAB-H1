%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%%

"int"       { return INT; }
"return"    { return RETURN; }

"while"     { return WHILE; }
"for"       { return FOR; }
"if"        { return IF; }
"else"      { return ELSE; }

"++"        { return INC; }
"--"        { return DEC; }

"<="        { return LE; }
">="        { return GE; }
"=="        { return EQ; }
"!="        { return NE; }

[=+*/><(){};,\[\]] { return yytext[0]; }
"-"         { return '-'; }

[0-9]+      { yylval.num = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return ID; }

[ \t\r\n]+  { /* ignore whitespace */ }

.           { printf("Unknown character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
