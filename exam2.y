%{
#include "exam2.h"
%}


%union
{
  struct example typeexpr;
	double d;
	char *s;
  char t;
}

%token <d> INTCONST DOUCONST
%token <s> IDENT
%token <t> BIN HEX
%type <typeexpr> expr
%type <typeexpr> term
%type <typeexpr> fact
%type <typeexpr> decll
%type <t> Type

//operator precedence
%left '+' '#'
%left '*' '&'
%right '!'


%%
Program : Declaration* InstructionBlock 
        ;

Declaration : Type IDENT ';' { if(!find($2))
                              {
                                place = lookup($2); 
                                place -> type = $1;
                              }
                              else
                              {
                                printf("Error: Redeclaration of identifier: %s\n", $2);
                              } 
                            }
            ;

Type : BIN {$$ = 'B'}
     | HEX {$$ = 'H'}
     ;

InstructionBlock : '{' AssignInstruction* '}'
                 | 
                 ;

AssignInstruction : IDENT '=' Expression ';'
                  ;

Expression : Expression * Expression 
           | Expression + Expression 
           | Expression & Expression 
           | Expression # Expression
           | ! Expression # Expression
start : decll expr {printf("El tipo del resultado es: %c\n",$2.type);}
      ;

decll : decll decl 
	| decl {}
	;
decl : tipo IDENT ';' {if(!find($2)) {place=lookup($2); place->type=$1;}
                       else {printf("Decl duplicada del identificador %s\n", $2);
                             } }

tipo : DOUBLE {$$ ='D';} 
     | INT {$$ = 'I';}
     ;

expr : expr '+' term {if($1.type == $3.type) $$.type = $1.type;
			else yyerror("tipos incompatibles");}
     | term {$$.type = $1.type;}
     ;

term : term '*' fact {if($1.type == $3.type) $$.type = $1.type;
			else yyerror("tipos incompatibles");}
     | fact {$$.type = $1.type;}
     ;

fact : '(' expr ')' {$$.type = $2.type;}
     | INTCONST {$$.type = 'I';}
     | DOUCONST {$$.type = 'D';} 
     | IDENT {if(find($1)) {place=lookup($1); $$.type=place->type;}
                       else {printf("Identificador no declarado %s\n", $1); }}
     ;
%%

static unsigned
symhash(char *sym)
{
  unsigned int hash = 0;
  unsigned c;

  while(c = *sym++) hash = hash*9 ^ c;

  return hash;
}

int nnew, nold;
int nprobe;

struct symbol *
lookup(char* sym)
{
  struct symbol *sp = &symtab[symhash(sym)%NHASH];
  int scount = NHASH;		/* how many have we looked at */

  while(--scount >= 0) {
    nprobe++;
    if(sp->name && !strcmp(sp->name, sym)) { nold++; return sp; }

    if(!sp->name) {		/* new entry */
      nnew++;
      sp->name = strdup(sym);
      return sp;
    }

    if(++sp >= symtab+NHASH) sp = symtab; /* try the next entry */
  }
  fputs("symbol table overflow\n", stderr);
  abort(); /* tried them all, table is full */

}


char find (char* sym)
{
  struct symbol *sp = &symtab[symhash(sym)%NHASH];
  int scount = NHASH;		/* how many have we looked at */

  while(--scount >= 0)
    if(sp->name && !strcmp(sp->name, sym)) return 1;
  return 0;

}

int main(int argc, char **argv)
{
yyparse();
printf("Accepted expression. \n");
}

int yyerror(char *s)
{
fprintf(stderr,"Error: %s at line %d\n", s, num_lines);
exit(0);
}

