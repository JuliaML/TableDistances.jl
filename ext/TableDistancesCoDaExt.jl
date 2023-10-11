# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module TableDistancesCoDaExt

import TableDistances: default_distance, default_normalization
using CoDa

default_distance(::Type{<:Composition}, x) = Aitchison()

default_normalization(::Type{<:Composition}) = x -> maximum(norm.(x))

end
