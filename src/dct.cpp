#include <cstdio>
#include <unordered_set>
#include <string>

using std::unordered_set;
using std::string;

unordered_set<string> mode_symbols;
unordered_set<string> attribute_symbols;
unordered_set<string> structure_symbols;
unordered_set<string> selector_symbols;
unordered_set<string> predicate_symbols;
unordered_set<string> functor_symbols;
unordered_set<string> left_functor_bracket_symbols;
unordered_set<string> right_functor_bracket_symbols;
unordered_set<string> article_names;

bool contains(unordered_set<string>& l, char* s) {
    return l.find(string(s)) != l.end();
}

void register_mode_symbol(char* s) {
    mode_symbols.emplace(s);
}

bool is_mode_symbol(char* s) {
    return contains(mode_symbols, s);
}

void register_attribute_symbol(char* s) {
    attribute_symbols.emplace(s);
}

bool is_attribute_symbol(char* s) {
    return contains(attribute_symbols, s);
}

void register_structure_symbol(char* s) {
    structure_symbols.emplace(s);
}

bool is_structure_symbol(char* s) {
    return contains(structure_symbols, s);
}

void register_selector_symbol(char* s) {
    selector_symbols.emplace(s);
}

bool is_selector_symbol(char* s) {
    return contains(selector_symbols, s);
}

void register_predicate_symbol(char* s) {
    predicate_symbols.emplace(s);
}

bool is_predicate_symbol(char* s) {
    return contains(predicate_symbols, s);
}

void register_functor_symbol(char* s) {
    functor_symbols.emplace(s);
}

bool is_functor_symbol(char* s) {
    return contains(functor_symbols, s);
}

void register_left_functor_bracket_symbol(char* s) {
    left_functor_bracket_symbols.emplace(s);
}

bool is_left_functor_bracket_symbol(char* s) {
    return contains(left_functor_bracket_symbols, s);
}

void register_right_functor_bracket_symbol(char* s) {
    right_functor_bracket_symbols.emplace(s);
}

bool is_right_functor_bracket_symbol(char* s) {
    return contains(right_functor_bracket_symbols, s);
}

void register_article_name(char* s) {
    article_names.emplace(s);
}

bool is_article_name(char* s) {
    return contains(article_names, s);
}

bool is_numeral(char* s) {
    size_t i = 0;

    while (s[i]) {
        if (!isdigit(s[i])) {
            return false;
        }

        i++;
    }

    if (s[0] == '0' && i > 1) {
        return false;
    }

    return true;
}

int parse_dct(FILE* f) {
    char c;
    char s[256];

    while (fscanf(f, "%c%*d %255s\n", &c, s) == 2) {
        switch (c) {
            case 'M':
                register_mode_symbol(s);
                break;
            case 'V':
                register_attribute_symbol(s);
                break;
            case 'G':
                register_structure_symbol(s);
                break;
            case 'U':
                register_selector_symbol(s);
                break;
            case 'R':
                register_predicate_symbol(s);
                break;
            case 'O':
                register_functor_symbol(s);
                break;
            case 'K':
                register_left_functor_bracket_symbol(s);
                break;
            case 'L':
                register_right_functor_bracket_symbol(s);
                break;
            case 'A':
                register_article_name(s);
                break;
        }
    }

    return fgetc(f) != EOF;
}
