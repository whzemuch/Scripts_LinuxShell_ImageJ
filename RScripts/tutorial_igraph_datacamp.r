# igraph tutorial
# Source: https://campus.datacamp.com/courses/network-analysis-in-r/introduction-to-networks-1?ex=5


# Creating an igraph object==================================

# Load igraph
library(igraph)

# Inspect the first few rows of the dataframe 'friends'
head(friends)

# Convert friends dataframe to a matrix
friends.mat <- as.matrix(friends)
print("==============")
head(friends.mat)
print("==============")
# Convert friends matrix to an igraph object
g <- graph.edgelist(friends.mat, directed = FALSE)

# Make a very basic plot of the network
plot(g)

# alternative:  using dataframe ertices.df(namee, age)  edges.df(from, to, frenquency)

graph_from_data_frame(d = edges.df, vertices = vertices.df, directed = FALSE)


# Counting vertices and edges====================================

# Load igraph
library(igraph)

# Subset vertices and edges
V(g)
E(g)

# Count number of edges
gsize(g)

# Count number of vertices
gorder(g)



# Node attributes and subsetting================================

library(igraph)

# Inspect the objects 'genders' and 'ages'
genders
ages

# Create new vertex attribute called 'gender'
g <- set_vertex_attr(g, "gender", value = genders)

# Create new vertex attribute called 'age'
g <- set_vertex_attr(g, "age", value = ages)

# View all vertex attributes in a list
V(g)
vertex_attr(g)
# View attributes of first five vertices in a dataframe
V(g)[[1:5]] 

# Edge attributes and subsetting================================

library(igraph)

# View hours
hours

# Create new edge attribute called 'hours'
g <- set_edge_attr(g, "hours", value = hours)

# View edge attributes of graph object
edge_attr(g)

# Find all edges that include "Britt"
E(g)[[inc('Britt')]]  

# Find all pairs that spend 4 or more hours together per week
E(g)[[hours>= 4]]  


# Visualizing attributes=====================================

library(igraph)

# Create an igraph object with attributes directly from dataframes
g1 <- graph_from_data_frame(d = friends1_edges, vertices = friends1_nodes, directed = FALSE)


# Subset edges greater than or equal to 5 hours
E(g1)[[hours >= 5]]  

# Set vertex color by gender
V(g1)$color <- ifelse(V(g1)$gender == "F", "orange", "dodgerblue")

# Plot the graph
plot(g1, vertex.label.color = "black")

# igraph network layouts =================================================

# igraph layouts  circle, fruchterman-reingold, kamada-kawai, grid, lgl, tree
library(igraph)

# Plot the graph object g1 in a circle layout
plot(g1, vertex.label.color = "black", layout = layout_in_circle(g1))

# Plot the graph object g1 in a Fruchterman-Reingold layout 
plot(g1, vertex.label.color = "black", layout = layout_with_fr(g1))

# Plot the graph object g1 in a Tree layout 
m <- layout_as_tree(g1)
plot(g1, vertex.label.color = "black", layout = m)

# Visualizing edges=========================================================

library(igraph)

# Create a vector of weights based on the number of hours each pair spend together
w1 <- E(g1)$hours

# Plot the network varying edges by weights
m1 <- layout_nicely(g1)
plot(g1, 
        vertex.label.color = "black", 
        edge.color = 'black',
        edge.width = w1,
        layout = m1)


# Create a new igraph object by deleting edges that are less than 2 hours long 
g2 <- delete_edges(g1, E(g1)[hours < 2])


# Plot the new graph 
w2 <- E(g2)$hours
m2 <- layout_nicely(g2)

plot(g2, 
     vertex.label.color = "black", 
     edge.color = 'black',
     edge.width = w2,
     layout = m2)
	

#  ====================================================================
