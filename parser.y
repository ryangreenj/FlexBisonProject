/* Parser for EECS 6083 Project Language */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int lineNum;
int yylex();
int yyerror(char *s);
/*
struct nodeStruct {
    char* nodeName;
    struct node* c1;
    struct node* c2;
    struct node* c3;
};

typedef struct nodeStruct node;

node* root;

node* newNode(char* nodeName, node* c1, node* c2, node* c3);
*/
%}

%code requires {
    struct nodeStruct {
        char* nodeName;
        struct nodeStruct* c1;
        struct nodeStruct* c2;
        struct nodeStruct* c3;
    };

    typedef struct nodeStruct node;
    
    node* root;

    node* newNode(char* nodeName, node* c1, node* c2, node* c3);
}

%union {
    char* strVal;
    int intVal;
    float floatVal;
    node* pNode;
}

%token  T_LPAREN T_RPAREN T_LSQBRACKET T_RSQBRACKET
        T_SEMICOLON T_COLON T_COMMA T_PERIOD
        T_ASSIGN T_AND T_OR
        T_LESSTHAN T_GREATERTHAN T_LESSTHANEQUALTO T_GREATERTHANEQUALTO T_EQUALS T_NOTEQUALS
        T_ADD T_SUBTRACT T_MULTIPLY T_DIVIDE
        T_EOF
        T_PROGRAM T_IS T_BEGIN T_END T_GLOBAL T_PROCEDURE T_VARIABLE T_INTEGER T_FLOAT T_STRING T_BOOL T_IF T_THEN T_ELSE T_FOR T_RETURN T_NOT T_TRUE T_FALSE
%token  <strVal> T_STRINGCONST T_IDENTIFIER
%token  <intVal> T_INTCONST
%token  <floatVal> T_FLOATCONST

%type <pNode> program program_header program_body declarations declaration procedure_declaration procedure_header parameter_list parameter procedure_body variable_declaration type_mark bound statements statement procedure_call assignment_statement destination if_statement loop_statement return_statement identifier expression arithOp relation term factor name argument_list number string

%%

program:
    program_header program_body T_PERIOD { root = $$ = newNode("PROGRAM", $1, $2, NULL); return 0; }
;

program_header:
    T_PROGRAM identifier T_IS { $$ = newNode("PROGRAM_HEADER", $2, NULL, NULL); }
;

program_body:
    declarations T_BEGIN statements T_END T_PROGRAM { $$ = newNode("PROGRAM_BODY", $1, $3, NULL); }
;

declarations:
    { $$ = NULL; } | declaration T_SEMICOLON declarations { $$ = newNode("DECLARATIONS", $1, $3, NULL); }
;

declaration:
    T_GLOBAL procedure_declaration { $$ = newNode("DECLARATION", $2, NULL, NULL); }
    | T_GLOBAL variable_declaration { $$ = newNode("DECLARATION", $2, NULL, NULL); }
    | procedure_declaration { $$ = newNode("DECLARATION", $1, NULL, NULL); }
    | variable_declaration { $$ = newNode("DECLARATION", $1, NULL, NULL); }
;

procedure_declaration:
    procedure_header procedure_body { $$ = newNode("PROCEDURE_DECLARATION", $1, $2, NULL); }
;

procedure_header:
    T_PROCEDURE identifier T_COLON type_mark T_LPAREN T_RPAREN { $$ = newNode("PROCEDURE_HEADER", $2, $4, NULL); }
    | T_PROCEDURE identifier T_COLON type_mark T_LPAREN parameter_list T_RPAREN { $$ = newNode("PROCEDURE_HEADER", $2, $4, $6); }
;

parameter_list:
    parameter T_COMMA parameter_list { $$ = newNode("PARAMETER_LIST", $1, $3, NULL); }
    | parameter { $$ = newNode("PARAMETER_LIST", $1, NULL, NULL); }
;

parameter:
    variable_declaration { $$ = newNode("PARAMETER", $1, NULL, NULL); }
;

procedure_body:
    declarations T_BEGIN statements T_END T_PROCEDURE { $$ = newNode("PROCEDURE_BODY", $1, $3, NULL); }
;

variable_declaration:
    T_VARIABLE identifier T_COLON type_mark { $$ = newNode("VARIABLE_DECLARATION", $2, $4, NULL); }
    | T_VARIABLE identifier T_COLON type_mark T_LSQBRACKET bound T_RSQBRACKET { $$ = newNode("VARIABLE_DECLARATION", $2, $4, $6); }
;

type_mark:
    T_INTEGER  { $$ = newNode("TYPE_MARK", NULL, NULL, NULL); }
    | T_FLOAT  { $$ = newNode("TYPE_MARK", NULL, NULL, NULL); }
    | T_STRING  { $$ = newNode("TYPE_MARK", NULL, NULL, NULL); }
    | T_BOOL  { $$ = newNode("TYPE_MARK", NULL, NULL, NULL); }
;

bound:
    number  { $$ = newNode("BOUND", $1, NULL, NULL); }
;

statements:
    { $$ = NULL; } | statement T_SEMICOLON statements  { $$ = newNode("STATEMENTS", $1, $3, NULL); }
;

statement:
    assignment_statement  { $$ = newNode("STATEMENT", $1, NULL, NULL); }
    | if_statement  { $$ = newNode("STATEMENT", $1, NULL, NULL); }
    | loop_statement  { $$ = newNode("STATEMENT", $1, NULL, NULL); }
    | return_statement  { $$ = newNode("STATEMENT", $1, NULL, NULL); }
;

procedure_call:
    identifier T_LPAREN argument_list T_RPAREN { $$ = newNode("PROCEDURE_CALL", $1, $3, NULL); }
;

assignment_statement:
    destination T_ASSIGN expression { $$ = newNode("ASSIGNMENT_STATEMENT", $1, $3, NULL); }
;

destination:
    identifier { $$ = newNode("DESTINATION", $1, NULL, NULL); }
    | identifier T_LSQBRACKET expression T_RSQBRACKET { $$ = newNode("DESTINATION", $1, $3, NULL); }
;

if_statement:
    T_IF T_LPAREN expression T_RPAREN T_THEN statements T_END T_IF { $$ = newNode("IF_STATEMENT", $3, $6, NULL); }
    | T_IF T_LPAREN expression T_RPAREN T_THEN statements T_ELSE statements T_END T_IF { $$ = newNode("IF_STATEMENT", $3, $6, $8); }
;

loop_statement:
    T_FOR T_LPAREN assignment_statement T_SEMICOLON expression T_RPAREN statements T_END T_FOR { $$ = newNode("LOOP_STATEMENT", $3, $5, $7); }
;

return_statement:
    T_RETURN expression  { $$ = newNode("RETURN_STATEMENT", $2, NULL, NULL); }
;

identifier:
    T_IDENTIFIER { $$ = newNode("IDENTIFIER", NULL, NULL, NULL); }
;

expression:
    expression T_AND arithOp { $$ = newNode("EXPRESSION", $1, $3, NULL); }
    | expression T_OR arithOp { $$ = newNode("EXPRESSION", $1, $3, NULL); }
    | arithOp { $$ = newNode("EXPRESSION", $1, NULL, NULL); }
    | T_NOT arithOp { $$ = newNode("EXPRESSION", $2, NULL, NULL); }
;

arithOp:
    arithOp T_ADD relation { $$ = newNode("ARITHOP", $1, $3, NULL); }
    | arithOp T_SUBTRACT relation { $$ = newNode("ARITHOP", $1, $3, NULL); }
    | relation { $$ = newNode("ARITHOP", $1, NULL, NULL); }
;

relation:
    relation T_LESSTHAN term { $$ = newNode("RELATION", $1, $3, NULL); }
    | relation T_GREATERTHANEQUALTO term { $$ = newNode("RELATION", $1, $3, NULL); }
    | relation T_LESSTHANEQUALTO term { $$ = newNode("RELATION", $1, $3, NULL); }
    | relation T_GREATERTHAN term { $$ = newNode("RELATION", $1, $3, NULL); }
    | relation T_EQUALS term { $$ = newNode("RELATION", $1, $3, NULL); }
    | relation T_NOTEQUALS term { $$ = newNode("RELATION", $1, $3, NULL); }
    | term { $$ = newNode("RELATION", $1, NULL, NULL); }
;

term:
    term T_MULTIPLY factor { $$ = newNode("TERM", $1, $3, NULL); }
    | term T_DIVIDE factor { $$ = newNode("TERM", $1, $3, NULL); }
    | factor { $$ = newNode("TERM", $1, NULL, NULL); }
;

factor:
    T_LPAREN expression T_RPAREN { $$ = newNode("FACTOR", $2, NULL, NULL); }
    | procedure_call { $$ = newNode("FACTOR", $1, NULL, NULL); }
    | name { $$ = newNode("FACTOR", $1, NULL, NULL); }
    | T_SUBTRACT name { $$ = newNode("FACTOR", $2, NULL, NULL); }
    | number { $$ = newNode("FACTOR", $1, NULL, NULL); }
    | T_SUBTRACT number { $$ = newNode("FACTOR", $2, NULL, NULL); }
    | string { $$ = newNode("FACTOR", $1, NULL, NULL); }
    | T_TRUE { $$ = newNode("FACTOR", NULL, NULL, NULL); }
    | T_FALSE { $$ = newNode("FACTOR", NULL, NULL, NULL); }
;

name:
    identifier { $$ = newNode("NAME", $1, NULL, NULL); }
    | identifier T_LSQBRACKET expression T_RSQBRACKET { $$ = newNode("NAME", $1, $3, NULL); }
;

argument_list:
    expression T_COMMA argument_list { $$ = newNode("ARGUMENT_LIST", $1, $3, NULL); }
    | expression { $$ = newNode("ARGUMENT_LIST", $1, NULL, NULL); }
;

number:
    T_INTCONST { $$ = newNode("NUMBER", NULL, NULL, NULL); }
    | T_FLOATCONST { $$ = newNode("NUMBER", NULL, NULL, NULL); }
;

string:
    T_STRINGCONST { $$ = newNode("STRING", NULL, NULL, NULL); }
;


%%

int yyerror(char *s)
{
    printf("Syntax Error on line %d\n", lineNum);
    return 0;
}

node* newNode(char* nodeName, node* c1, node* c2, node* c3)
{
    node* n = malloc(sizeof(node));
    n->nodeName = nodeName;
    n->c1 = c1;
    n->c2 = c2;
    n->c3 = c3;
    return n;
}

void printTree(node* n, int layers)
{
    for (int i = 0; i < layers; ++i)
    {
        printf("  ");
    }
    printf("%s\n", n->nodeName);
    
    
    if (n->c1) printTree(n->c1, layers + 1);
    if (n->c2) printTree(n->c2, layers + 1);
    if (n->c3) printTree(n->c3, layers + 1);
}

int main()
{
    yyparse();
    
    printTree(root, 0);
    
    return 0;
}