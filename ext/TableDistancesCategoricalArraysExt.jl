module TableDistancesCategoricalArraysExt
  
import TableDistances: default_distance
import TableDistances: OredredCategDistance, CategoricalDistance
import Distances: result_type

using Distances
using CategoricalArrays

(::OredredCategDistance)(x, y) = abs(levelcode(x) - levelcode(y))

result_type(::OredredCategDistance, x, y) = Float64

(::CategoricalDistance)(x, y) = x != y

result_type(::CategoricalDistance, x, y) = Bool

default_distance(::Type{<:CategoricalValue}, x) = isordered(x) ? OredredCategDistance() : CategoricalDistance()

end
