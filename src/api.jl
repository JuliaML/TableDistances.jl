# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    TableDistance(; normalize=true, weights=nothing)

Distance between rows of Tables.jl tables.

## Options

* `normalize` - whether or not to normalize the columns
                of the tables before computing distances
                (default to `true`)
* `weights`   - dictionary with weights for each column
                (default to uniform weights)

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

function pairwise(td::TableDistance, table₁, table₂)
  ts, ds, ws = preprocess(td, table₁, table₂)

  function f((c, d))
    x = Tables.getcolumn(ts[1], c)
    y = Tables.getcolumn(ts[2], c)
    ws[c] * pairwise(d, x, y)
  end
  
  mapreduce(f, +, ds)
end

function pairwise(td::TableDistance, table)
  ts, ds, ws = preprocess(td, table)

  function f((c, d))
    x = Tables.getcolumn(ts[1], c)
    ws[c] * pairwise(d, x)
  end
  
  mapreduce(f, +, ds)
end

function preprocess(td, tables...)
  # retrieve parameters
  distances = [default_distances(table) for table in tables]
  weights   = isnothing(td.weights) ? default_weights(first(tables)) : td.weights

  # sanity checks
  @assert length(unique(distances)) == 1 "incompatible schema"
  @assert keys(weights) == keys(first(distances)) "invalid columns in weights"
  @assert all(values(weights) .> 0) "weights must be positive"

  # normalize weights
  c, w = keys(weights), values(weights)
  weights = Dict(c .=> w ./ sum(w))

  # normalize columns
  stdtables = td.normalize ? normalize(tables...) : tables

  stdtables, first(distances), weights
end
