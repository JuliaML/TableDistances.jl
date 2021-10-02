using TableDistances
using Tables
using Test
using CoDa
using Distances
using ScientificTypes

@testset "TableDistances.jl" begin
  # Testing default normalization
  tᵦ = (a = rand(4), b = rand(Composition{5}, 4))
  tᵧ = (a = rand(6), b = rand(Composition{5}, 6))

  tableᵦ = TableDistances.normalize(tᵦ)
  tableᵧ = TableDistances.normalize(tᵧ)

  @test Tables.getcolumn(tableᵦ, :a) == TableDistances.default_normalization(Continuous)(Tables.getcolumn(tᵦ, :a))
  @test Tables.getcolumn(tableᵦ, :b) == TableDistances.default_normalization(Compositional)(Tables.getcolumn(tᵦ, :b))
  @test Tables.getcolumn(tableᵧ, :a) == TableDistances.default_normalization(Continuous)(Tables.getcolumn(tᵧ, :a))
  @test Tables.getcolumn(tableᵧ, :b) == TableDistances.default_normalization(Compositional)(Tables.getcolumn(tᵧ, :b))

  # Testing table distance pairwise with normalization
  table₁ = TableDistances.normalize((a = rand(4), b = rand(Composition{5}, 4)))
  table₂ = TableDistances.normalize((a = rand(6), b = rand(Composition{5}, 6)))

  euclidcol₁ = Tables.getcolumn(table₁, :a)
  euclidcol₂ = Tables.getcolumn(table₂, :a)

  codacol₁ = Tables.getcolumn(table₁, :b)
  codacol₂ = Tables.getcolumn(table₂, :b)

  P₁ = pairwise(TableDistance(), table₁, table₂)
  P₂ = pairwise(Euclidean(), euclidcol₁, euclidcol₂) + pairwise(CoDaDistance(), codacol₁, codacol₂)

  @test P₁ ≈ P₂
end