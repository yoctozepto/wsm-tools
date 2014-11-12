#include <string>
#include <forward_list>
#include <memory>
#include <ostream>

using std::string;
using std::forward_list;
using std::unique_ptr;
using std::ostream;

class StructureType {
    unique_ptr<string> symbol;

    friend ostream& operator<<(ostream&, const StructureType&);

public:
    StructureType(string* symbol) : symbol(symbol) {}
};

class StructureDefinition {
    unique_ptr<string> symbol;

    unique_ptr<forward_list<unique_ptr<StructureType>>> ancestors;

    friend ostream& operator<<(ostream&, const StructureDefinition&);

public:
    StructureDefinition(string* symbol, forward_list<unique_ptr<StructureType>>* ancestors) : symbol(symbol), ancestors(ancestors) {}
};
