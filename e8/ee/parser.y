%{
#include<stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
int x[5],y[5],k,j[5],a[5][10],e,w;

extern int yylex();
void yyerror(const char* s);
int powr(int m,int n)
{
	int ans=1;
	while(n) { ans=ans*m; n--; }
	return ans;
}

%}

%union {
	int num;
}

%type <num> S E E1 T T1 Z Z1 F
%token <num> digit
%start S


%%
S : 
	E { printf("\nAnswer : %d\n",$1); }
	;
E : 
	T { x[e]=$1; } E1 { $$=x[e]; }
	;
E1 : 
	'+' T { w=x[e]; x[e]=x[e]+$2; printf("Addition Operation %d and %d : %d\n",w,$2,x[e]); } E1 { $$=x[e]; }
	| '-' T { w=x[e]; x[e]=x[e]-$2; printf("Subtraction Operation%d and %d : %d\n",w,$2,x[e]); } E1 { $$=x[e]; }
	| { $$=x[e]; }
	;
T : 
	Z { y[e]=$1; } T1 { $$=y[e]; }
	;
T1 : 
	'*' Z { w=y[e]; y[e]=y[e]*$2; printf("Multiplication Operation of %d and %d : %d\n",w,$2,y[e]); } T1 { $$=y[e]; }
	| { $$=y[e]; }
	;
Z : 
	F { a[e][j[e]++]=$1; } Z1 { $$=$3; }
	;
Z1 : 
	'^' Z { $$=$2; }

	| { for(k=j[e]-1;k>0;k--) { w=a[e][k-1]; a[e][k-1]=powr(a[e][k-1],a[e][k]); printf("Power Operation %d ^ %d :%d\n",w,a[e][k],a[e][k-1]); } $$=a[e][0]; j[e]=0; }
	;
F : 
	digit { $$=$1; printf("Digit : %d\n",$1); }
	| '(' { e++; } E { e--; } ')' { $$=$3; }

	;
%%

void yyerror(const char* s)
{
	printf("Error!");
}



int main(int argc, char *argv[]) {
	//initializing all the variables to zero
	for(e=0;e<5;e++) { x[e]=y[e]=0; j[e]=0; }
	e=0;
	// takes input as a expression
	printf("Enter an expression\n");
    

    yyparse();

}
