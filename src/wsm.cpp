#include "wsm.h"

ostream& operator<<(ostream& os, const StructureType& o) {
    return os << *(o.symbol);
}

ostream& operator<<(ostream& os, const StructureDefinition& o) {
    return os << "TODO" << " -> " << *(o.symbol);
}
