using TableDistances
using Tables
using Test
using CoDa
import Distances: Euclidean

@testset "TableDistances.jl" begin
  table₁ = (a = rand(4), b = rand(Composition{5}, 4))
  table₂ = (a = rand(6), b = rand(Composition{5}, 6))

  distance₁ = Euclidean()
  distance₂ = CoDaDistance()

  euclidcol₁ = Tables.getcolumn(table₁, :a)
  euclidcol₂ = Tables.getcolumn(table₂, :a)

  codacol₁ = Tables.getcolumn(table₁, :b)
  codacol₂ = Tables.getcolumn(table₂, :b)

  P₁ = pairwise(TableDistance(), table₁, table₂)
  P₂ = [distance₁(euclidcol₁[i], euclidcol₂[j]) + distance₂(codacol₁[i], codacol₂[j]) for i in 1:4, j in 1:6]

  @test P₁ ≈ P₂
end