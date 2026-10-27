if (!require(igraph)) install.packages("igraph")
library(igraph)

g <- graph_from_literal(A-B, A-C, B-C, C-D, D-E, D-F, E-F, F-G, G-H, G-I, H-I)
plot(g, main = "Original Graph", vertex.color = "lightblue", vertex.size = 30)

g_copy <- g
step <- 1
while (components(g_copy)$no < 3) {
  eb <- edge_betweenness(g_copy)
  max_edge <- which.max(eb)
  cat("Step", step, ": removing edge", as_ids(E(g_copy)[max_edge]),
      "with betweenness", eb[max_edge], "\n")
  g_copy <- delete_edges(g_copy, max_edge)
  step <- step + 1
}
print(split(V(g_copy)$name, components(g_copy)$membership))

communities <- cluster_edge_betweenness(g)
print(communities)
cat("Number of communities:", length(communities), "\n")
cat("Modularity:", modularity(communities), "\n")
print(membership(communities))
plot(communities, g, main = "Girvan-Newman Communities")

karate <- make_graph("Zachary")
karate_comm <- cluster_edge_betweenness(karate)
cat("Karate club communities:", length(karate_comm), " Modularity:", modularity(karate_comm), "\n")
plot(karate_comm, karate, main = "Zachary Karate Club - Girvan-Newman")
dendPlot(karate_comm, mode = "hclust", main = "Dendrogram")
