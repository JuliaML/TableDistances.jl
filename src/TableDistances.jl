# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistances

using Distances
using StringDistances
using CoDa
using Tables
using ScientificTypes
using Statistics

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

# ------------------------------------
# normalizations for scientific types
# ------------------------------------

default_normalization(::Type{Continuous}) =
  x -> x ./ (quantile(x, 0.75) - quantile(x, 0.25))
default_normalization(::Type{<:Compositional}) =
  x -> x ./ maximum(norm.(x))

function normalize(table)
  colnames  = Tables.columnnames(table)
  scitypes  = schema(table).scitypes
  norms     = default_normalization.(scitypes)
  colsnorms = zip(colnames, norms)
  
  f((c, n)) = Tables.getcolumn(table, c) |> n
  
  colvalues = map(f, colsnorms)
  
  # return same table type
  ctor = Tables.materializer(table)
  ctor((; zip(colnames, colvalues)...))
end

# ------------------------------------

"""
    TableDistance(; normalize=true)

Distance between rows of Tables.jl tables.

## Options

* `normalize` - whether or not to normalize the columns

## Example

```julia
julia> pairwise(TableDistance(), table₁, table₂)
```
"""
struct TableDistance
  normalize::Bool
end

TableDistance(; normalize=true) = TableDistance(normalize)

function pairwise(d::TableDistance, table₁, table₂)
  distances₁ = default_distances(table₁)
  distances₂ = default_distances(table₂)

  @assert distances₁ == distances₂ "incompatible columns types"
  
  # normalize tables if necessary
  n = d.normalize ? normalize : identity
  t₁, t₂ = n(table₁), n(table₂)

  function f((c, d))
    x = Tables.getcolumn(t₁, c)
    y = Tables.getcolumn(t₂, c)
    pairwise(d, x, y)
  end
  
  mapreduce(f, +, distances₁)
end

export
  TableDistance,
  pairwise

end
