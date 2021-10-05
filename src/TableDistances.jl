# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistances

using Tables
using TableOperations
using ScientificTypes
using Distances
using StringDistances
using CategoricalArrays
using CoDa
using Statistics

import Distances: pairwise, result_type

include("distances.jl")
include("normalizations.jl")
include("weights.jl")
include("api.jl")

export
  TableDistance,
  pairwise

end
