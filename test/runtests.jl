using TableDistances
using CategoricalArrays
using Distances
using Tables
using CoDa
using Test

@testset "TableDistances.jl" begin
  @testset "Pairwise" begin
    # test data
    table₁ = (a = rand(4), b = rand(Composition{5}, 4))
    table₂ = (a = rand(6), b = rand(Composition{5}, 6))
    table₃ = (a = ["a", "b", "a", "c"], b = [1, 4, 1, 5])
    table₄ = (a = categorical(table₃.a), b = categorical(table₃.b))
    table₅ = (a = categorical(table₃.a, ordered=true), b = categorical(table₃.b, ordered=true))

    # specific columns
    euclidcol₁ = Tables.getcolumn(table₁, :a)
    euclidcol₂ = Tables.getcolumn(table₂, :a)
    codacol₁   = Tables.getcolumn(table₁, :b)
    codacol₂   = Tables.getcolumn(table₂, :b)

    # column normalization
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

    # unordered categorical
    D = [
      0.0  1.0  0.0  1.0
      1.0  0.0  1.0  1.0
      0.0  1.0  0.0  1.0
      1.0  1.0  1.0  0.0
    ]
    @test pairwise(TableDistance(), table₃) == pairwise(TableDistance(), table₄) == D

    # ordered categorical
    D = [
      0.0  1.0  0.0  2.0
      1.0  0.0  1.0  1.0
      0.0  1.0  0.0  2.0
      2.0  1.0  2.0  0.0
    ]
    @test pairwise(TableDistance(), table₅) == D
  end
end