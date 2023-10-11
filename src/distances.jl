# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

default_distance(x) = default_distance(eltype(x), x)
default_distance(::Type{<:Real}, x) = Euclidean()
default_distance(::Type{<:Integer}, x) = Cityblock()
default_distance(::Type{<:AbstractString}, x) = Levenshtein()

function default_distances(table)
  cols = Tables.columns(table)
  names = Tables.columnnames(cols)
  Dict(nm => default_distance(Tables.getcolumn(cols, nm)) for nm in names)
end
