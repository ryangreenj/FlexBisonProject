%{
int lineCount = 0;
%}

digit       [0-9]
letter      [a-zA-Z]

%%

[+\-*/=]                        { printf("OPERATOR found: %s\n", yytext); }
{letter}({letter}|{digit})*     { printf("INDENTIFIER found: %s\n", yytext); }
{digit}+                        { printf("NUMBER found: %s\n", yytext); }

[ \t\r]     /* Ignore whitespace */
[\n]        { ++lineCount; }

.           { printf("That symbol is not recognized: %s\n", yytext);
            return 0; }

%%

int yywrap() {}

int main() {
    yylex();
    printf("Valid input contained %d lines.\n", lineCount);
}