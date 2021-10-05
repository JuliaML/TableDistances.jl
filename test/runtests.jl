using TableDistances
using Tables
using Test
using CategoricalArrays
using CoDa
using Distances
using ScientificTypes

@testset "TableDistances.jl" begin
  @testset "Pairwise" begin
    # test data
    table₁ = (a = rand(4), b = rand(Composition{5}, 4))
    table₂ = (a = rand(6), b = rand(Composition{5}, 6))
    table₃ = (a = categorical(["a", "b", "a", "c"]), b = categorical([1, 4, 1, 5]))

    # specific columns
    euclidcol₁ = Tables.getcolumn(table₁, :a)
    euclidcol₂ = Tables.getcolumn(table₂, :a)
    codacol₁   = Tables.getcolumn(table₁, :b)
    codacol₂   = Tables.getcolumn(table₂, :b)
    multiclass = Tables.getcolumn(table₃, :a)
    ordered    = Tables.getcolumn(table₃, :b)
  
    # column normalization
    D₁ = pairwise(TableDistance(normalize=true), table₁, table₂)
    D₂ = pairwise(TableDistance(normalize=false), table₁, table₂)
    D₃ = 0.5*pairwise(Euclidean(), euclidcol₁, euclidcol₂) +
         0.5*pairwise(CoDaDistance(), codacol₁, codacol₂)
    @test sum(D₁ .≤ D₂) > 4*6/2
    @test D₂ ≈ D₃

    # non-uniform weights
    D₁ = pairwise(TableDistance(normalize=false, weights=Dict(:a => 2., :b => 8.)), table₁, table₂)
    D₂ = 0.2*pairwise(Euclidean(), euclidcol₁, euclidcol₂) +
         0.8*pairwise(CoDaDistance(), codacol₁, codacol₂)
    @test D₁ ≈ D₂

    # pairwise with single table
    D₁ = pairwise(TableDistance(normalize=false), table₁)
    D₂ = 0.5*pairwise(Euclidean(), euclidcol₁) +
         0.5*pairwise(CoDaDistance(), codacol₁)
    @test D₁ ≈ D₂

    # pairwise with multiclass and ordered factor
    table₃ = coerce(table₃, :a => Multiclass, :b => OrderedFactor)
    D₁ = pairwise(TableDistance(normalize=false), table₃)
    D₂ = 0.5*pairwise(TableDistances.MulticlassDistance(), multiclass) +
         0.5*pairwise(TableDistances.OrderedFactorDistance(), ordered)
    @test D₁ ≈ D₂
  end
end