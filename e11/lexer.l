%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"   /* Token definitions from Yacc/Bison */


%}

%option noyywrap

%%
[ \t]+          /* skip whitespace */

[a-zA-Z][a-zA-Z0-9]*  {
                    yylval.sval = strdup(yytext);
                    return ID;
                }

[0-9]+          {
                    yylval.ival = atoi(yytext);
                    return NUMBER;
                }

"="             { return '='; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }

"\n"            { return EOL; }
<<EOF>>    { return EOL; }

.               { /* ignore other characters? or report error */ }

%%