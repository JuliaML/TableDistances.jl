using TableDistances
using Tables
using Test
using CoDa
using Distances
using ScientificTypes

@testset "TableDistances.jl" begin
  table₁ = (a = rand(4), b = rand(Composition{5}, 4))
  table₂ = (a = rand(6), b = rand(Composition{5}, 6))

  @testset "Normalization" begin
    t₁ = TableDistances.normalize(table₁)
    t₂ = TableDistances.normalize(table₂)

    @test Tables.getcolumn(t₁, :a) == TableDistances.default_normalization(Continuous)(Tables.getcolumn(table₁, :a))
    @test Tables.getcolumn(t₁, :b) == TableDistances.default_normalization(Compositional)(Tables.getcolumn(table₁, :b))
    @test Tables.getcolumn(t₂, :a) == TableDistances.default_normalization(Continuous)(Tables.getcolumn(table₂, :a))
    @test Tables.getcolumn(t₂, :b) == TableDistances.default_normalization(Compositional)(Tables.getcolumn(table₂, :b))
  end

  @testset "Pairwise" begin
    t₁ = TableDistances.normalize(table₁)
    t₂ = TableDistances.normalize(table₂)

    euclidcol₁ = Tables.getcolumn(t₁, :a)
    euclidcol₂ = Tables.getcolumn(t₂, :a)
  
    codacol₁ = Tables.getcolumn(t₁, :b)
    codacol₂ = Tables.getcolumn(t₂, :b)
  
    P₁ = pairwise(TableDistance(), table₁, table₂)
    P₂ = pairwise(Euclidean(), euclidcol₁, euclidcol₂) + pairwise(CoDaDistance(), codacol₁, codacol₂)
  
    @test P₁ ≈ P₂
  end
  
end