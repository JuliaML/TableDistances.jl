using TableDistances
using CategoricalArrays
using Distances
using Tables
using ColorTypes
using CoDa
using Test

@testset "TableDistances.jl" begin
  @testset "Pairwise" begin
    # compositional data
    table₁ = (a = rand(4), b = rand(Composition{5}, 4))
    table₂ = (a = rand(6), b = rand(Composition{5}, 6))
    euclidcol₁ = Tables.getcolumn(table₁, :a)
    euclidcol₂ = Tables.getcolumn(table₂, :a)
    codacol₁   = Tables.getcolumn(table₁, :b)
    codacol₂   = Tables.getcolumn(table₂, :b)
    D₁ = pairwise(TableDistance(normalize=true), table₁, table₂)
    D₂ = pairwise(TableDistance(normalize=false), table₁, table₂)
    D₃ = 0.5*pairwise(Euclidean(), euclidcol₁, euclidcol₂) +
         0.5*pairwise(Aitchison(), codacol₁, codacol₂)
    @test sum(D₁ .≤ D₂) > 4*6/2
    @test D₂ ≈ D₃

    # non-uniform weights
    D₁ = pairwise(TableDistance(normalize=false, weights=Dict(:a => 2., :b => 8.)), table₁, table₂)
    D₂ = 0.2*pairwise(Euclidean(), euclidcol₁, euclidcol₂) +
         0.8*pairwise(Aitchison(), codacol₁, codacol₂)
    @test D₁ ≈ D₂

    # pairwise with single table
    D₁ = pairwise(TableDistance(normalize=false), table₁)
    D₂ = 0.5*pairwise(Euclidean(), euclidcol₁) +
         0.5*pairwise(Aitchison(), codacol₁)
    @test D₁ ≈ D₂

    # unordered categorical values
    table₁ = (a = ["a", "b", "a", "c"], b = [1, 4, 1, 5])
    table₂ = (a = categorical(table₁.a), b = categorical(table₁.b))
    table₃ = (a = categorical(table₁.a, ordered=true), b = categorical(table₁.b, ordered=true))
    D = [
      0.0  1.0  0.0  1.0
      1.0  0.0  1.0  1.0
      0.0  1.0  0.0  1.0
      1.0  1.0  1.0  0.0
    ]
    @test pairwise(TableDistance(), table₁) == pairwise(TableDistance(), table₂) == D

    # ordered categorical values
    D = [
      0.0  1.0  0.0  2.0
      1.0  0.0  1.0  1.0
      0.0  1.0  0.0  2.0
      2.0  1.0  2.0  0.0
    ]
    @test pairwise(TableDistance(), table₃) == D
  end
end