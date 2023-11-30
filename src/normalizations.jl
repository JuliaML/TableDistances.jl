# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

default_normalization(::Type) = nothing
default_normalization(::Type{Continuous}) = x -> (quantile(x, 0.75) - quantile(x, 0.25))
default_normalization(::Type{Compositional}) = x -> maximum(norm.(x))

function normalize(tables...)
  rtables = Tables.rowtable.(tables)
  longtable = Tables.columntable(reduce(vcat, rtables))
  cols = Tables.columns(longtable)
  names = Tables.columnnames(cols)

  constants = map(names) do nm
    x = Tables.getcolumn(cols, nm)
    k = default_normalization(elscitype(x))
    isnothing(k) ? k : k(x)
  end

  map(tables) do table
    # perform normalization
    cols = Tables.columns(table)
    columns = map(names, constants) do nm, k
      x = Tables.getcolumn(cols, nm)
      isnothing(k) ? x : x ./ k
    end

    # return same table type
    (; zip(names, columns)...) |> Tables.materializer(table)
  end
end
