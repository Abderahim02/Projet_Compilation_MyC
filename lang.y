%{

#include "Table_des_symboles.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int yyparse();

void yyerror (char* s) {
  printf ("%s\n",s);
  exit(0);
  }
		
 int depth=0; // block depth
 
 char* concatenate_strings(char* str1, char* str2) {
  char* result = (char*)malloc(strlen(str1) + strlen(str2) + 1);
  strcpy(result, str1);
  strcat(result, str2);
  return result;
}


char* intToString(int number) {
    // Determine the number of digits in the integer
    int numDigits = snprintf(NULL, 0, "%d", number);

    // Allocate memory for the string (including space for null terminator)
    char* result = (char*)malloc((numDigits + 1) * sizeof(char));

    // Convert the integer to a string
    snprintf(result, numDigits + 1, "%d", number);

    return result;
}
%}

%union { 
  struct ATTRIBUTE * symbol_value;
  char * string_value;
  int int_value;
  float float_value;
  int type_value;
  int label_value;
  int offset_value;
}

%token <int_value> NUM
%token <float_value> DEC


%token INT FLOAT VOID

%token <string_value> ID
%token AO AF PO PF PV VIR
%token RETURN  EQ
%token <label_value> IF ELSE WHILE

%token <label_value> AND OR NOT DIFF EQUAL SUP INF
%token PLUS MOINS STAR DIV
%token DOT ARR

%nonassoc IFX
%left OR                       // higher priority on ||
%left AND                      // higher priority on &&
%left DIFF EQUAL SUP INF       // higher priority on comparison
%left PLUS MOINS               // higher priority on + - 
%left STAR DIV                 // higher priority on * /
%left DOT ARR                  // higher priority on . and -> 
%nonassoc UNA                  // highest priority on unary operator
%nonassoc ELSE


%{
char * type2string (int c) {
  switch (c)
    {
    case INT:
      return("int");
    case FLOAT:
      return("float");
    case VOID:
      return("void");
    default:
      return("type error");
    }  
};

  
  %}


%start prog  

// liste de tous les non terminaux dont vous voulez manipuler l'attribut
%type <type_value> type exp  typename
%type <string_value> fun_head

 /* Attention, la rêgle de calcul par défaut $$=$1 
    peut créer des demandes/erreurs de type d'attribut */

%%

 // O. Déclaration globale

prog : glob_decl_list              {}

glob_decl_list : glob_decl_list fun {}
| glob_decl_list decl PV       {}
|                              {} // empty glob_decl_list shall be forbidden, but usefull for offset computation

// I. Functions

fun : type fun_head fun_body   {}
;

fun_head : ID PO PF            {
    // Pas de déclaration de fonction à l'intérieur de fonctions !
    if (depth>0) yyerror("Function must be declared at top level~!\n");
      printf("%s pcode_%s()", type2string($<type_value>0), $1);
    }

| ID PO params PF              {
    // Pas de déclaration de fonction à l'intérieur de fonctions !
    if (depth>0) yyerror("Function must be declared at top level~!\n");
    char * parameters = $<string_value>3;
    printf("%s pcode_%s( %s )", type2string($<type_value>0), $1,parameters);
    free(parameters);
 }
;

params: type ID vir params     {
                    $<string_value>$ = concatenate_strings(
                      concatenate_strings(
                        concatenate_strings(type2string($<type_value>1), " " ), concatenate_strings($2, ",")), 
                        $<string_value>4);
                                } // récursion droite pour numéroter les paramètres du dernier au premier
| type ID                      { 
                    $<string_value>$ = concatenate_strings(concatenate_strings(type2string($<type_value>1), " "), $2);
}


vir : VIR                      { /*$<string_value>$ = concatenate_strings($<string_value>$, ",") ;*/
                                /*$<string_value>1 = ", ";*/}
;

fun_body : fao block faf       {}
;

fao : AO                       { printf("{\n") ;depth++;}
;
faf : AF                       {printf("}\n") ;depth--;}
;


// II. Block
block:
decl_list inst_list            { depth++;}
;

// III. Declarations

decl_list : decl_list decl PV   {} 
|                               {}
;

decl: var_decl                  {}
;

var_decl : type vlist          { 
                                char * list = $<string_value>2 ;
                                printf("%s", list);
                                free(list);}
;

vlist: vlist vir ID            { // récursion gauche pour traiter les variables déclararées de gauche à droite
                                    int offset_value = 0; // à calculer
                                    if(depth == 0){ //pour les variables globales
                                      set_symbol_value($3, makeSymbol( $<type_value>0 , 0 , 0));
                                      if($<type_value>0 == INT){
                                        char * str1 = concatenate_strings("LOADI(", concatenate_strings(intToString(get_symbol_value($3)->offset), ")\n"));
                                        $<string_value>$ = concatenate_strings($<string_value>1, str1);
                                      }
                                      else if($<type_value>0 == FLOAT){
                                        char * str1 = concatenate_strings("LOADF(", concatenate_strings(intToString(get_symbol_value($3)->offset), ")\n"));
                                        $<string_value>$ = concatenate_strings($<string_value>1, str1);
                                      }
                                    }
                                 else {
                                      set_symbol_value($3, makeSymbol( $<type_value>0 , depth + offset_value , depth));
                                      if($<type_value>0 == INT){
                                        char * str1 = concatenate_strings("LOADI(", concatenate_strings(intToString(get_symbol_value($3)->offset), ")\n"));
                                        $<string_value>$ = concatenate_strings($<string_value>1, str1);
                                      }
                                      else if($<type_value>0 == FLOAT){
                                        char * str1 = concatenate_strings("LOADF(", concatenate_strings(intToString(get_symbol_value($3)->offset), ")\n"));
                                        $<string_value>$ = concatenate_strings($<string_value>1, str1);
                                      }
                                 } 
} 
| ID                           {
                                    int offset_value = 0; // à calculer
                                    if(depth == 0){ //pour les variables globales
                                      set_symbol_value($1, makeSymbol( $<type_value>0 , offset_value , 0));
                                      char * str1;
                                      if($<type_value>0 == INT){
                                        str1 = concatenate_strings("LOADI(", concatenate_strings(intToString(get_symbol_value($1)->offset), ")\n"));
                                      }
                                      else if($<type_value>0 == FLOAT){
                                         str1 = concatenate_strings("LOADF(", concatenate_strings(intToString(get_symbol_value($1)->offset), ")\n"));
                                      }
                                      $<string_value>$ = str1;
                                    }
                                 else{
                                        set_symbol_value($1, makeSymbol( $<type_value>0 , depth + offset_value, depth));
                                        char * str1;
                                        if($<type_value>0 == INT){
                                          str1 = concatenate_strings("LOADI(", concatenate_strings(intToString(get_symbol_value($1)->offset), ")\n"));
                                        }
                                        else if($<type_value>0 == FLOAT){
                                          str1 = concatenate_strings("LOADF(", concatenate_strings(intToString(get_symbol_value($1)->offset), ")\n"));
                                        }
                                        $<string_value>$ = str1;
                                  }
}                             
;

type
: typename                     {}
;

typename
: INT                          {$$=INT;}
| FLOAT                        {$$=FLOAT;}
| VOID                         {$$=VOID;}
;

// IV. Intructions

inst_list: inst_list inst   {} 
| inst                      {}
;

pv : PV                       {}
;
 
inst:
ao block af                   {}
| aff pv                      {}
| ret pv                      {}
| cond                        {}
| loop                        {}
| pv                          {}
;

// Accolades explicites pour gerer l'entrée et la sortie d'un sous-bloc

ao : AO                       {depth++;}
;

af : AF                       {depth--;}
;


// IV.1 Affectations

aff : ID EQ exp               { 
      printf("STOREP(%d)\n",get_symbol_value($1)->offset );
      }
;


// IV.2 Return
ret : RETURN exp              { printf("return;\n");}
| RETURN PO PF                {printf("return();\n");}
;

// IV.3. Conditionelles
//           N.B. ces rêgles génèrent un conflit déclage reduction
//           qui est résolu comme on le souhaite par un décalage (shift)
//           avec ELSE en entrée (voir y.output)

cond :
if bool_cond inst  elsop       {}
;

elsop : else inst              {}
|                  %prec IFX   {} // juste un "truc" pour éviter le message de conflit shift / reduce
;

bool_cond : PO exp PF         {}
;

if : IF                       {}
;

else : ELSE                   {}
;

// IV.4. Iterations

loop : while while_cond inst  {}
;

while_cond : PO exp PF        {}

while : WHILE                 {}
;


// V. Expressions

exp
// V.1 Exp. arithmetiques
: MOINS exp %prec UNA         {}
         // -x + y lue comme (- x) + y  et pas - (x + y)
| exp PLUS exp                { 
                              if ($1 == INT) {
                                  if ($3 == INT) {
                                      $$ = INT;
                                  }
                                  else if ($3 == FLOAT) {
                                      printf("I2F2\n");
                                  }
                              }
                              else if ($1 == FLOAT) {
                                  if ($3 == INT) {
                                      printf("I2F\n");
                                  }
                                  else if ($3 == FLOAT) {
                                      $$ = FLOAT;
                                  }
                              }
                              if ($$ == INT) { printf("ADDI\n");}
                              else if ($$ == FLOAT) { printf("ADDF\n");}
                              }
| exp MOINS exp               {
                              if ($1 == INT) {
                                  if ($3 == INT) {
                                      $$ = INT;
                                  }
                                  else if ($3 == FLOAT) {
                                      printf("I2F2\n");
                                  }
                              }
                              else if ($1 == FLOAT) {
                                  if ($3 == INT) {
                                      printf("I2F\n");
                                  }
                                  else if ($3 == FLOAT) {
                                      $$ = FLOAT;
                                  }
                              }
                              if ($$ == INT) { printf("SUBI\n");}
                              else if ($$ == FLOAT) { printf("SUBF\n");}
                              }
| exp STAR exp                {
                                if ($1 == INT) {
                                  if ($3 == INT) {
                                      $$ = INT;
                                  }
                                  else if ($3 == FLOAT) {
                                      printf("I2F2\n");
                                  }
                              }
                              else if ($1 == FLOAT) {
                                  if ($3 == INT) {
                                      printf("I2F\n");
                                  }
                                  else if ($3 == FLOAT) {
                                      $$ = FLOAT;
                                  }
                              }
                              if ($$ == INT) { printf("MULTI\n");}
                              else if ($$ == FLOAT) { printf("MULTF\n");}
                                }               
| exp DIV exp                 { 
                              if ($1 == INT) {
                                  if ($3 == INT) {
                                      $$ = INT;
                                  }
                                  else if ($3 == FLOAT) {
                                      printf("I2F2\n");
                                  }
                              }
                              else if ($1 == FLOAT) {
                                  if ($3 == INT) {
                                      printf("I2F\n");
                                  }
                                  else if ($3 == FLOAT) {
                                      $$ = FLOAT;
                                  }
                              }
                              if ($$ == INT) { printf("DIVI\n");}
                              else if ($$ == FLOAT) { printf("DIVF\n");}
                              }
| PO exp PF                   {}
| ID                          {printf("LOADP(%d)\n", get_symbol_value($1)->offset);}
| app                         {}
| NUM                         {$$ = INT ; printf("LOADI(%d)\n", $1 );}
| DEC                         {$$ = FLOAT; printf("LOADF(%f)\n", $1 );}


// V.2. Booléens

| NOT exp %prec UNA           {}
| exp INF exp                 {}
| exp SUP exp                 {}
| exp EQUAL exp               {}
| exp DIFF exp                {}
| exp AND exp                 {}
| exp OR exp                  {}

;

// V.3 Applications de fonctions


app : fid PO args PF          {}
;

fid : ID                      {}

args :  arglist               {}
|                             {}
;

arglist : arglist VIR exp     {} // récursion gauche pour empiler les arguements de la fonction de gauche à droite
| exp                         {}
;



%% 
int main () {

  /* Ici on peut ouvrir le fichier source, avec les messages 
     d'erreur usuel si besoin, et rediriger l'entrée standard 
     sur ce fichier pour lancer dessus la compilation.
   */

char * header=
"// PCode Header\n\
#include \"PCode.h\"\n\
\n\
int main() {\n\
pcode_main();\n\
return srack[sp-1].int_value;\n\
}\n";  

 printf("%s\n",header); // ouput header
  
return yyparse ();
 
 
} 

