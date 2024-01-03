setwd('C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/train')

inputFile <-  read.csv("C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/trainTree.csv",header=T)
for(i in 1:nrow(inputFile)) 
{ 
  filePathFrom <- paste("C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final ProjectLiDAR Project/Organized Subsections_1",inputFile[i,1],sep="")
  filePathTo <- paste("C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/train",inputFile[i,1],sep="")  
  cat(" file exist= ",file.exists(filePathFrom)," ",filePathFrom)
  success<-file.copy(from = filePathFrom,  to = filePathTo)
  cat (" Copied = ", success, "\n")
}
