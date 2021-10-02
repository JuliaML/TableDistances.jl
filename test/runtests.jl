using TableDistances
using Tables
using Test
using CoDa
using Distances

@testset "TableDistances.jl" begin
  table₁ = (a = rand(4), b = rand(Composition{5}, 4))
  table₂ = (a = rand(6), b = rand(Composition{5}, 6))

  euclidcol₁ = Tables.getcolumn(table₁, :a)
  euclidcol₂ = Tables.getcolumn(table₂, :a)

  codacol₁ = Tables.getcolumn(table₁, :b)
  codacol₂ = Tables.getcolumn(table₂, :b)

  P₁ = pairwise(TableDistance(), table₁, table₂)
  P₂ = pairwise(Euclidean(), euclidcol₁, euclidcol₂) + pairwise(CoDaDistance(), codacol₁, codacol₂)

  @test P₁ ≈ P₂
end