# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

struct OrederedCategDistance <: Metric end

(::OrederedCategDistance)(x, y) = abs(levelcode(x) - levelcode(y))

result_type(::OrederedCategDistance, x, y) = Float64

struct UnorderedCategDistance <: Metric end

(::UnorderedCategDistance)(x, y) = x != y

result_type(::UnorderedCategDistance, x, y) = Bool

struct NormDistance <: Metric end

(::NormDistance)(x, y) = norm(x - y)

result_type(::NormDistance, x, y) = Float64

default_distance(x) = default_distance(elscitype(x), x)
default_distance(::Type{Continuous}, x) = Euclidean()
default_distance(::Type{Categorical}, x) = isordered(categorical(x)) ? OrederedCategDistance() : UnorderedCategDistance()
default_distance(::Type, x) = NormDistance()

function default_distances(table)
  cols = Tables.columns(table)
  names = Tables.columnnames(cols)
  Dict(nm => default_distance(Tables.getcolumn(cols, nm)) for nm in names)
end
