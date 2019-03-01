%{
#include <stdio.h>
#include <string.h>
extern int yylex(void);
void yyerror(const char *message);
char varis[50][50];
int idvalue[50];
int counter = 0;
int same = 0;
%}
%union {
	struct{                       //a struct type for int and bool.
		int val;
		int tf;
	}ele;
	int num;
	char* s;
	}
%token <num> number bval 
%token <s> str PNUM PBOOL AND OR NOT IF DEFINE MOD
%type <ele> stmt st pstmt exp numop logop defstmt plus expp minus multi expm divide mod greater smaller equal expe and expa or expo not ifexp test than elsee
%type <s> var
%left "+" "-" "*" "/" 
%%
program : stmt      	
	| stmt "\n"	
        ;
stmt	: st	        
	| stmt st       
	;
st	: exp		
	| defstmt	
	| pstmt		{}
	;
exp	: numop	{$$ = $1;}
	| logop	{$$ = $1;}
	| number{$$.val = $1;}
	| bval	{$$.tf = $1;}
	| var	{
			for(int i=0;i<counter;i++)                         //to look for the declared variable and get the value of it.
			{
				if(strcmp(varis[i],$1)==0)
				{
					$$.val = idvalue[i];
					break;	
				}				
			}
		}  
	| ifexp	{}                                         
	;
var 	: str
	;
pstmt	: '(' PNUM exp ')'	{

					printf("%d\n",$3.val);
					//for(int i=0;i<counter;i++)
						//printf("counter = %d , value = %d",counter,idvalue[counter]);
				}
	| '(' PBOOL exp ')'		{
						$3.tf==1?printf("#t\n"):printf("#f\n");
					}
	;
numop	: plus		{$$.val = $1.val;}
	| minus 	{$$.val = $1.val;}
	| multi		{$$.val = $1.val;}
	| divide	{$$.val = $1.val;}
	| mod		{$$.val = $1.val;}
	| greater	{$$.tf = $1.tf;}
	| smaller	{$$.tf = $1.tf;}
	| equal		{$$.tf = $1.tf;}
	;
plus	: '(' '+' exp expp ')'	{$$.val = $3.val + $4.val;}
	;
expp	: exp		{$$ = $1;}
	| expp exp	{$$.val = $1.val + $2.val;}
	;
minus	: '(' '-' exp exp ')'	{$$.val = $3.val - $4.val;}
	;
multi	: '(' '*' exp expm ')'	{$$.val = $3.val * $4.val;}
	;
expm	: exp		{$$ = $1;}
	| expm exp	{$$.val = $1.val * $2.val;}
	;
divide	: '(' '/' exp exp ')'	{$$.val = $3.val / $4.val;}
	;
mod	: '(' MOD exp exp ')'	{
					$$.val = $3.val % $4.val;
					
				}
	;
greater	: '(' '>' exp exp ')'	{
					if($3.val>$4.val)
						$$.tf = 1;
					else{
						$$.tf = 0;
					}
				}
	;
smaller	: '(' '<' exp exp ')'	{
					if($3.val<$4.val)
						$$.tf = 1;
					else{
						$$.tf = 0;
					}
				}
	;
equal	: '(' '=' exp expe ')'	{
					if($3.val==$4.val)
						$$.tf = 1;
					else{
						$$.tf = 0;
					}
				}
	;
expe	: exp		{$$ = $1;}
	| expe exp		{
					if($1.val==$2.val)
						$$.tf = 1;
					else{
						$$.tf = 0;
					}
				}
	;
logop	: and	{$$.tf = $1.tf;}
	| or	{$$.tf = $1.tf;}
	| not	{$$.tf = $1.tf;}
	;
and	: '(' AND exp expa ')'	{
						if($3.tf==1 && $4.tf==1)
							$$.tf = 1;
						else{
							$$.tf = 0;
						}
					}
	;
expa    : exp				{$$ = $1;}
	| expa exp			{
						if($1.tf==1 && $2.tf==1)
							$$.tf = 1;
						else{
							$$.tf = 0;
						}
					}
	;
or	: '(' OR exp expo ')'		{
						if($3.tf==0 && $4.tf==0)
							$$.tf = 0;
						else{
							$$.tf = 1;
						}
					}
	;
expo	: exp				{$$ = $1;}
	| expa exp			{
						if($1.tf==0 && $2.tf==0)
							$$.tf = 0;
						else{
							$$.tf = 1;
						}
					}
	;
not	: '(' NOT exp ')'	{
					if($3.tf)
						$$.tf = 0;
					else{
						$$.tf = 1;
					}
				}
	;
defstmt	: '(' DEFINE var exp ')'	{
					if(counter==0)                    //if first string to be declared, simply put it in the global array.
					{
						strcpy(varis[counter],$3);
						idvalue[counter] = $4.val;
						counter++;
					}else{                     //check if the string has been declared or not.
						for(int i = 0;i<counter;i++)
						{
							if(varis[i]==$3)
								same = 1;
						}
						if(same==1)                                //declared.
							printf("Variable declared.");
						else{                              //put the string in the global array.
							strcpy(varis[counter],$3);
							idvalue[counter] = $4.val;
							counter++;
						}
							same = 0;
					}
				}
	;
ifexp	:'(' IF test than elsee ')'	{
						if($3.tf==1)
							$$.val = $4.val;
						else{
						
							$$.val = $5.val;
						}						
					}

	;
test	: exp	{$$.tf = $1.tf;}
	;
than	: exp	{$$.val = $$.val;}
	;
elsee	: exp	{$$.val = $$.val;}
	;
%%
void yyerror(const char *str)
{
    printf("%s\n",str);
}
int main()
{
	yyparse();
	return(0);
}
