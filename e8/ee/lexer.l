%{
#include "parser.tab.h"
#include<stdio.h>

%}

%%
[0-9]+ {yylval.num=atoi(yytext);return digit;}

[\t] {}

[\n] {return 0;}

. {return yytext[0];}
%%

int yywrap() {
	return 1;
}
