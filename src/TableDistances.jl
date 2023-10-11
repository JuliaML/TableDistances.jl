# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistances

# basic imports
using Tables
using Distances
using Statistics

# custom distances
using StringDistances

import Distances: pairwise, result_type

include("distances.jl")
include("normalizations.jl")
include("weights.jl")
include("api.jl")

export
  TableDistance,
  pairwise

end
