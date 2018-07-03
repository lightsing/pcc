%{
#include "y.tab.h"
#include "define.h"
#include <string.h>

struct token_queue token_head = {};
struct indent_stack indent_head = {};

extern int yylval;
%}

%%
    /*MULTI_TOKEN RELATED CODE*/
    if (!LIST_EMPTY(&token_head)) {
        struct token_entry *n = LIST_FIRST(&token_head); 
        int token = n->token;
        LIST_REMOVE(n, entries);
        free(n);
        return token;
    }
    /*--MULTI_TOKEN RELATED CODE--*/
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

\n(" "{4})+  { new_indent(strlen(yytext)/4); }

\n\t+ { new_indent(strlen(yytext)); }

[0-9]+          { yylval = atoi(yytext); return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]*    { return IDENTIFIER; }
[ \t\n] {};   /* ignore any space */
.	{ return yytext[0]; }
%%
