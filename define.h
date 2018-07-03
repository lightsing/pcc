#ifndef PCC_DEFINE
#define PCC_DEFINE
#include <stdlib.h>
#include <sys/queue.h>

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
int push_token(struct token_queue *head, int token) {
    struct token_entry *new_token = (struct token_entry*)malloc(sizeof(struct token_entry));
    new_token->token = token;
    LIST_INSERT_HEAD(head, new_token, entries);
    return token;
}

/*INDENT RELATED CODE*/
SLIST_HEAD(indent_stack, indent_entry);
struct indent_entry {
    int level;
    SLIST_ENTRY(indent_entry) entries;
};


#endif
