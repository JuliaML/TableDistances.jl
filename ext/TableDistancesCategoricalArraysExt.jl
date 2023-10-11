# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistancesCategoricalArraysExt
  
import TableDistances: default_distance
import TableDistances: OredredCategDistance, CategoricalDistance
import Distances: result_type

using Distances
using CategoricalArrays

(::CategoricalDistance)(x, y) = x != y

result_type(::CategoricalDistance, x, y) = Bool

(::OredredCategDistance)(x, y) = abs(levelcode(x) - levelcode(y))

result_type(::OredredCategDistance, x, y) = Float64

default_distance(::Type{<:CategoricalValue}, x) = isordered(x) ? OredredCategDistance() : CategoricalDistance()

end
