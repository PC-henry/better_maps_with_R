

# Simplify map for visualisation/publication 

cmplx_size <- object.size(shape)
shape      <- ms_simplify(shape)
simpl_size <- object.size(shape)

message(
  simpl_size / cmplx_size, " of original size"
)




# Communication

for_report <- 