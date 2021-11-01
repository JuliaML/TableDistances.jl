# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    MulticlassDistance()(x, y)

Return `true` if x and y are different classes, else return `false`.
"""
struct MulticlassDistance <: Metric end

(::MulticlassDistance)(x, y) = x != y

result_type(::MulticlassDistance, x, y) = Bool

"""
    OrderedFactorDistance()(x, y)

Return the absolute value of the difference between the categorical codes of x and y.
"""
struct OrderedFactorDistance <: Metric end

(::OrderedFactorDistance)(x, y) = abs(levelcode(x) - levelcode(y))

result_type(::OrderedFactorDistance, x, y) = Float64

default_distance(::Type{Continuous})      = Distances.Euclidean()
default_distance(::Type{Count})           = Distances.Cityblock()
default_distance(::Type{<:Multiclass})    = MulticlassDistance()
default_distance(::Type{<:OrderedFactor}) = OrderedFactorDistance()
default_distance(::Type{Textual})         = StringDistances.Levenshtein()
default_distance(::Type{<:Compositional}) = CoDa.Aitchison()

function default_distances(table)
  columns = Tables.columnnames(table)
  scitypes = schema(table).scitypes
  distances = default_distance.(scitypes)
  Dict(columns .=> distances)
end
