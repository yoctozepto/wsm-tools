%{
#include "dct.h"
#include "wsm.tab.h"
%}

%option noyywrap nounput noinput nodefault yylineno

%%
[[:space:]] ; // ignore whitespace

"begin" { return BEGIN_; }
"end" { return END; }
"reserve" { return RESERVE; }
"for" { return FOR; }
"that" { return THAT; }
"with" { return WITH; }
"and" { return AND; }
"synonym" { return SYNONYM; }
"antonym" { return ANTONYM; }
"as" { return AS; }
"assume" { return ASSUME; }
"asymmetry" { return ASYMMETRY; }
"@proof" { return ATPROOF; }
"proof" { return PROOF; }
"attr" { return ATTR; }
"by" { return BY; }
"canceled" { return CANCELED; }
"case" { return CASE; }
"per" { return PER; }
"cases" { return CASES; }
"cluster" { return CLUSTER; }
"coherence" { return COHERENCE; }
"commutativity" { return COMMUTATIVITY; }
"compatibility" { return COMPATIBILITY; }
"connectedness" { return CONNECTEDNESS; }
"consider" { return CONSIDER; }
"consistency" { return CONSISTENCY; }
"correctness" { return CORRECTNESS; }
"def" { return DEF; }
"deffunc" { return DEFFUNC; }
"definition" { return DEFINITION; }
"defpred" { return DEFPRED; }
"equals" { return EQUALS; }
"existence" { return EXISTENCE; }
"from" { return FROM; }
"func" { return FUNC; }
"given" { return GIVEN; }
"hence" { return HENCE; }
"hereby" { return HEREBY; }
"idempotence" { return IDEMPOTENCE; }
"identify" { return IDENTIFY; }
"if" { return IF; }
"involutiveness" { return INVOLUTIVENESS; }
"irreflexivity" { return IRREFLEXIVITY; }
"is" { return IS; }
"let" { return LET; }
"means" { return MEANS; }
"mode" { return MODE; }
"non" { return NON; }
"notation" { return NOTATION; }
"now" { return NOW; }
"of" { return OF; }
"otherwise" { return OTHERWISE; }
"over" { return OVER; }
"pred" { return PRED; }
"projectivity" { return PROJECTIVITY; }
"provided" { return PROVIDED; }
"reconsider" { return RECONSIDER; }
"redefine" { return REDEFINE; }
"reduce" { return REDUCE; }
"reducibility" { return REDUCIBILITY; }
"reflexivity" { return REFLEXIVITY; }
"registration" { return REGISTRATION; }
"sch" { return SCH; }
"scheme" { return SCHEME; }
"set" { return SET; }
"sethood" { return SETHOOD; }
"struct" { return STRUCT; }
"such" { return SUCH; }
"suppose" { return SUPPOSE; }
"symmetry" { return SYMMETRY; }
"take" { return TAKE; }
"then" { return THEN; }
"theorem" { return THEOREM; }
"thus" { return THUS; }
"to" { return TO; }
"uniqueness" { return UNIQUENESS; }
"when" { return WHEN; }

"not" { return NOT; }
"or" { return OR; }
"implies" { return IMPLIES; }
"iff" { return IFF; }
"contradiction" { return CONTRADICTION; }
"thesis" { return THESIS; }
"all" { return ALL; }
"be" { return BE; }
"being" { return BEING; }
"do" { return DO; }
"does" { return DOES; }
"ex" { return EX; }
"holds" { return HOLDS; }
"st" { return ST; }
"the" { return THE; }
"where" { return WHERE; }
"qua" { return QUA; }
"it" { return IT; }
"are" { return ARE; }

"," { return COMMA; }
":" { return COLON; }
";" { return SEMICOLON; }
"=" { return EQ; }
".=" { return DOTEQ; }
"{" { return OPEN_BRACE; }
"}" { return CLOSE_BRACE; }
"[" { return OPEN_BRACKET; }
"]" { return CLOSE_BRACKET; }
"(" { return OPEN_PAREN; }
")" { return CLOSE_PAREN; }
"(#" { return OPEN_PAREN_HASH; }
"#)" { return HASH_CLOSE_PAREN; }
"->" { return RARROW; }

"&" { return AMPERSAND; }
"..." { return DOTDOTDOT; }

"$1" { return DOLLAR1; }
"$2" { return DOLLAR2; }
"$3" { return DOLLAR3; }
"$4" { return DOLLAR4; }
"$5" { return DOLLAR5; }
"$6" { return DOLLAR6; }
"$7" { return DOLLAR7; }
"$8" { return DOLLAR8; }
"$9" { return DOLLAR9; }
"$10" { return DOLLAR10; }

^::.*$ ; // ignore pragmas

[[:^space:]]+ {
    yylval.sval = strdup(yytext);

    if (is_mode_symbol(yylval.sval)) {
        return MODE_SYMBOL;
    }

    if (is_attribute_symbol(yylval.sval)) {
        return ATTRIBUTE_SYMBOL;
    }

    if (is_structure_symbol(yylval.sval)) {
        return STRUCTURE_SYMBOL;
    }

    if (is_selector_symbol(yylval.sval)) {
        return SELECTOR_SYMBOL;
    }

    if (is_predicate_symbol(yylval.sval)) {
        return PREDICATE_SYMBOL;
    }

    if (is_functor_symbol(yylval.sval)) {
        return FUNCTOR_SYMBOL;
    }

    if (is_left_functor_bracket_symbol(yylval.sval)) {
        return LEFT_FUNCTOR_BRACKET_SYMBOL;
    }

    if (is_right_functor_bracket_symbol(yylval.sval)) {
        return RIGHT_FUNCTOR_BRACKET_SYMBOL;
    }

    if (is_article_name(yylval.sval)) {
        return ARTICLE_NAME;
    }

    if (is_numeral(yylval.sval)) {
        free(yylval.sval);
        yylval.ival = strtoul(yytext, NULL, 10);
        return NUMERAL;
    }

    return IDENTIFIER;
}
%%
