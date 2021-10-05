# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

function default_weights(table)
  cols = Tables.columnnames(table)
  n = length(cols)
  Dict(cols .=> fill(1/n, n))
end
