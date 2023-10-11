# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

function default_weights(table)
  cols = Tables.columns(table)
  names = Tables.columnnames(cols)
  n = length(names)
  Dict(nm => 1/n for nm in names)
end
