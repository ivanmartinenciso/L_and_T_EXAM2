%{
#include "exam2.h"
extern int num_lines;
int ntemp = 0;
int mquad = 0;
int yyerror(char *);
int yylex();
char * newtemp (void);
void emit(char *op, char *arg1, char *arg2, char *res);
%}

%union
{
  struct example typeexpr;
  char t;
}

%token <typeexpr> HEXCONST 
%token <typeexpr> BINCONST 
%token <typeexpr> IDENTIFIER
%token <t> BIN HEX
%type <typeexpr> expr
%type <typeexpr> decll
%type <t> type

//operator precedence
%left '='
%left '+' '#'
%left '*' '&'
%left '!'


%%
prog : decll instrBlock {};

decll : decll decl {}
      | decl {};

decl : type IDENTIFIER ';' { if(!find($2.place))
                              {
                                looked = lookup($2.place); 
                                looked -> type = $1;
                              }
                              else
                              {
                                printf("Duplicated declaration: %s\n", $2.place);
                                yyerror("Duplicated declaration");
                                exit(0);
                              } 
                            }
            ;

type : BIN {$$ = 'B';}
     | HEX {$$ = 'H';}
     ;

instrBlock : '{' assignInstructionList '}' {} ;

assignInstructionList : assignInstructionList assignInstruction {}
                      | assignInstruction {} ;

assignInstruction : IDENTIFIER '=' expr ';' {emit("=", $3.place, "" , $1.place);}
                  ;

expr       : expr '*' expr  { if($1.type == $3.type) $$.type = $1.type;
                              else                   yyerror("Incompatible types");
                              $$.place = strdup(newtemp()); 
                              emit("and", $1.place, $3.place, $$.place);}
           | expr '+' expr  { if($1.type == $3.type) $$.type = $1.type;
                              else                   yyerror("Incompatible types");
                              $$.place = strdup(newtemp()); 
                              emit("or", $1.place, $3.place, $$.place);}
           | expr '&' expr  { if($1.type == $3.type) $$.type = $1.type;
                              else                   yyerror("Incompatible types");
                              $$.place = strdup(newtemp()); 
                              emit("nand", $1.place, $3.place, $$.place);}
           | expr '#' expr  { if($1.type == $3.type) $$.type = $1.type;
                              else                   yyerror("Incompatible types");
                              $$.place = strdup(newtemp()); 
                              emit("xor", $1.place, $3.place, $$.place);}
           | '!' expr       { $$.type = $2.type;
                              $$.place = strdup(newtemp()); 
                              emit("not", $2.place, "", $$.place);}
           | '(' expr ')'   { $$.type = $2.type;
                              $$.place = $2.place;}
           | IDENTIFIER     {if(find($1.place)) {
                                looked=lookup($1.place); 
                                $$.type=looked->type;
                                $$.place=$1.place;
                             }
                             else {
                                printf("Identifier not found: %s\n", $1.place); 
                                yyerror("Variable was never declared");
                                exit(0);
                             }
                            }
           | BINCONST       {$$.type = 'B'; $$.place=$1.place;}
           | HEXCONST       {$$.type = 'H'; $$.place=$1.place;}
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
  fputs("Symbol table overflow\n", stderr);
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

char * newtemp (void){
  char temp[10];
  sprintf(temp,"t%d",ntemp++);
  return strdup(temp);
}

void emit(char *op, char *arg1, char *arg2, char *res){
  quadtab[mquad].op=strdup(op);
  quadtab[mquad].arg1=strdup(arg1);
  quadtab[mquad].arg2=strdup(arg2);
  quadtab[mquad].res=strdup(res);
  mquad++;
}

int main(int argc, char **argv){
  yyparse();
  printf("Accepted expression. \n");

  printf("Intermediate code: \n");
  for(int i=0;i<mquad;i++){
    printf("%s %s %s %s \n",quadtab[i].op, quadtab[i].arg1,quadtab[i].arg2, quadtab[i].res);
  }

}

int yyerror(char *s){
  fprintf(stderr,"Error: %s at line %d\n", s, num_lines);
  exit(0);
}

