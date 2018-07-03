#ifndef PCC_DEFINE
#define PCC_DEFINE
#include <stdlib.h>
#include <sys/queue.h>

#include "y.tab.h"

extern void yyerror();

/*MULTI_TOKEN RELATED CODE
  a dirty hack to yylex() for return multi DEDENT token
  ref: https://stackoverflow.com/questions/42434603/how-can-flex-return-multiple-terminals-at-one-time
  ref: https://docs.python.org/3/reference/lexical_analysis.html#indentation
*/
LIST_HEAD(token_queue, token_entry);
struct token_entry {
    int token;
    LIST_ENTRY(token_entry) entries;
};
extern struct token_queue token_head;
int push_token(int token) {
    struct token_entry *new_token = (struct token_entry*)malloc(sizeof(struct token_entry));
    new_token->token = token;
    LIST_INSERT_HEAD(&token_head, new_token, entries);
    return token;
}

/*INDENT RELATED CODE*/
SLIST_HEAD(indent_stack, indent_entry);
struct indent_entry {
    int level;
    SLIST_ENTRY(indent_entry) entries;
};
extern struct indent_stack indent_head;
int new_indent(int level) {
    if (SLIST_EMPTY(&indent_head)) {
        /* initialize the stack, it SHOULD NOT be empty */
        struct indent_entry *zero_indent = (struct indent_entry*)malloc(sizeof(struct indent_entry));
        zero_indent->level = 0;
        SLIST_INSERT_HEAD(&indent_head, zero_indent, entries);
    }
    struct indent_entry *n = SLIST_FIRST(&indent_head);
    if (level == n->level) return 0;

    if (level > n->level) {
        // INDENT occurs
        struct indent_entry *new_indent = (struct indent_entry*)malloc(sizeof(struct indent_entry));
        new_indent->level = level;
        SLIST_INSERT_HEAD(&indent_head, new_indent, entries);
        return INDENT;
    }

    // possible DEDENT occurs
    struct indent_entry *npop = indent_head.slh_first;
    int cnt = 0;
    // INDENT level must match an exist indent level
    for (; npop != NULL && level <= npop->level; npop = npop->entries.sle_next)
        ++cnt;
    if (npop == NULL) {
        yyerror("indent error");
        return 0;
    }
    for (int i = 0; i < cnt; ++i) {
        npop = SLIST_FIRST(&indent_head);
        SLIST_REMOVE_HEAD(&indent_head, entries);
        free(npop);
        push_token(DEDENT);
        return 0;
    }
}

#endif
