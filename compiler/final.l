%{
#include "final.tab.h"
#include <string.h>
%}
num	[+-]?[0-9]+
letter	[a-z]+[a-zA-Z0-9-]*
%%
"and"		{return(AND);}
"or"		{return(OR);}
"not"		{return(NOT);}
"if"		{return(IF);}
"define"	{return(DEFINE);}
"print-bool"	{return(PBOOL);}
"print-num"	{return(PNUM);}
"mod"		{return(MOD);}
{num}	{yylval.num = atoi(yytext);return(number);}
{letter} {yylval.s = strdup(yytext);return(str);}
"#t"	{yylval.num = 1;return(bval);}
"#f"	{yylval.num = 0;return(bval);}
[ \t]+   {}
"\n"	 {}
.	{return(yytext[0]);}
%%
