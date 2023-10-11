# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    OredredCategDistance()(x, y)

Return the absolute value of the difference between the OredredCateg codes of x and y.
"""
struct OredredCategDistance <: Metric end

"""
    CategoricalDistance()(x, y)

Return `true` if x and y are different classes, else return `false`.
"""
struct CategoricalDistance <: Metric end

default_distance(x) = default_distance(eltype(x), x)
default_distance(::Type{<:Real}, x) = Euclidean()
default_distance(::Type{<:Integer}, x) = Cityblock()
default_distance(::Type{<:AbstractString}, x) = Levenshtein()

function default_distances(table)
  cols = Tables.columns(table)
  names = Tables.columnnames(cols)
  Dict(nm => default_distance(Tables.getcolumn(cols, nm)) for nm in names)
end
