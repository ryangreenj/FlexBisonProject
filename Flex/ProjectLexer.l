/* Standalone Scanner for EECS 6083 Project Language */
%{
#include <stdio.h>

int lineNum = 1;
int nestLevel = 0;
%}

%x N_COMMENT

%%

"/*"            { BEGIN(N_COMMENT); }
<N_COMMENT>{
    "/*"        { ++nestLevel; }
    "*"+"/"     { if (nestLevel > 0) --nestLevel;
                  else BEGIN(INITIAL); }
    "*"+        {}
    [^/*\n]+    {}  /* */
    [/]         {}
    \n
}

"//".*          {} // . will not match a newline

(?i:program)    { printf("PROGRAM_KW "); }
(?i:is)         { printf("IS_KW "); }
(?i:begin)      { printf("BEGIN_KW "); }
(?i:end)        { printf("END_KW "); }
(?i:global)     { printf("GLOBAL_KW "); }
(?i:procedure)  { printf("PROCEDURE_KW "); }
(?i:variable)   { printf("VARIABLE_KW "); }
(?i:integer)    { printf("INTEGER_KW "); }
(?i:float)      { printf("FLOAT_KW "); }
(?i:string)     { printf("STRING_KW "); }
(?i:bool)       { printf("BOOL_KW "); }
(?i:if)         { printf("IF_KW "); }
(?i:then)       { printf("THEN_KW "); }
(?i:else)       { printf("ELSE_KW "); }
(?i:for)        { printf("FOR_KW "); }
(?i:return)     { printf("RETURN_KW "); }
(?i:not)        { printf("NOT_KW "); }
(?i:true)       { printf("TRUE_KW "); }
(?i:false)      { printf("FALSE_KW "); }

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
[ \t\r]   {}
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