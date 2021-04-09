/* Simple Calculator Scanner for EECS 6083 Flex/Bison Presentation */
%{
#include <stdio.h>
#include "Calc.tab.h"

int lineNum = 1;
%}

%%

"+"    { return T_ADD; }
"-"    { return T_SUBTRACT; }
"*"    { return T_MULTIPLY; }
"/"    { return T_DIVIDE; }
";"    { return T_SEMICOLON; }

[0-9]+    { yylval.intVal = atoi(yytext); return T_NUM; }

[\n]    { ++lineNum; }
[ \t\r] {}

.   {
        printf("Invalid character '%c' at %d\n", yytext[0], lineNum);
    }

%%