/* Parser for EECS 6083 Project Language */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int lineNum;
int yylex();
int yyerror(char *s);
   
%}

%union {
    char* strVal;
    int intVal;
    float floatVal;
}

%token  T_LPAREN T_RPAREN T_LSQBRACKET T_RSQBRACKET T_LCURBRACKET T_RCURBRACKET
        T_SEMICOLON T_COLON T_COMMA T_PERIOD
        T_ASSIGN T_AND T_OR
        T_LESSTHAN T_GREATERTHAN T_LESSTHANEQUALTO T_GREATERTHANEQUALTO T_EQUALS T_NOTEQUALS
        T_ADD T_SUBTRACT T_MULTIPLY T_DIVIDE
        T_EOF
        T_PROGRAM T_IS T_BEGIN T_END T_GLOBAL T_PROCEDURE T_VARIABLE T_INTEGER T_FLOAT T_STRING T_BOOL T_IF T_THEN T_ELSE T_FOR T_RETURN T_NOT T_TRUE T_FALSE
%token  <strVal> T_STRINGCONST T_IDENTIFIER
%token  <intVal> T_INTCONST
%token  <floatVal> T_FLOATCONST

%%

program:
    program_header program_body T_PERIOD
;

program_header:
    T_PROGRAM identifier T_IS
;

program_body:
    declarations T_BEGIN statements T_END T_PROGRAM
;

declarations:
    | declaration T_SEMICOLON declarations
;

declaration:
    T_GLOBAL procedure_declaration
    | T_GLOBAL variable_declaration
    | procedure_declaration
    | variable_declaration
;

procedure_declaration:
    procedure_header procedure_body
;

procedure_header:
    T_PROCEDURE identifier T_COLON type_mark T_LPAREN T_RPAREN
    | T_PROCEDURE identifier T_COLON type_mark T_LPAREN parameter_list T_RPAREN
;

parameter_list:
    parameter T_COMMA parameter_list
    | parameter
;

parameter:
    variable_declaration
;

procedure_body:
    declarations T_BEGIN statements T_END T_PROCEDURE
;

variable_declaration:
    T_VARIABLE identifier T_COLON type_mark
    | T_VARIABLE identifier T_COLON type_mark T_LSQBRACKET bound T_RSQBRACKET
;

type_mark:
    T_INTEGER | T_FLOAT | T_STRING | T_BOOL
;

bound:
    number
;

statements:
    | statement T_SEMICOLON statements
;

statement:
    assignment_statement
    | if_statement
    | loop_statement
    | return_statement
;

procedure_call:
    identifier T_LPAREN argument_list T_RPAREN
;

assignment_statement:
    destination T_ASSIGN expression
;

destination:
    identifier
    | identifier T_LSQBRACKET expression T_RSQBRACKET
;

if_statement:
    T_IF T_LPAREN expression T_RPAREN T_THEN statements T_END T_IF
    | T_IF T_LPAREN expression T_RPAREN T_THEN statements T_ELSE statements T_END T_IF
;

loop_statement:
    T_FOR T_LPAREN assignment_statement T_SEMICOLON expression T_RPAREN statements T_END T_FOR
;

return_statement:
    T_RETURN expression
;

identifier:
    T_IDENTIFIER
;

expression:
    expression T_AND expression
    | expression T_OR expression
    | arithOp
    | T_NOT arithOp
;

arithOp:
    arithOp T_ADD arithOp
    | arithOp T_SUBTRACT arithOp
    | relation
;

relation:
    relation T_LESSTHAN relation
    | relation T_GREATERTHANEQUALTO relation
    | relation T_LESSTHANEQUALTO relation
    | relation T_GREATERTHAN relation
    | relation T_EQUALS relation
    | relation T_NOTEQUALS relation
    | term
;

term:
    term T_MULTIPLY term
    | term T_DIVIDE term
    | factor
;

factor:
    T_LPAREN expression T_RPAREN
    | procedure_call
    | name
    | T_SUBTRACT name
    | number
    | T_SUBTRACT number
    | string
    | T_TRUE
    | T_FALSE
;

name:
    identifier
    | identifier T_LSQBRACKET expression T_RSQBRACKET
;

argument_list:
    expression T_COMMA argument_list
    | expression
;

number:
    T_INTCONST
    | T_FLOATCONST
;

string:
    T_STRINGCONST
;


%%

int yyerror(char *s)
{
    printf("Syntax Error on line %s\n", s);
    return 0;
}

int main()
{
    yyparse();
    return 0;
}