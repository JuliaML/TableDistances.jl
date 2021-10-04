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
  
    D₁ = pairwise(TableDistance(weights=Dict(:a => 1.0, :b => 1.0), normalize=true), table₁, table₂)
    D₂ = pairwise(TableDistance(weights=Dict(:a => 1.0, :b => 1.0), normalize=false), table₁, table₂)
    D₃ = pairwise(Euclidean(), euclidcol₁, euclidcol₂) +
         pairwise(CoDaDistance(), codacol₁, codacol₂)
    @test sum(D₁ .≤ D₂) > 4*6/2
    @test D₂ ≈ D₃
  end
end