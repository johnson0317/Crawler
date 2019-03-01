%{
#include <iostream>
#include <vector>
#include <string>
#include <cstring>
#include <sstream>
using namespace std;
extern int yylex();
void yyerror(const char *message);

%}
%union {

    char* word;
    int ival;
    int ename[26][27];

}
%token <ival> INUMBER
%token <word> ELEMENT
%token ARROW
%type <ename> comp form all
%right INUMBER

%%

line   : all        {
                        for(int i=0;i<26;i++){
                            for(int j=0;j<27;j++){
                                if($1[i][j]!=0){
                                    cout<<(char)(i+65);
                                    if(j!=0)
                                        cout<<(char)(j+96);
                                    cout<<" "<<$1[i][j]<<endl;
                                }
                            }
                        }
                    }
       ;
all    : form ARROW form	
        {
            for(int i=0;i<26;i++)
                for(int j=0;j<27;j++)
                    $$[i][j] = $1[i][j] - $3[i][j];
        }
        ;

form : INUMBER comp  {
                            for(int i=0;i<26;i++)
                                for(int j=0;j<27;j++)
                                    $$[i][j] = $2[i][j] * $1;
                            }
        
				/*expr	:	expr "+" expr	{

					for(int i=0;$3.letter[i] != 0;i++)                   //merge two structs into one.
					{
						for(int j=0;$1.letter[j]!=0;j++)
						{
							if($1.letter[j]==$3.letter[i])
							{
								$1.num[j] += $3.num[i];
								changed1 = 1;
							}
						}
						if(changed1==0)
						{
							for(int z=0;z<40;i++)
							{
								if($$.letter[z]==0)
								{
									$1.letter[z+1] = 0;
									$1.letter[z] = $3.letter[i];
									$1.num[z] = $3.num[i];
								}
							} 
						}
						changed1 = 0;
					}


					$$ = $1;




				}*/
	| form '+' form   {
                                    for(int i=0;i<26;i++)
                                        for(int j=0;j<27;j++){
                                            $$[i][j] = $1[i][j] + $3[i][j];
                                        }

                                }
        | comp              {
                                    for(int i=0;i<26;i++)
                                        for(int j=0;j<27;j++)
                                            $$[i][j] = $1[i][j];
                                }
        ;

comp: ELEMENT            {
                                /*for(int i=0;i<2;i++){
                                    if((int)$1[i]!=0)
                                        cout<<(int)$1[i]<<endl;
                                }
                                */
                                for(int i=0;i<26;i++)
                                    for(int j=0;j<27;j++)
                                        $$[i][j] = 0;

                                if((int)$1[1]==0)
                                    $$[(int)$1[0]-65][0] = 1;
                                else
                                    $$[(int)$1[0]-65][(int)$1[1]-96] = 1;

       
        |'(' comp ')'   {
                                for(int i=0;i<26;i++)
                                    for(int j=0;j<27;j++)
                                        $$[i][j] = $2[i][j];
                            }
	                     }
        |comp INUMBER   {   for(int i=0;i<26;i++)
                                    for(int j=0;j<27;j++)
                                        $$[i][j] = $1[i][j] * $2;

                            }

        |comp comp  {
                                for(int i=0;i<26;i++)
                                    for(int j=0;j<27;j++){
                                        $$[i][j] = $1[i][j] + $2[i][j];
                                    }
                            }
/*   |	letofel letofel {
					for(int i=0;$$.letter[i]!=0;i++)                            //check if anything is the same
					{
						if($$.letter[i] == $1)                       // insert the letter into the struct in a specific
						{                                            //position and increase the number of the position.
							$$.num[i] += $1;
							changed1 = 1;
						}
						else if($$.letter[i] == $2)
						{
							$$.num[i] += $2;
							changed2 = 1;
						}
						
					}	
					for(int i=0;i<40;i++)
					{
						if($$.letter[i]==0)
							if(changed1 == 1&&changed2==0)
							{
								$$.letter[i+1] = 0;
								$$.letter[i] = $2;
								$$.num[i] = 1;
							}else if(changed1==0&&changed2==1)
							{
								$$.letter[i+1] = 0;
								$$.letter[i] = $1;
								$$.num[i] = 1;
							}else if(changed1==0&&changed2==0)
							{
								$$.letter[i+1] = 0;
								$$.letter[i] = $1;
								$$.num[i] = 1;
								$$.letter[i+2] = 0;
								$$.letter[i+1] = $2;
								$$.num[i+1] = 1;
							}
					}          
					
					changed1 = 0;
					changed2 = 0;
				}*/
        ;

%%
void yyerror (const char *message)
{
    cout<<"Invalid format";
}

int main() {

    yyparse();
    return 0;
}
