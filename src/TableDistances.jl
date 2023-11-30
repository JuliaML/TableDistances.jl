# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistances

using Tables
using Distances
using Statistics
using DataScienceTraits

using DataScienceTraits: Continuous
using DataScienceTraits: Categorical
using DataScienceTraits: Compositional
using DataScienceTraits: isordered
using CategoricalArrays: levelcode
using CoDa: Aitchison, norm

import Distances: pairwise, result_type

include("distances.jl")
include("normalizations.jl")
include("weights.jl")
include("api.jl")

export
  TableDistance,
  pairwise

end
