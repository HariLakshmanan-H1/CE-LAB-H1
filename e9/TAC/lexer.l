%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
[0-9]+ { yylval.num=atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id=strdup(yytext); return ID; }

[=+\-*/()] return yytext[0];
\n return '\n';
[ \t] ;

. { printf("Invalid: %s\n",yytext); }
%%

int yywrap(){ return 1; }