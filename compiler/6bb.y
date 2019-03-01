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
%type <ename> compound formula all
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
all    : formula ARROW formula
        {
            for(int i=0;i<26;i++)
                for(int j=0;j<27;j++)
                    $$[i][j] = $1[i][j] - $3[i][j];
        }
        ;

formula : INUMBER compound  {
                            for(int i=0;i<26;i++)
                                for(int j=0;j<27;j++)
                                    $$[i][j] = $2[i][j] * $1;
                            }
        | formula '+' formula   {
                                    for(int i=0;i<26;i++)
                                        for(int j=0;j<27;j++){
                                            $$[i][j] = $1[i][j] + $3[i][j];
                                        }

                                }
        | compound              {
                                    for(int i=0;i<26;i++)
                                        for(int j=0;j<27;j++)
                                            $$[i][j] = $1[i][j];
                                }
        ;

compound: ELEMENT            {
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

                            }
        |compound INUMBER   {   for(int i=0;i<26;i++)
                                    for(int j=0;j<27;j++)
                                        $$[i][j] = $1[i][j] * $2;

                            }
        |'(' compound ')'   {
                                for(int i=0;i<26;i++)
                                    for(int j=0;j<27;j++)
                                        $$[i][j] = $2[i][j];
                            }

        |compound compound  {
                                for(int i=0;i<26;i++)
                                    for(int j=0;j<27;j++){
                                        $$[i][j] = $1[i][j] + $2[i][j];
                                    }
                            }
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
