void eventLibraryDefinitionReferenced(char*, unsigned long) {}

void eventLibraryTheoremReferenced(char*, unsigned long) {}

void eventLibrarySchemeReferenced(char*, unsigned long) {}

extern int yyparse(void);

int parse_wsm(void) {
    return yyparse();
}
