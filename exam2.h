#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct  example  {
        char type;
	double val;
        };

struct symbol {
    char type;	
    char *name;
  };

#define NHASH 9997
struct symbol symtab[NHASH];

struct symbol *lookup(char*);

char find(char*);

struct symbol *place;

int yyerror(char *);

int yylex();

int num_lines;
