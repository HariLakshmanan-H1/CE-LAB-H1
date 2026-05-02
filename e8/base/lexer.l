%{
#include "parser.tab.h"
#include <string.h>
%}

%%

"if"            { return IF; }
"else"          { return ELSE; }
"printf"        { return PRINTF; }

"=="            { return EQ; }
"+"             { return PLUS; }

"("             { return OP; }
")"             { return CP; }
";"             { return SC; }
","             { return COM; }

[0-9]+          { yylval.num = atoi(yytext); return NUM; }


\"[^\"]*\" {
    yylval.str = strdup(yytext);
    return STRING;
}

[a-zA-Z_][a-zA-Z0-9_]* {
                    yylval.id = strdup(yytext);
                    return ID;
                }
				
[ \t\n]+        ;   // ignore whitespace

.               { return yytext[0]; }

%%

int yywrap() {}