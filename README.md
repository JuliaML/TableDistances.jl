# TableDistances.jl

[![Build Status](https://github.com/juliohm/TableDistances.jl/workflows/CI/badge.svg)](https://github.com/juliohm/TableDistances.jl/actions)
[![Coverage](https://codecov.io/gh/juliohm/TableDistances.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/TableDistances.jl)

This package provides methods for computing distances between rows of general
[Tables.jl](https://github.com/JuliaData/Tables.jl) tables using the ecosystem
of scientific types available in [ScientificTypes.jl](https://github.com/JuliaAI/ScientificTypes.jl).
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
using TableDistances
using ScientificTypes

# create an heterogeneous table
table = (a=1:5, b=rand(5), c=[:A,:B,:C], d=[1, 2, 4, 5])

# adjust the scientific types
t = coerce(table, :a => Count, :b => Continuous, :c => Multiclass, :d => OrderedFactor)

# compute the pairwise distance between rows
D = pairwise(TableDistance(), t)
```

Default distances from various packages such as
[StringDistances.jl](https://github.com/matthieugomez/StringDistances.jl)
are automatically chosen depending on the table schema, and weights can
be specified for each attribute.

### Authors

- [Júlio Hoffimann](https://github.com/juliohm)
- [José Augusto](https://github.com/mrr00b00t)
