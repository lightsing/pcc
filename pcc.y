%{
#include <stdio.h>

int yylex();
void yyerror(const char *s);
%}
/* keywords */
%token FALSE NONE TRUE AND AS ASSERT BREAK CLASS CONTINUE
%token DEF ELIF ELSE EXCEPT FOR FROM IF IMPORT IN
%token NOT OR PASS RAISE RETURN TRY WHILE
/* non-keywords token */
%token INDENT
/* constants */
%token NUMBER
%token IDENTIFIER
%%
statement: IDENTIFIER '=' expression
    |   expression  { printf("= %d\n", $1); }
    ;

expression: expression '+' NUMBER    { $$ = $1 + $3; }
    |    expression '-' NUMBER    { $$ = $1 - $3; }
    |    NUMBER            { $$ = $1; }
    ;
%%