%option noyywrap
%{
#include "6b.tab.h"

%}
num [0-9]+
letter	[A-Z][a-z]*
%%


[ \t]+	{ }
{letter} { yylval.word = strdup(yytext); return(ELEMENT);}
{num}	{ yylval.ival = atoi(yytext);return(INUMBER);}
"->"    { return(ARROW);}
"+"     { return(yytext[0]);}
\n	{ return(0);}
"("|")" { return(yytext[0]); }

.	    {}
%%
