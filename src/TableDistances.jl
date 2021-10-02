module TableDistances

using Distances
using StringDistances
using CoDa
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

function default_distances(table)
  columns = Tables.columnnames(table)
  scitypes = schema(table).scitypes
  distances = default_distance.(scitypes)
  Dict(columns .=> distances)
end

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

function pairwise(td::TableDistance, table₁, table₂)
  distances₁ = default_distances(table₁)
  distances₂ = default_distances(table₂)

  @assert distances₁ == distances₂ "incompatible columns types"
  
  function f((c, d))
    x = Tables.getcolumn(table₁, c)
    y = Tables.getcolumn(table₂, c)
    pairwise(d, x, y)
  end
  
  mapreduce(f, +, distances₁)
end

export
  TableDistance,
  pairwise

end
