# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistances

using Tables
using TableOperations
using ScientificTypes
using Distances
using StringDistances
using CoDa
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
  x -> (quantile(x, 0.75) - quantile(x, 0.25))
default_normalization(::Type{<:Compositional}) =
  x -> maximum(norm.(x))

# fallback to no normalization
default_normalization(::Type) = x -> one(eltype(x))

function normalize(tables...)
  partitions = Tables.partitioner(collect(tables))
  longtable  = TableOperations.joinpartitions(partitions)
  colnames   = Tables.columnnames(longtable)
  scitypes   = schema(longtable).scitypes

  constants  = map(zip(colnames, scitypes)) do (c, s)
    x = Tables.getcolumn(longtable, c)
    k = default_normalization(s)
    k(x)
  end

  colconst   = zip(colnames, constants)

  map(tables) do table
    # perform normalization
    colvalues = [Tables.getcolumn(table, c) ./ k for (c, k) in colconst]

    # return same table type
    ctor = Tables.materializer(table)
    ctor((; zip(colnames, colvalues)...))
  end
end

# ------------------------------------

"""
    TableDistance(; normalize=true)

Distance between rows of Tables.jl tables.

## Options

* `normalize` - whether or not to normalize the columns
                of the tables before computing distances

## Example

```julia
julia> pairwise(TableDistance(), table₁, table₂)
```
"""
struct TableDistance{W}
  normalize::Bool
  weights::W
end

TableDistance(; normalize=true, weights=nothing) =
  TableDistance{typeof(weights)}(normalize, weights)

function default_weights(table)
  cols = Tables.columnnames(table)
  n = length(cols)
  Dict(cols .=> fill(1/n, n))
end

function pairwise(td::TableDistance, table₁, table₂)
  distances₁ = default_distances(table₁)
  distances₂ = default_distances(table₂)

  @assert distances₁ == distances₂ "incompatible columns types"

  weights = isnothing(td.weights) ? default_weights(table₁) : td.weights

  @assert keys(weights) == keys(distances₁) "incompatible columns names and weights"
  @assert all(values(weights) .> 0) "negative weights not supported"

  weights = map(collect(weights)) do (key, value)
    key => value / sum(values(weights))
  end |> Dict
  
  # normalize tables if necessary
  t₁, t₂ = if td.normalize
    normalize(table₁, table₂)
  else
    table₁, table₂
  end

  function f((c, d))
    x = Tables.getcolumn(t₁, c)
    y = Tables.getcolumn(t₂, c)
    weights[c] * pairwise(d, x, y)
  end
  
  mapreduce(f, +, distances₁)
end

export
  TableDistance,
  pairwise

end
