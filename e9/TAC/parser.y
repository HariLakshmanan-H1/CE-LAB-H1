%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex(); void yyerror(const char*s);

char st[100][25]; int top=0,t=0,ti[100];

void push(char*s){ strcpy(st[++top],s); }

char* v(int i,char*b){
    return st[i][0]=='t'?(sprintf(b,"t%d",ti[i]),b):(strcpy(b,st[i]),b);
}

void gen(char*op){
    char l[25],r[25];
    printf("t%d = %s %s %s\n",t,v(top-2,l),op,v(top-1,r));
    top-=2; sprintf(st[top],"t%d",t); ti[top]=t++;
}

void umin(){
    char b[25];
    printf("t%d = -%s\n",t,v(top,b));
    sprintf(st[top],"t%d",t); ti[top]=t++;
}

void assign(){
    char b[25];
    printf("%s = %s\n",st[top-1],v(top,b));
    top-=2;
}
%}

%union{ int num; char*id; }

%token <id> ID
%token <num> NUM
%left '+' '-'
%left '*' '/'
%left UMINUS

%%

input : ID '=' { push($1); } E '\n' { assign(); free($1); printf("Completed\n"); }
;

E : E '+' T { push("+"); gen("+"); }
  | E '-' T { push("-"); gen("-"); }
  | T
;

T : T '*' F { push("*"); gen("*"); }
  | T '/' F { push("/"); gen("/"); }
  | F
;

F : '(' E ')'
  | '-' F %prec UMINUS { umin(); }
  | ID { push($1); free($1); }
  | NUM { char b[25]; sprintf(b,"%d",$1); push(b); }
;

%%

void yyerror(const char*s){ printf("Syntax error\n"); }

int main() { 
    printf("Enter the expression: "); 
    yyparse();
    return 1;
}