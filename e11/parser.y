%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    void yyerror(char *s);
    extern FILE *yyin;
    extern int yylex();
%}

%union {int ival;char *sval;}
%token <ival> NUMBER
%token <sval> ID
%token EOL

%%
stmt_list : stmt
    | stmt_list stmt
    ;

stmt : ID '=' ID '+' ID EOL {printf("LDA %s\nLDT %s\nADDR A,T\nSTA %s\n",$3,$5,$1);}
    | ID '=' ID '-' ID EOL {printf("LDA %s\nLDT %s\nSUBR A,T\nSTA %s\n",$3,$5,$1);}
    | ID '=' ID '*' ID EOL {printf("LDA %s\nLDT %s\nMULR A,T\nSTA %s\n",$3,$5,$1);}
    | ID '=' ID '/' ID EOL {printf("LDA %s\nLDT %s\nDIVR A,T\nSTA %s\n",$3,$5,$1);}
    | ID '=' NUMBER EOL {printf("LDA #%d\nSTA %s\n",$3,$1);}
    | ID '=' ID EOL {printf("LDA %s\nSTA %s\n",$3,$1);}
    | ID '=' ID '+' NUMBER EOL {printf("LDA %s\nLDT #%d\nADDR A,T\nSTA %s\n",$3,$5,$1);}
    | ID '=' ID '-' NUMBER EOL {printf("LDA %s\nLDT #%d\nSUBR A,T\nSTA %s\n",$3,$5,$1);}
    | ID '=' NUMBER '+' ID EOL {printf("LDA #%d\nLDT %s\nADDR A,T\nSTA %s\n",$3,$5,$1);}
    | ID '=' NUMBER '-' ID EOL {printf("LDA #%d\nLDT %s\nSUBR A,T\nSTA %s\n",$3,$5,$1);}
    | EOL ;

%%

void yyerror(char *s) {printf("Error : %s\n",s);}

int main(int argc,char* argv[]) {
    FILE *input_file = fopen(argv[1],"r");
    yyin = input_file;
    yyparse();
    fclose(yyin);
}
    