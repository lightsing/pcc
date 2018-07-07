%{
#include "y.tab.h"
#include "define.h"
#include <string.h>

struct indent_stack indent_head = {};

extern int yylval;

int dedent = 0;
#define rescan(yytext) do { \
    char *yycopy = strdup( yytext );    \
    for (int i = 0; i < strlen(yycopy); ++i )   \
        unput( yycopy[i] ); \
    yy_set_bol(1);  \
} while (/*CONSTCOND*/0)


#define POP_DEDENT() {  \
    --dedent;   \
    struct indent_entry *npop = SLIST_FIRST(&indent_head);  \
    SLIST_REMOVE_HEAD(&indent_head, entries);   \
    free(npop); \
    if(dedent > 0) rescan(yytext); /* there is anyother dedent */ \
    return DEDENT;  \
} while (/*CONSTCOND*/0)
%}

%%
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

^(" "{4}|\t)+  {
        if (SLIST_EMPTY(&indent_head)) {
            /* initialize the stack, it SHOULD NOT be empty */
            struct indent_entry *zero_indent = (struct indent_entry*)malloc(sizeof(struct indent_entry));
            zero_indent->level = 0;
            SLIST_INSERT_HEAD(&indent_head, zero_indent, entries);
        }
        if(dedent > 0) {
            POP_DEDENT();
        }
        int level = strlen(yytext)/4;
        struct indent_entry *n = SLIST_FIRST(&indent_head);
        if (level > n->level) {
            // INDENT occurs
            struct indent_entry *new_indent = (struct indent_entry*)malloc(sizeof(struct indent_entry));
            new_indent->level = level;
            SLIST_INSERT_HEAD(&indent_head, new_indent, entries);
            return INDENT;
        } else if (level < n->level) {
            // possible DEDENT occurs
            struct indent_entry *npop = indent_head.slh_first;
            dedent = 0;
            // INDENT level must match an exist indent level
            for (; npop != NULL && level <= npop->level; npop = npop->entries.sle_next)
                ++dedent;
            --dedent;
            POP_DEDENT();
        }
    }

[0-9]+          { yylval = atoi(yytext); return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]*    { return IDENTIFIER; }
[ \t] {};   /* ignore any space */
.	{ return yytext[0]; }
<<EOF>> {
        struct indent_entry *n = SLIST_FIRST(&indent_head);
        if (n-> level != 0) {
            SLIST_REMOVE_HEAD(&indent_head, entries);
            free(n);
            return DEDENT;
        } else {
            return EOF;
        }
    }
%%
