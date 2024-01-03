#Load in Relevant Libraries
library(EBImage)

yesTreeList <- list.files('C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/1', full.names = FALSE)
noTreeList <-list.files('C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/0', full.names = FALSE)

TreeListNames <- append(yesTreeList, noTreeList) 

rand_treeListNames <- sample(TreeListNames)

library(dplyr)
library(ggplot2)
treeList <- as.data.frame(rand_treeListNames)
treeList$label <- NA #blank column 

colnames(treeList)[1] <- "Subsection"

testTree = head(treeList, 511)
trainTree <- treeList[512:961, 1]
trainTree <-as.data.frame(trainTree)
trainTree$label <- NA #blank column 

write.csv(treeList, "TestandTrainLabels.csv")
write.csv(trainTree, "trainTree.csv")
write.csv(testTree, "test.csv")

