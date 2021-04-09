/* Simple Calculator Parser for EECS 6083 Flex/Bison Presentation */
%{
#include <stdio.h>

extern int lineNum;
int yylex();
int yyerror(char *s);

%}

%union {
    int intVal;
}

%token T_SEMICOLON
%token <intVal> T_ADD T_SUBTRACT T_MULTIPLY T_DIVIDE T_NUM

%type <intVal> addSub multDiv

%%

lines:
    | lines statement

statement:
    addSub T_SEMICOLON { printf("Line evaluates to %d\n", $1); }

addSub:
    addSub T_ADD multDiv { $$ = $1 + $3; }
    | addSub T_SUBTRACT multDiv { $$ = $1 - $3; }
    | multDiv { $$ = $1; }

multDiv:
    { $$ = 0; }
    | multDiv T_MULTIPLY T_NUM { $$ = $1 * $3; }
    | multDiv T_DIVIDE T_NUM { $$ = $1 / $3; }
    | T_NUM { $$ = $1; }

%%

int yyerror(char *s)
{
    printf("Syntax Error on line %d\n", lineNum);
    return 0;
}

int main()
{
    yyparse();    
    return 0;
}