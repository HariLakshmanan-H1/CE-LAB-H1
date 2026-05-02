%{
    #include "parser.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
%}

%%
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.id = strdup(yytext);
    return ID;
}



"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MUL;}
"/" {return DIV;}
"^" {return EXP;}
"(" {return LPAREN;}
")" {return RPAREN;}

[ \t] {}
\n {return EOL;}

. {return yytext[0];}
%%

int yywrap() {
    return 1;
}