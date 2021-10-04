using TableDistances
using Tables
using Test
using CoDa
using Distances
using ScientificTypes

@testset "TableDistances.jl" begin
  @testset "Pairwise" begin
    table₁ = (a = rand(4), b = rand(Composition{5}, 4))
    table₂ = (a = rand(6), b = rand(Composition{5}, 6))

    euclidcol₁ = Tables.getcolumn(table₁, :a)
    euclidcol₂ = Tables.getcolumn(table₂, :a)
  
    codacol₁ = Tables.getcolumn(table₁, :b)
    codacol₂ = Tables.getcolumn(table₂, :b)
  
    D₁ = pairwise(TableDistance(normalize=true), table₁, table₂)
    D₂ = pairwise(TableDistance(normalize=false), table₁, table₂)
    D₃ = 0.5*pairwise(Euclidean(), euclidcol₁, euclidcol₂) +
         0.5*pairwise(CoDaDistance(), codacol₁, codacol₂)
    D₄ = pairwise(TableDistance(normalize=false, weights=Dict(:a => 2., :b => 8.)), table₁, table₂)
    D₅ = 0.2*pairwise(Euclidean(), euclidcol₁, euclidcol₂) +
         0.8*pairwise(CoDaDistance(), codacol₁, codacol₂)
    @test sum(D₁ .≤ D₂) > 4*6/2
    @test D₂ ≈ D₃
    @test D₄ ≈ D₅
  end
end