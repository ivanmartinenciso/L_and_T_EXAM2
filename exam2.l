%{
#include "exam2.h"
#include "exam2.tab.h"
int num_lines = 1;
%}

%%
" "									{}
"bin"								{yylval.t = 'B'; return(BIN);}
"hex"								{yylval.t = 'H'; return(HEX);}
[01][01][01][01][01][01][01][01]	{yylval.typeexpr.place = strdup(yytext); return(BINCONST);}
"0"[xX][a-fA-F0-9][a-fA-F0-9]		{yylval.typeexpr.place = strdup(yytext); return(HEXCONST);}
[=();!*+&#{}]						{return(yytext[0]);}	
[0-9]+[a-zA-Z][a-zA-Z0-9_]*			{}
[a-zA-Z][a-zA-Z0-9_]*				{yylval.typeexpr.place = strdup(yytext); return(IDENTIFIER);}	
\n									{++num_lines;}
<<EOF>>								{return 0;}
.       							{}
%%
