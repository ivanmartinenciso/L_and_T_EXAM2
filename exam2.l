%{
#include "exam2.h"
#include "exam2.tab.h"
int num_lines = 1;
%}

%%
" "					{}
"bin"					{printf("BIN\n"); yylval.t = 'B'; return(BIN);}
"hex"					{printf("HEX\n"); yylval.t = 'H'; return(HEX);}
[01][01][01][01][01][01][01][01]	{printf("Bin value: %s\n", strdup(yytext)); yylval.typeexpr.place = strdup(yytext); return(BINCONST);}
"0"[xX][a-fA-F0-9][a-fA-F0-9]		{printf("Hex value: %s\n", strdup(yytext)); yylval.typeexpr.place = strdup(yytext); return(HEXCONST);}
[=();!*+&#{}]				{printf("Operator: %s\n", strdup(yytext)); return(yytext[0]);}	
[a-zA-Z][a-zA-Z0-9_]*			{printf("Identifier: %s\n", strdup(yytext)); yylval.typeexpr.place = strdup(yytext); return(IDENTIFIER);}	
\n					{++num_lines;}
<<EOF>>					{return 0;}
.       				{printf("\nERROR: Illegal token: %s ",yytext); printf("at line %d\n",num_lines);}
%%
