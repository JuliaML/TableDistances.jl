# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

default_distance(::Type{Continuous})      = Distances.Euclidean()
default_distance(::Type{Count})           = Distances.Cityblock()
default_distance(::Type{<:Multiclass})    = MulticlassDistance()
default_distance(::Type{<:OrderedFactor}) = OrderedFactorDistance()
default_distance(::Type{Textual})         = StringDistances.Levenshtein()
default_distance(::Type{<:Compositional}) = CoDa.CoDaDistance()

struct MulticlassDistance <: Metric end

(::MulticlassDistance)(x, y) = convert(Int64, levelcode(x) != levelcode(y))

struct OrderedFactorDistance <: Metric end

(::OrderedFactorDistance)(x, y) = abs(levelcode(x) - levelcode(y))

function default_distances(table)
  columns = Tables.columnnames(table)
  scitypes = schema(table).scitypes
  distances = default_distance.(scitypes)
  Dict(columns .=> distances)
end