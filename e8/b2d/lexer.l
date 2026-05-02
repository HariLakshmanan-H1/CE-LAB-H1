%{
#include "parser.tab.h"
#include<stdio.h>

%}

%%
0 {yylval.num=0;return ZERO;}
1 {yylval.num=1;return ONE;}
"." {return POINT;}
[ \t] {}
\n {return 0;}
%%

int yywrap() {
	return 1;
}
