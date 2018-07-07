#ifndef PCC_DEFINE
#define PCC_DEFINE
#include <stdlib.h>
#include <sys/queue.h>

#include "y.tab.h"

extern void yyerror();


/*INDENT RELATED CODE*/
SLIST_HEAD(indent_stack, indent_entry);
struct indent_entry {
    int level;
    SLIST_ENTRY(indent_entry) entries;
};
extern struct indent_stack indent_head;

#endif
