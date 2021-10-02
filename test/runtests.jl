using TableDistances
using Tables
using Test
using CoDa
using Distances
using ScientificTypes

@testset "TableDistances.jl" begin
  t₁ = (a = rand(4), b = rand(Composition{5}, 4))
  t₂ = (a = rand(6), b = rand(Composition{5}, 6))

  table₁ = TableDistances.normalize(t₁)
  table₂ = TableDistances.normalize(t₂)

  @test Tables.getcolumn(table₁, :a) == TableDistances.default_normalization(Continuous)(Tables.getcolumn(t₁, :a))
  @test Tables.getcolumn(table₁, :b) == TableDistances.default_normalization(Compositional)(Tables.getcolumn(t₁, :b))
  @test Tables.getcolumn(table₂, :a) == TableDistances.default_normalization(Continuous)(Tables.getcolumn(t₂, :a))
  @test Tables.getcolumn(table₂, :b) == TableDistances.default_normalization(Compositional)(Tables.getcolumn(t₂, :b))

  euclidcol₁ = Tables.getcolumn(table₁, :a)
  euclidcol₂ = Tables.getcolumn(table₂, :a)

  codacol₁ = Tables.getcolumn(table₁, :b)
  codacol₂ = Tables.getcolumn(table₂, :b)

  P₁ = pairwise(TableDistance(), table₁, table₂)
  P₂ = pairwise(Euclidean(), euclidcol₁, euclidcol₂) + pairwise(CoDaDistance(), codacol₁, codacol₂)

  @test P₁ ≈ P₂
end