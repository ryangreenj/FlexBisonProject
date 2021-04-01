/* Scanner for EECS 6083 Project Language */
%{
#include <stdio.h>
#include "parser.tab.h"

int lineNum = 1;
%}


%%

"program"    { return T_PROGRAM; }
"is"         { return T_IS; }
"begin"      { return T_BEGIN; }
"end"        { return T_END; }
"global"     { return T_GLOBAL; }
"procedure"  { return T_PROCEDURE; }
"variable"   { return T_VARIABLE; }
"integer"    { return T_INTEGER; }
"float"      { return T_FLOAT; }
"string"     { return T_STRING; }
"bool"       { return T_BOOL; }
"if"         { return T_IF; }
"then"       { return T_THEN; }
"else"       { return T_ELSE; }
"for"        { return T_FOR; }
"return"     { return T_RETURN; }
"not"        { return T_NOT; }
"true"       { return T_TRUE; }
"false"      { return T_FALSE; }

"("             { return T_LPAREN; }
")"             { return T_RPAREN; }
"["             { return T_LSQBRACKET; }
"]"             { return T_RSQBRACKET; }
"{"             { return T_LCURBRACKET; }
"}"             { return T_RCURBRACKET; }

";"             { return T_SEMICOLON; }
":"             { return T_COLON; }
","             { return T_COMMA; }
"."             { return T_PERIOD; }

":="            { return T_ASSIGN; }
"&"             { return T_AND; }
"|"             { return T_OR; }

"<"             { return T_LESSTHAN; }
">"             { return T_GREATERTHAN; }
"<="            { return T_LESSTHANEQUALTO; }
">="            { return T_GREATERTHANEQUALTO; }
"=="            { return T_EQUALS; }
"!="            { return T_NOTEQUALS; }

"+"             { return T_ADD; }
"-"             { return T_SUBTRACT; }
"*"             { return T_MULTIPLY; }
"/"             { return T_DIVIDE; }

[a-zA-Z][a-zA-Z0-9_]*       { yylval.strVal = strdup(yytext); return T_IDENTIFIER; }

[0-9][0-9]*                 { yylval.intVal = atoi(yytext); return T_INTCONST; }
[0-9][0-9]*[.[0-9]*]        { yylval.floatVal = atof(yytext); return T_FLOATCONST; }
[\"[^"]*\"]                 { yylval.strVal = strdup(yytext); return T_STRINGCONST; }

[\n]    {lineNum++;}
[" "]   {}
[\t]    {}
[\0]    { return T_EOF; }

.   {
        printf("Invalid character '%c' at %d\n", yytext[0], lineNum);
    }

%%