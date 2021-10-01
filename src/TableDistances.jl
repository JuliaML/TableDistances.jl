module TableDistances

using Distances
using StringDistances
using CoDa: CoDaDistance
using ScientificTypesBase

import Distances: pairwise

# -------------------------------
# distances for scientific types
# -------------------------------

default_distance(::Continuous) = Euclidean()
# TODO: add other cases

# -------------------------------

"""
    TableDistance

Distance between rows of Tables.jl tables.

## Example

```julia
julia> pairwise(TableDistance(), table₁, table₂)
```
"""
struct TableDistance end

function pairwise(::TableDistance, table₁, table₂)
  # TODO: add implementation
end

export
  TableDistance,
  pairwise

end
