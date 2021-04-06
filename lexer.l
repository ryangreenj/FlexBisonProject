/* Scanner for EECS 6083 Project Language */
%{
#include <stdio.h>
#include "parser.tab.h"

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

(?i:program)    { return T_PROGRAM; }
(?i:is)         { return T_IS; }
(?i:begin)      { return T_BEGIN; }
(?i:end)        { return T_END; }
(?i:global)     { return T_GLOBAL; }
(?i:procedure)  { return T_PROCEDURE; }
(?i:variable)   { return T_VARIABLE; }
(?i:integer)    { return T_INTEGER; }
(?i:float)      { return T_FLOAT; }
(?i:string)     { return T_STRING; }
(?i:bool)       { return T_BOOL; }
(?i:if)         { return T_IF; }
(?i:then)       { return T_THEN; }
(?i:else)       { return T_ELSE; }
(?i:for)        { return T_FOR; }
(?i:return)     { return T_RETURN; }
(?i:not)        { return T_NOT; }
(?i:true)       { return T_TRUE; }
(?i:false)      { return T_FALSE; }

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
[ \t\r] {}
[\0]    { return T_EOF; }

.   {
        printf("Invalid character '%c' at %d\n", yytext[0], lineNum);
    }

%%