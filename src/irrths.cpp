#include <iostream>
#include <unordered_set>
#include <string>
#include <algorithm>

using std::unordered_set;
using std::string;

#include "events.h"

extern unordered_set<string> article_names;

static unordered_set<string> articles_unused;

void markArticleAsUsed(const string &articleName) {
    articles_unused.erase(articleName);
}

void eventLibraryDefinitionReferenced(const string &articleName, unsigned long) {
    markArticleAsUsed(articleName);
}

void eventLibraryTheoremReferenced(const string &articleName, unsigned long) {
    markArticleAsUsed(articleName);
}

void eventLibrarySchemeReferenced(const string &articleName, unsigned long) {
    markArticleAsUsed(articleName);
}

extern int yyparse(void);

int parse_wsm(void) {
    articles_unused = article_names;

    int result = yyparse();

    for_each(articles_unused.cbegin(), articles_unused.cend(), [](const string &s) {
        std::cout << s << "\n";
    });

    return result;
}
