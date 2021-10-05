# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

default_normalization(::Type{Continuous}) =
  x -> (quantile(x, 0.75) - quantile(x, 0.25))
default_normalization(::Type{<:Compositional}) =
  x -> maximum(norm.(x))

# fallback to no normalization
default_normalization(::Type) = nothing

function normalize(tables...)
  partitions = Tables.partitioner(collect(tables))
  longtable  = TableOperations.joinpartitions(partitions)
  colnames   = Tables.columnnames(longtable)
  scitypes   = schema(longtable).scitypes

  constants  = map(zip(colnames, scitypes)) do (c, s)
    x = Tables.getcolumn(longtable, c)
    k = default_normalization(s)
    isnothing(k) ? k : k(x)
  end

  colconst   = zip(colnames, constants)

  map(tables) do table
    # perform normalization
    colvalues = map(colconst) do (c, k)
      x = Tables.getcolumn(table, c)
      isnothing(k) ? x : x ./ k
    end

    # return same table type
    ctor = Tables.materializer(table)
    ctor((; zip(colnames, colvalues)...))
  end
end
