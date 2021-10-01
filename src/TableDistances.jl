module TableDistances

using Distances
using StringDistances
using CoDa
using ScientificTypesBase
using ScientificTypes
using Tables

import Distances: pairwise

# -------------------------------
# distances for scientific types
# -------------------------------

default_distance(::Type{Continuous})      = Distances.Euclidean()
default_distance(::Type{Count})           = Distances.Cityblock()
default_distance(::Type{<:Multiclass})    = Distances.Hamming()
default_distance(::Type{<:OrderedFactor}) = Distances.Chebyshev()
default_distance(::Type{Textual})         = StringDistances.Levenshtein()
default_distance(::Type{<:Compositional}) = CoDa.CoDaDistance()

# -------------------------------

"""
    cols2dists(table)

Given a table, return a dictionary with column => default_distance. 
"""
function cols2dists(table)
  columns = Tables.columnnames(table)
  scitypes = schema(table).scitypes
  distances = default_distance.(scitypes)
  Dict(columns .=> distances)
end

"""
    TableDistance

Distance between rows of Tables.jl tables.

## Example

```julia
julia> pairwise(TableDistance(), table₁, table₂)
```
"""
struct TableDistance end

function pairwise(td::TableDistance, table₁, table₂)
  distance4column₁ = cols2dists(table₁)
  distance4column₂ = cols2dists(table₂)

  @assert distance4column₁ == distance4column₂ "incompatible columns types"

  sum([pairwise(distance4column₁[key], Tables.getcolumn(table₁, key), Tables.getcolumn(table₂,key)) for key in keys(distance4column₁)])
end

export
  TableDistance,
  pairwise

end
