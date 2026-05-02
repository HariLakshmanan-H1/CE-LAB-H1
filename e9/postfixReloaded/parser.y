%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylex();
    extern int yyparse();
    void yyerror(const char *s);
%}

%union {
    char *id;
}

%token <id> ID
%token PLUS MINUS MUL DIV EXP LPAREN RPAREN EOL

%left PLUS MINUS
%left MUL DIV
%right EXP

%%

input :
    | input line
    ;

line :
    expr EOL    {printf("\n"); }
    | EOL
    ;

expr :
     expr PLUS expr {printf("+");}
    | expr MINUS expr {printf("-");}
    | expr MUL expr {printf("*");}
    | expr DIV expr {printf("/");}
    | expr EXP expr { printf("^"); }
    | LPAREN expr RPAREN 
    | ID    {printf("%s",$1); free($1);}
    | NUMBER {printf("%s",$1); free($1);}
    ;
%%

void yyerror(const char* s) {
    printf("Some error\n");
}

int main() {
    printf("Enter the expression : ");
    yyparse();
    return 0;
}