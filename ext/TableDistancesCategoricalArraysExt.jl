# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistancesCategoricalArraysExt
  
import TableDistances: default_distance
import TableDistances: OrederedCategDistance, UnorderedCategDistance
import Distances: result_type

using Distances
using CategoricalArrays

(::UnorderedCategDistance)(x, y) = x != y

result_type(::UnorderedCategDistance, x, y) = Bool

(::OrederedCategDistance)(x, y) = abs(levelcode(x) - levelcode(y))

result_type(::OrederedCategDistance, x, y) = Float64

default_distance(::Type{<:CategoricalValue}, x) = isordered(x) ? OrederedCategDistance() : UnorderedCategDistance()

end
