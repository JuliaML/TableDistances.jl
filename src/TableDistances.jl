# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistances

using Tables
using TableOperations
using ScientificTypes
using Distances
using StringDistances
using CoDa
using Statistics
using CategoricalArrays

import Distances: pairwise

include("distances.jl")
include("normalizations.jl")
include("weights.jl")
include("api.jl")

export
  TableDistance,
  pairwise

end
