%{
#include "y.tab.h"

#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>
/*MULTI_TOKEN RELATED CODE
  a dirty hack to yylex() for return multi DEDENT token
  ref: https://stackoverflow.com/questions/42434603/how-can-flex-return-multiple-terminals-at-one-time
  ref: https://docs.python.org/3/reference/lexical_analysis.html#indentation
*/
LIST_HEAD(token_queue, entry);
struct entry {
    int token;
    LIST_ENTRY(entry) entries;
};
struct token_queue head = LIST_HEAD_INITIALIZER(head);

int push_token(int token) {
    struct entry *new_token = malloc(sizeof(struct entry));
    new_token->token = token;
    LIST_INSERT_HEAD(&head, new_token, entries);
    return token;
}
/*--MULTI_TOKEN RELATED CODE--*/
/*INDENT RELATED CODE*/
SLIST_HEAD(indent_stack, entry);
struct entry {
    int level;
    SLIST_ENTRY(entry) entries;
};

struct indent_stack head = SLIST_HEAD_INITIALIZER(head);
SLIST_INIT(&head);

#define NEW_INDENT(level) do {  \
    if(level == SLIST_FIRST(&head)->level) {
    }   \
} while (/*CONSTCOND*/0)
/*--INDENT RELATED CODE--*/
extern int yylval;
%}

%%
    /*MULTI_TOKEN RELATED CODE*/
    if (!LIST_EMPTY(&head)) {
        struct entry *n = LIST_FIRST(&head);
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

\n(" "{4}|\t)+  { return INDENT; }

[0-9]+          { yylval = atoi(yytext); return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]*    { return IDENTIFIER; }
[ \t\n] {};   /* ignore any space */
.	{ return yytext[0]; }
%%
