#include "wsm.h"

#include <algorithm>

ostream& operator<<(ostream& os, const StructureType& o) {
    os << *(o.symbol);

    return os;
}

ostream& operator<<(ostream& os, const StructureDefinition& o) {
    if (o.ancestors) {
        os << "(";
        std::for_each(o.ancestors->begin(), o.ancestors->end(), [&os](const unique_ptr<StructureType>& st) {
            os << *st;
        });
        os << ") -> ";
    }

    os << *(o.symbol);

    return os;
}
