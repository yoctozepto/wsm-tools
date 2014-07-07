#include <iostream>
#include <unordered_set>
#include <string>
#include <algorithm>

using std::unordered_set;
using std::string;

extern unordered_set<string> article_names;

unordered_set<string> articles_unused;

void markArticleAsUsed(char* articleName) {
    articles_unused.erase(string(articleName));
}

void eventLibraryDefinitionReferenced(char* articleName, unsigned long) {
    markArticleAsUsed(articleName);
}

void eventLibraryTheoremReferenced(char* articleName, unsigned long) {
    markArticleAsUsed(articleName);
}

void eventLibrarySchemeReferenced(char* articleName, unsigned long) {
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
