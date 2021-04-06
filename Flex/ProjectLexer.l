/* Scanner for EECS 6083 Project Language */
%{
#include <stdio.h>

int lineNum = 1;
%}


%%

"program"    { printf("PROGRAM_KW "); }
"is"         { printf("IS_KW "); }
"begin"      { printf("BEGIN_KW "); }
"end"        { printf("END_KW "); }
"global"     { printf("GLOBAL_KW "); }
"procedure"  { printf("PROCEDURE_KW "); }
"variable"   { printf("VARIABLE_KW "); }
"integer"    { printf("INTEGER_KW "); }
"float"      { printf("FLOAT_KW "); }
"string"     { printf("STRING_KW "); }
"bool"       { printf("BOOL_KW "); }
"if"         { printf("IF_KW "); }
"then"       { printf("THEN_KW "); }
"else"       { printf("ELSE_KW "); }
"for"        { printf("FOR_KW "); }
"return"     { printf("RETURN_KW "); }
"not"        { printf("NOT_KW "); }
"true"       { printf("TRUE_KW "); }
"false"      { printf("FALSE_KW "); }

"("             { printf("LPAREN "); }
")"             { printf("RPAREN "); }
"["             { printf("LSQBRACKET "); }
"]"             { printf("RSQBRACKET "); }
"{"             { printf("LCURBRACKET "); }
"}"             { printf("RCURBRACKET "); }

";"             { printf("SEMICOLON "); }
":"             { printf("COLON "); }
","             { printf("COMMA "); }
"."             { printf("PERIOD "); }

":="            { printf("ASSIGN "); }
"&"             { printf("AND "); }
"|"             { printf("OR "); }

"<"             { printf("LESSTHAN "); }
">"             { printf("GREATERTHAN "); }
"<="            { printf("LESSTHANEQUALTO "); }
">="            { printf("GREATERTHANEQUALTO "); }
"=="            { printf("EQUALS "); }
"!="            { printf("NOTEQUALS "); }

"+"             { printf("ADD "); }
"-"             { printf("SUBTRACT "); }
"*"             { printf("MULTIPLY "); }
"/"             { printf("DIVIDE "); }

[a-zA-Z][a-zA-Z0-9_]*       { printf("IDENTIFIER "); }

[0-9][0-9]*                 { printf("INTCONST "); }
[0-9][0-9]*[.[0-9]*]        { printf("FLOATCONST "); }
[\"[^"]*\"]                 { printf("STRINGCONST "); }

[\n]    {lineNum++; printf("\n"); }
[ \t\r] {}
[\0]    { printf("EOF "); }

.   {
        printf("Invalid character '%c' at %d\n", yytext[0], lineNum);
    }

%%

/* User-defined code */

int yywrap() {}
int main(int argc, char **argv)
{
    FILE *file = fopen(argv[1], "r");
    yyin = file;
    
    yylex();
    printf("\nFile contained %d lines.\n", lineNum);
    return 0;
}