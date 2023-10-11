# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistancesCategoricalArraysExt
  
import TableDistances: default_distance
import Distances: result_type

using Distances
using CategoricalArrays

struct OrederedCategDistance <: Metric end

(::OrederedCategDistance)(x, y) = abs(levelcode(x) - levelcode(y))

result_type(::OrederedCategDistance, x, y) = Float64

struct UnorderedCategDistance <: Metric end

(::UnorderedCategDistance)(x, y) = x != y

result_type(::UnorderedCategDistance, x, y) = Bool

default_distance(::Type{<:CategoricalValue}, x) = isordered(x) ? OrederedCategDistance() : UnorderedCategDistance()

end
