%{
#include "y.tab.h"

extern int yylval;
%}

%%
False       { return FALSE; }
None        { return NONE; }
True        { return TRUE; }
and         { return AND; }
as          { return AS; }
assert      { return ASSERT; }
break       { return BREAK; }
class       { return CLASS; }
continue    { return CONTINUE; }
def         { return DEF; }
elif        { return ELIF; }
else        { return ELSE; }
except      { return EXCEPT; }
for         { return FOR; }
from        { return FROM; }
if          { return IF; }
import      { return IMPORT; }
in          { return IN; }
not         { return NOT; }
or          { return OR; }
pass        { return PASS; }
raise       { return RAISE; }
return      { return RETURN; }
try         { return TRY; }
while       { return WHILE; }

\n(" "{4}|\t)+  { return INDENT; }

[0-9]+          { yylval = atoi(yytext); return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]*    { return IDENTIFIER; }
[ \t\n] {};   /* ignore any space */
.	{ return yytext[0]; }
%%
