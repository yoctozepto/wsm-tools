#include "events.h"

void eventLibraryDefinitionReferenced(const string &, unsigned long) {}

void eventLibraryTheoremReferenced(const string &, unsigned long) {}

void eventLibrarySchemeReferenced(const string &, unsigned long) {}

extern int yyparse(void);

int parse_wsm(void) {
    return yyparse();
}
