%{
#include "exam2.h"
#include "exaxm2.tab.h"
num_lines = 1;
%}

%%
" "									{}
"bin"								{printf("BIN\n");}
"hex"								{printf("HEX\n");}
[01][01][01][01][01][01][01][01]	{printf("Bin value: %s\n", strdup(yytext));}
"0"[xX][a-fA-F0-9][a-fA-F0-9]		{printf("Hex value: %s\n", strdup(yytext));}
[=();!*+&#{}]						{printf("Operator: %s\n", strdup(yytext));}	
[a-zA-Z][a-zA-Z0-9_]*				{printf("Identifier: %s\n", strdup(yytext));}	
\n									{++num_lines;}
<<EOF>>								{return 0;}
.       							{printf("\nERROR: Illegal token: %s ",yytext); printf("at line %d\n",num_lines);}
%%