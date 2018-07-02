%{
#include "pcc.h"

#define Token(t)    printf("Token: %s\n", yytext);
%}

%%
False       { Token(TOKEN_False); }
None        { Token(TOKEN_None); }
True        { Token(TOKEN_True); }
and         { Token(TOKEN_and); }
as          { Token(TOKEN_as); }
assert      { Token(TOKEN_assert); }
break       { Token(TOKEN_break); }
class       { Token(TOKEN_class); }
continue    { Token(TOKEN_continue); }
def         { Token(TOKEN_def); }
elif        { Token(TOKEN_elif); }
else        { Token(TOKEN_else); }
except      { Token(TOKEN_except); }
for         { Token(TOKEN_for); }
from        { Token(TOKEN_from); }
if          { Token(TOKEN_if); }
import      { Token(TOKEN_import); }
in          { Token(TOKEN_in); }
not         { Token(TOKEN_not); }
or          { Token(TOKEN_or); }
pass        { Token(TOKEN_pass); }
raise       { Token(TOKEN_raise); }
return      { Token(TOKEN_return); }
try         { Token(TOKEN_try); }
while       { Token(TOKEN_while); }

\n(" "{4}|\t)+        { Token(TOKEN_INDENT); }

[a-zA-Z_][a-zA-Z0-9_]*    { printf("Identifier: %s\n", yytext); }
" "|\t|\n {};
. ECHO;

%%

int main() {
    yylex();
    return 0;
}