# TableDistances.jl

[![Build Status](https://github.com/juliohm/TableDistances.jl/workflows/CI/badge.svg)](https://github.com/juliohm/TableDistances.jl/actions)
[![Coverage](https://codecov.io/gh/juliohm/TableDistances.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/TableDistances.jl)

This package provides methods for computing distances between rows of general
[Tables.jl](https://github.com/JuliaData/Tables.jl) tables using the ecosystem
of scientific types available in [DataScienceTraits.jl](https://github.com/JuliaML/DataScienceTraits.jl).
It follows the [Distances.jl](https://github.com/JuliaStats/Distances.jl) interface
as much as possible.

## Rationale

A common task in statistics and machine learning consists of computing distances between observations
for different purposes (e.g. clustering, kernel methods). When the data is homogeneous, i.e. all the
attributes have the same scientific type, one can use packages such as [Distances.jl](https://github.com/JuliaStats/Distances.jl)
directly on the result of `Tables.matrix(table)`. On the other hand, when the table is heterogeneous,
one must combine different distances for the various attributes using some weighting scheme.

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add TableDistances
```

## Usage

We follow the [Distances.jl](https://github.com/JuliaStats/Distances.jl) interface as much as possible:

```julia
julia> using TableDistances

julia> table = (a=1:3, b=rand(3), c=["A", "B", "C"], d=[1, 2, 4])
(a = 1:3, b = [0.6550604694752227, 0.3136943350481851, 0.21473814711738037], c = ["A", "B", "C"], d = [1, 2, 4])

julia> D = pairwise(TableDistance(), table)
3×3 Matrix{Float64}:
 0.0      1.13763   1.25
 1.13763  0.0       0.862368
 1.25     0.862368  0.0
```

## Contributing

Contributions are very welcome. Please [open an issue](https://github.com/JuliaML/TableDistances.jl/issues) if you have questions.

### Authors

- [Júlio Hoffimann](https://github.com/juliohm)
- [José Augusto](https://github.com/mrr00b00t)
