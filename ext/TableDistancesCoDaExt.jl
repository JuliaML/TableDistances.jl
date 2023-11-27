# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistancesCoDaExt

using CoDa

using DataScienceTraits: Compositional

import TableDistances: default_distance, default_normalization

default_distance(::Type{Compositional}, x) = Aitchison()

default_normalization(::Type{Compositional}) = x -> maximum(norm.(x))

end
