%option noyywrap
%{
#include "6b.tab.h"

%}
%%

\n	{ return(0);}
[ \t]+	{ }
[A-Z][a-z]* { yylval.word = strdup(yytext); return(ELEMENT);}
[0-9]+	{ yylval.ival = atoi(yytext);return(INUMBER);}
"->"    { return(ARROW);}
"+"     { return(yytext[0]);/*yylval.word = strdup(yytext);*/}

"("|")" { return(yytext[0]); }

.	    {}
%%
