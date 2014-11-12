%{
#include "wsm.h"
#include "events.h"
void yyerror(const char *s);
extern int yylex(void);
extern int yylineno;
%}

%union
{
    unsigned long ival;
    string *sval;
    StructureType *structureType;
    forward_list<unique_ptr<StructureType>> *structureTypes;
    StructureDefinition *structureDefinition;
}

%define parse.error verbose
%glr-parser

%token <sval> IDENTIFIER
%token <ival> NUMERAL

%token BEGIN_
%token END
%token RESERVE
%token FOR
%token THAT
%token WITH
%token AND
%token SYNONYM
%token ANTONYM
%token AS
%token ASSUME
%token ASYMMETRY
%token ATPROOF
%token PROOF
%token ATTR
%token BY
%token CANCELED
%token CASE
%token PER
%token CASES
%token CLUSTER
%token COHERENCE
%token COMMUTATIVITY
%token COMPATIBILITY
%token CONNECTEDNESS
%token CONSIDER
%token CONSISTENCY
%token CORRECTNESS
%token DEF
%token DEFFUNC
%token DEFINITION
%token DEFPRED
%token EQUALS
%token EXISTENCE
%token FROM
%token FUNC
%token GIVEN
%token HENCE
%token HEREBY
%token IDEMPOTENCE
%token IDENTIFY
%token IF
%token INVOLUTIVENESS
%token IRREFLEXIVITY
%token IS
%token LET
%token MEANS
%token MODE
%token NON
%token NOTATION
%token NOW
%token OF
%token OTHERWISE
%token OVER
%token PRED
%token PROJECTIVITY
%token PROVIDED
%token RECONSIDER
%token REDEFINE
%token REDUCE
%token REDUCIBILITY
%token REFLEXIVITY
%token REGISTRATION
%token SCH
%token SCHEME
%token SET
%token SETHOOD
%token STRUCT
%token SUCH
%token SUPPOSE
%token SYMMETRY
%token TAKE
%token THEN
%token THEOREM
%token THUS
%token TO
%token UNIQUENESS
%token WHEN

%token NOT
%token OR
%token IMPLIES
%token IFF
%token CONTRADICTION
%token THESIS
%token ALL
%token BE
%token BEING
%token DO
%token DOES
%token EX
%token HOLDS
%token ST
%token THE
%token WHERE
%token QUA
%token IT
%token ARE

%token COMMA
%token COLON
%token SEMICOLON
%token EQ
%token DOTEQ
%token OPEN_BRACE
%token CLOSE_BRACE
%token OPEN_BRACKET
%token CLOSE_BRACKET
%token OPEN_PAREN
%token CLOSE_PAREN
%token OPEN_PAREN_HASH
%token HASH_CLOSE_PAREN
%token RARROW

%token AMPERSAND
%token DOTDOTDOT

%token DOLLAR1 "$1"
%token DOLLAR2 "$2"
%token DOLLAR3 "$3"
%token DOLLAR4 "$4"
%token DOLLAR5 "$5"
%token DOLLAR6 "$6"
%token DOLLAR7 "$7"
%token DOLLAR8 "$8"
%token DOLLAR9 "$9"
%token DOLLAR10 "$10"

%token <sval> STRUCTURE_SYMBOL
%token <sval> SELECTOR_SYMBOL
%token <sval> MODE_SYMBOL
%token <sval> FUNCTOR_SYMBOL
%token <sval> PREDICATE_SYMBOL
%token <sval> ATTRIBUTE_SYMBOL
%token <sval> LEFT_FUNCTOR_BRACKET_SYMBOL
%token <sval> RIGHT_FUNCTOR_BRACKET_SYMBOL
%token <sval> ARTICLE_NAME

%type <sval> structure_symbol
%type <structureType> structure_type_expression
%type <structureTypes> ancestors
%type <structureTypes> maybe_ancestors_list
%type <structureDefinition> structure_definition

%%
document:
    sections
    ;

section:
    BEGIN_ maybe_text_items
    ;

sections:
    section
    | section sections
    ;

text_item:
    reservation
    | definitional_item
    | registration_item
    | notation_item
    | theorem
    | scheme_item
    | auxiliary_item
    | canceled_theorem
    ;

text_items:
    text_item
    | text_item text_items
    ;

maybe_text_items:
    %empty
    | text_items
    ;

reservation:
    RESERVE reservation_segments SEMICOLON
    ;

reservation_segment:
    identifiers FOR type_expression
    ;

reservation_segments:
    reservation_segment
    | reservation_segment COMMA reservation_segments
    ;

identifiers:
    IDENTIFIER
    | IDENTIFIER COMMA identifiers
    ;

definitional_item:
    definitional_block SEMICOLON
    ;

registration_item:
    registration_block SEMICOLON
    ;

notation_item:
    notation_block SEMICOLON
    ;

definitional_block:
    DEFINITION maybe_definitional_members END
    ;

definitional_member:
    definition_item
    | definition
    | redefinition
    ;

definitional_members:
    definitional_member
    | definitional_member definitional_members
    ;

maybe_definitional_members:
    %empty
    | definitional_members
    ;

registration_block:
    REGISTRATION maybe_registration_members END
    ;

registration_member:
    loci_declaration
    | auxiliary_item
    | cluster_registration
    | identify_registration
    | properties_registration
    | reduction_registration
    | canceled_registration
    ;

registration_members:
    registration_member
    | registration_member registration_members
    ;

maybe_registration_members:
    %empty
    | registration_members
    ;

notation_block:
    NOTATION maybe_notation_members END
    ;

notation_member:
    loci_declaration
    | notation_declaration
    ;

notation_members:
    notation_member
    | notation_member notation_members
    ;

maybe_notation_members:
    %empty
    | notation_members
    ;

definition_item:
    loci_declaration
    | permissive_assumption
    | auxiliary_item
    ;

notation_declaration:
    attribute_synonym
    | attribute_antonym
    | functor_synonym
    | mode_synonym
    | predicate_synonym
    | predicate_antonym
    ;

loci_declaration:
    LET qualified_variables SEMICOLON
    | LET qualified_variables SUCH conditions SEMICOLON
    ;

permissive_assumption:
    assumption
    ;

definition:
    nonredefiniable_definition
    | redefiniable_definition
    ;

nonredefiniable_definition:
    structure_definition
    | canceled_definition
    ;

redefiniable_definition:
    mode_definition
    | functor_definition
    | predicate_definition
    | attribute_definition
    ;

redefinition:
    REDEFINE redefiniable_definition
    ;

structure_definition:
    STRUCT maybe_ancestors_list[ancestors] structure_symbol[symbol] maybe_over_loci OPEN_PAREN_HASH fields HASH_CLOSE_PAREN SEMICOLON { $$ = new StructureDefinition($symbol, $ancestors); }
    ;

maybe_ancestors_list:
    %empty { $$ = NULL; }
    | OPEN_PAREN ancestors CLOSE_PAREN { $$ = $ancestors; }
    ;

ancestors:
    structure_type_expression[ancestor] { $$ = new forward_list<unique_ptr<StructureType>>(); $$->emplace_front($ancestor); }
    | structure_type_expression[ancestor] COMMA ancestors[previous_ancestors] { $$ = $previous_ancestors; $$->emplace_front($ancestor); }
    ;

maybe_over_loci:
    %empty
    | OVER loci
    ;

structure_symbol:
    STRUCTURE_SYMBOL
    ;

loci:
    locus
    | locus COMMA loci
    ;

fields:
    field_segment
    | field_segment COMMA fields
    ;

locus:
    variable_identifier
    ;

variable_identifier:
    IDENTIFIER
    ;

field_segment:
    selector_symbols specification
    ;

selector_symbols:
    selector_symbol
    | selector_symbol COMMA selector_symbols
    ;

selector_symbol:
    SELECTOR_SYMBOL
    ;

specification:
    RARROW type_expression
    ;

maybe_specification:
    %empty
    | specification;

mode_definition:
    MODE mode_pattern maybe_specification maybe_means_definiens SEMICOLON correctness_conditions
    | MODE mode_pattern IS type_expression SEMICOLON
    ;

means_definiens:
    MEANS definiens
    ;

maybe_means_definiens:
    %empty
    | means_definiens
    ;

mode_pattern:
    mode_symbol
    | mode_symbol OF loci
    ;

mode_symbol:
    MODE_SYMBOL
    | SET;

mode_synonym:
    SYNONYM mode_pattern FOR mode_pattern SEMICOLON
    ;

definiens:
    simple_definiens
    | conditional_definiens
    ;

simple_definiens:
    maybe_label_identifier sentence_or_term_expression
    ;

sentence_or_term_expression:
    sentence
    | term_expression
    ;

maybe_label_identifier:
    %empty
    | COLON label_identifier COLON
    ;

label_identifier:
    IDENTIFIER
    ;

conditional_definiens:
    maybe_label_identifier partial_definiens_list
    | maybe_label_identifier partial_definiens_list OTHERWISE sentence_or_term_expression
    ;

partial_definiens_list:
    partial_definiens
    | partial_definiens COMMA partial_definiens_list

partial_definiens:
    sentence_or_term_expression IF sentence
    ;

functor_definition:
    FUNC functor_pattern maybe_specification maybe_means_equals_definiens SEMICOLON correctness_conditions maybe_functor_properties
    ;

functor_pattern:
    maybe_functor_loci functor_symbol maybe_functor_loci
    | left_functor_bracket loci right_functor_bracket
    ;

maybe_means_equals_definiens:
    maybe_means_definiens
    | EQUALS definiens
    ;

maybe_functor_properties:
    %empty
    | functor_properties
    ;

functor_properties:
    functor_property
    | functor_properties functor_property
    ;

functor_property_name:
    COMMUTATIVITY
    | IDEMPOTENCE
    | INVOLUTIVENESS
    | PROJECTIVITY
    ;

functor_property:
    functor_property_name justification SEMICOLON
    ;

functor_synonym:
    SYNONYM functor_pattern FOR functor_pattern SEMICOLON
    ;

maybe_functor_loci:
    %empty
    | functor_loci
    ;

functor_loci:
    locus
    | OPEN_PAREN loci CLOSE_PAREN
    ;

functor_symbol:
    FUNCTOR_SYMBOL
    ;

left_functor_bracket:
    LEFT_FUNCTOR_BRACKET_SYMBOL
    | OPEN_BRACE
    | OPEN_BRACKET
    ;

right_functor_bracket:
    RIGHT_FUNCTOR_BRACKET_SYMBOL
    | CLOSE_BRACE
    | CLOSE_BRACKET
    ;

predicate_definition:
    PRED predicate_pattern maybe_means_definiens SEMICOLON correctness_conditions maybe_predicate_properties
    ;

predicate_pattern:
    maybe_loci predicate_symbol maybe_loci
    ;

maybe_loci:
    %empty
    | loci
    ;

maybe_predicate_properties:
    %empty
    | predicate_properties
    ;

predicate_properties:
    predicate_property
    | predicate_property predicate_properties

predicate_property_name:
    SYMMETRY
    | ASYMMETRY
    | CONNECTEDNESS
    | REFLEXIVITY
    | IRREFLEXIVITY
    ;

predicate_property:
    predicate_property_name justification SEMICOLON
    ;

predicate_synonym:
    SYNONYM predicate_pattern FOR predicate_pattern SEMICOLON
    ;

predicate_antonym:
    ANTONYM predicate_pattern FOR predicate_pattern SEMICOLON
    ;

predicate_symbol:
    PREDICATE_SYMBOL
    | EQ
    ;

attribute_definition:
    ATTR attribute_pattern MEANS definiens SEMICOLON correctness_conditions
    ;

attribute_pattern:
    locus IS maybe_attribute_loci attribute_symbol
    ;

maybe_attribute_loci:
    %empty
    | attribute_loci
    ;

attribute_synonym:
    SYNONYM attribute_pattern FOR attribute_pattern SEMICOLON
    ;

attribute_antonym:
    ANTONYM attribute_pattern FOR attribute_pattern SEMICOLON
    ;

attribute_symbol:
    ATTRIBUTE_SYMBOL
    ;

attribute_loci:
    loci
    | OPEN_PAREN loci CLOSE_PAREN
    ;

canceled_definition:
    CANCELED maybe_numeral
    ;

maybe_numeral:
    %empty
    | NUMERAL
    ;

canceled_registration:
    CANCELED maybe_numeral
    ;

cluster_registration:
    existential_registration
    | conditional_registration
    | functorial_registration
    ;

existential_registration:
    CLUSTER adjective_cluster FOR type_expression SEMICOLON correctness_conditions
    ;

maybe_adjective_cluster:
    %empty
    | adjective_cluster
    ;

adjective_cluster:
    adjective
    | adjective adjective_cluster
    ;

adjective:
    maybe_arguments attribute_symbol
    | NON maybe_arguments attribute_symbol
    ;

conditional_registration:
    CLUSTER maybe_adjective_cluster RARROW adjective_cluster FOR type_expression SEMICOLON correctness_conditions
    ;

functorial_registration:
    CLUSTER term_expression RARROW adjective_cluster maybe_for_type_expression SEMICOLON correctness_conditions
    ;

maybe_for_type_expression:
    %empty
    | FOR type_expression
    ;

identify_registration:
    IDENTIFY functor_pattern WITH functor_pattern maybe_when_locus_equalities SEMICOLON correctness_conditions
    ;

locus_equality:
    locus EQ locus
    ;

locus_equalities:
    locus_equality
    | locus_equalities COMMA locus_equality
    ;

maybe_when_locus_equalities:
    %empty
    | WHEN locus_equalities
    ;

properties_registration:
    SETHOOD OF type_expression justification SEMICOLON
    ;

reduction_registration:
    REDUCE term_expression TO term_expression SEMICOLON correctness_conditions
    ;

correctness_conditions:
    %empty
    | correctness_condition_list
    | correctness_condition_list CORRECTNESS justification SEMICOLON
    | CORRECTNESS justification SEMICOLON
    ;

correctness_condition_list:
    correctness_condition
    | correctness_condition correctness_condition_list
    ;

correctness_condition_name:
    EXISTENCE
    | UNIQUENESS
    | COHERENCE
    | COMPATIBILITY
    | CONSISTENCY
    | REDUCIBILITY
    | SETHOOD
    ;

correctness_condition:
    correctness_condition_name justification SEMICOLON
    ;

theorem:
    THEOREM compact_statement
    ;

scheme_item:
    scheme_block SEMICOLON
    ;

scheme_block:
    SCHEME maybe_scheme_identifier OPEN_BRACE scheme_parameters CLOSE_BRACE COLON scheme_conclusion maybe_provided_scheme_premises justification
    ;

maybe_scheme_identifier:
    %empty
    | scheme_identifier
    ;

maybe_provided_scheme_premises:
    %empty
    | PROVIDED scheme_premises
    ;

scheme_premises:
    scheme_premise
    | scheme_premise AND scheme_premises
    ;

scheme_identifier:
    IDENTIFIER
    ;

scheme_parameters:
    scheme_segment
    | scheme_segment COMMA scheme_parameters
    ;

scheme_conclusion:
    sentence
    ;

scheme_premise:
    proposition
    ;

scheme_segment:
    predicate_segment
    | functor_segment
    ;

predicate_segment:
    predicate_identifiers OPEN_BRACKET maybe_type_expression_list CLOSE_BRACKET
    ;

predicate_identifiers:
    predicate_identifier
    | predicate_identifier COMMA predicate_identifiers
    ;

predicate_identifier:
    IDENTIFIER
    ;

maybe_type_expression_list:
    %empty
    | type_expression_list
    ;

functor_segment:
    functor_identifiers OPEN_PAREN maybe_type_expression_list CLOSE_PAREN specification
    ;

functor_identifiers:
    functor_identifier
    | functor_identifier COMMA functor_identifiers
    ;

functor_identifier:
    IDENTIFIER
    ;

auxiliary_item:
    statement
    | private_definition
    ;

canceled_theorem:
    CANCELED maybe_numeral SEMICOLON
    ;

private_definition:
    constant_definition
    | private_functor_definition
    | private_predicate_definition
    ;

constant_definition:
    SET equating_list SEMICOLON
    ;

equating_list:
    equating
    | equating COMMA equating_list
    ;

equating:
    variable_identifier EQ term_expression
    ;

private_functor_definition:
    DEFFUNC private_functor_pattern EQ term_expression SEMICOLON
    ;

private_predicate_definition:
    DEFPRED private_predicate_pattern MEANS sentence SEMICOLON
    ;

private_functor_pattern:
    functor_identifier OPEN_PAREN maybe_type_expression_list CLOSE_PAREN
    ;

private_predicate_pattern:
    predicate_identifier OPEN_BRACKET maybe_type_expression_list CLOSE_BRACKET
    ;

reasoning:
    %empty
    | reasoning_items
    | per_cases
    | THEN per_cases
    | reasoning_items per_cases
    | reasoning_items THEN per_cases
    ;

reasoning_items:
    reasoning_item
    | reasoning_item reasoning_items
    ;

per_cases:
    PER CASES simple_justification SEMICOLON case_list_or_suppose_list
    ;

case_list_or_suppose_list:
    case_list
    | suppose_list
    ;

case_list:
    case
    | case case_list
    ;

case:
    CASE proposition_or_conditions SEMICOLON reasoning END SEMICOLON
    ;

proposition_or_conditions:
    proposition
    | conditions
    ;

suppose_list:
    suppose
    | suppose suppose_list
    ;

suppose:
    SUPPOSE proposition_or_conditions SEMICOLON reasoning END SEMICOLON
    ;

reasoning_item:
    auxiliary_item
    | skeleton_item
    ;

skeleton_item:
    generalization
    | assumption
    | conclusion
    | exemplification
    ;

generalization:
    LET qualified_variables maybe_such_conditions SEMICOLON
    ;

maybe_such_conditions:
    %empty
    | SUCH conditions
    ;

assumption:
    single_assumption
    | collective_assumption
    | existential_assumption
    ;

single_assumption:
    ASSUME proposition SEMICOLON
    ;

collective_assumption:
    ASSUME conditions SEMICOLON
    ;

existential_assumption:
    GIVEN qualified_variables maybe_such_conditions SEMICOLON
    ;

conclusion:
    THUS compact_statement
    | THUS THEN compact_statement
    | THUS iterative_equality
    | THUS THEN iterative_equality
    | diffuse_conclusion
    ;

diffuse_conclusion:
    THUS diffuse_statement
    | HEREBY reasoning END SEMICOLON
    ;

exemplification:
    TAKE examples SEMICOLON
    ;

examples:
    example
    | example COMMA examples
    ;

example:
    term_expression
    | variable_identifier EQ term_expression
    ;

statement:
    linkable_statement
    | THEN linkable_statement
    | diffuse_statement
    ;

linkable_statement:
    compact_statement
    | choice_statement
    | type_changing_statement
    | iterative_equality
    ;

compact_statement:
    proposition justification SEMICOLON
    ;

choice_statement:
    CONSIDER qualified_variables SUCH conditions simple_justification SEMICOLON
    ;

type_changing_statement:
    RECONSIDER type_change_list AS type_expression simple_justification SEMICOLON
    ;

type_change_list:
    equating_or_variable_identifier
    | equating_or_variable_identifier COMMA type_change_list
    ;

equating_or_variable_identifier:
    equating
    | variable_identifier
    ;

iterative_equality:
    maybe_label_identifier_colon OPEN_PAREN term_expression EQ term_expression CLOSE_PAREN simple_justification equality_iterations SEMICOLON
    ;

equality_iteration:
    DOTEQ term_expression simple_justification
    ;

equality_iterations:
    equality_iteration
    | equality_iteration equality_iterations
    ;

maybe_label_identifier_colon:
    %empty
    | label_identifier COLON
    ;

diffuse_statement:
    maybe_label_identifier_colon NOW reasoning END SEMICOLON
    ;

justification:
    simple_justification
    | proof
    ;

simple_justification:
    straightforward_justification
    | scheme_justification
    ;

proof:
    PROOF reasoning END
    | ATPROOF reasoning END
    ;

straightforward_justification:
    %empty
    | BY references
    ;

scheme_justification:
    FROM scheme_reference
    | FROM scheme_reference OPEN_PAREN references CLOSE_PAREN
    ;

references:
    reference
    | reference COMMA references
    ;

reference:
    local_reference
    | library_reference
    ;

scheme_reference:
    local_scheme_reference
    | library_scheme_reference
    ;

local_reference:
    label_identifier
    ;

local_scheme_reference:
    scheme_identifier
    ;

library_reference:
    theorem_reference
    | definition_reference
    ;

definition_reference:
    ARTICLE_NAME[article] COLON DEF NUMERAL[number]
        { eventLibraryDefinitionReferenced(*$article, $number); }
    ;

theorem_reference:
    ARTICLE_NAME[article] COLON NUMERAL[number]
        { eventLibraryTheoremReferenced(*$article, $number); }
    ;

library_scheme_reference:
    ARTICLE_NAME[article] COLON SCH NUMERAL[number]
        { eventLibrarySchemeReferenced(*$article, $number); }
    ;

conditions:
    THAT proposition_list
    ;

proposition_list:
    proposition
    | proposition AND proposition_list
    ;

proposition:
    maybe_label_identifier_colon sentence
    ;

sentence:
    formula_expression
    ;

//*************||
// EXPRESSIONS ||
//*************||

formula_expression:
    atomic_formula_expression
    | OPEN_PAREN quantified_formula_expression CLOSE_PAREN
    | OPEN_PAREN formula_expression AMPERSAND formula_expression CLOSE_PAREN
    | OPEN_PAREN formula_expression AMPERSAND DOTDOTDOT AMPERSAND formula_expression CLOSE_PAREN
    | OPEN_PAREN formula_expression OR formula_expression CLOSE_PAREN
    | OPEN_PAREN formula_expression OR DOTDOTDOT OR formula_expression CLOSE_PAREN
    | OPEN_PAREN formula_expression IMPLIES formula_expression CLOSE_PAREN
    | OPEN_PAREN formula_expression IFF formula_expression CLOSE_PAREN
    | NOT formula_expression
    | CONTRADICTION
    | THESIS
    ;

atomic_formula_expression:
    OPEN_PAREN predicative_formula CLOSE_PAREN
    | predicate_identifier OPEN_BRACKET maybe_term_expression_list CLOSE_BRACKET
    | OPEN_PAREN term_expression IS adjective_cluster CLOSE_PAREN
    | OPEN_PAREN term_expression IS type_expression CLOSE_PAREN
    ;

predicative_formula:
    maybe_does_do_not predicate_symbol
    | term_expression_list maybe_does_do_not predicate_symbol
    | maybe_does_do_not predicate_symbol term_expression_list
    | term_expression_list predicative_formula_tail
    ;

predicative_formula_tail:
    predicative_formula_part
    | predicative_formula_tail predicative_formula_part
    ;

predicative_formula_part:
    maybe_does_do_not predicate_symbol term_expression_list
    ;

maybe_does_do_not:
    %empty
    | DOES NOT
    | DO NOT
    ;

quantified_formula_expression:
    FOR qualified_variables ST formula_expression HOLDS formula_expression
    | FOR qualified_variables ST formula_expression quantified_formula_expression
    | FOR qualified_variables HOLDS formula_expression
    | FOR qualified_variables quantified_formula_expression
    | EX qualified_variables ST formula_expression
    ;

qualified_variables:
    implicitly_qualified_variables
    | explicitly_qualified_variables
    | explicitly_qualified_variables COMMA implicitly_qualified_variables
    ;

implicitly_qualified_variables:
    variables
    ;

explicitly_qualified_variables:
    qualified_segment
    | qualified_segment COMMA explicitly_qualified_variables
    ;

qualified_segment:
    variables qualification
    ;

variables:
    variable_identifier
    | variable_identifier COMMA variables
    ;

qualification:
    being_or_be type_expression
    ;

being_or_be:
    BEING
    | BE
    ;

type_expression:
    radix_type_expression
    | adjective_cluster radix_type_expression
    ;

radix_type_expression:
    mode_type_expression
    | structure_type_expression
    ;

mode_type_expression:
    mode_symbol
    | OPEN_PAREN mode_symbol OF term_expression_list CLOSE_PAREN
    ;

structure_type_expression:
    structure_symbol[symbol] { $$ = new StructureType($symbol); }
    | OPEN_PAREN structure_symbol[symbol] OVER term_expression_list CLOSE_PAREN { $$ = new StructureType($symbol); }
    ;

type_expression_list:
    type_expression
    | type_expression COMMA type_expression_list
    ;

term_expression:
    OPEN_PAREN maybe_arguments functor_symbol maybe_arguments CLOSE_PAREN
    | left_functor_bracket term_expression_list right_functor_bracket
    | functor_identifier OPEN_PAREN maybe_term_expression_list CLOSE_PAREN
    | structure_symbol OPEN_PAREN_HASH maybe_term_expression_list HASH_CLOSE_PAREN
    | variable_identifier
    | fraenkel_term
    | NUMERAL
    | OPEN_PAREN term_expression QUA type_expression CLOSE_PAREN
    | OPEN_PAREN THE selector_symbol OF term_expression CLOSE_PAREN
    | THE selector_symbol
    | OPEN_PAREN THE type_expression CLOSE_PAREN
    | private_definition_parameter
    | IT
    | forgetful_functor_term
    ;

fraenkel_term:
    OPEN_BRACE term_expression maybe_postqualifications COLON formula_expression CLOSE_BRACE
    | OPEN_PAREN THE SET ALL term_expression maybe_postqualifications CLOSE_PAREN
    ;

forgetful_functor_term:
    OPEN_PAREN THE structure_symbol OF term_expression CLOSE_PAREN
    ;

maybe_arguments:
    %empty
    | arguments
    ;

arguments:
    OPEN_PAREN term_expression_list CLOSE_PAREN
    ;

maybe_term_expression_list:
    %empty
    | term_expression_list
    ;

term_expression_list:
    term_expression
    | term_expression COMMA term_expression_list

maybe_postqualifications:
    %empty
    | postqualifications
    ;

postqualifications:
    postqualification
    | postqualification postqualifications
    ;

postqualification:
    WHERE postqualifying_segments
    | WHERE postqualified_variable
    ;

postqualifying_segments:
    postqualifying_segment
    | postqualifying_segment COMMA postqualifying_segments
    ;

postqualifying_segment:
    postqualified_variables IS type_expression
    ;

postqualified_variables:
    postqualified_variable
    | postqualified_variable COMMA postqualified_variables
    ;

postqualified_variable:
    IDENTIFIER
    ;

private_definition_parameter:
    "$1"
    | "$2"
    | "$3"
    | "$4"
    | "$5"
    | "$6"
    | "$7"
    | "$8"
    | "$9"
    | "$10"
    ;
%%
void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
    fprintf(stderr, "Line: %d\n", yylineno);
}
