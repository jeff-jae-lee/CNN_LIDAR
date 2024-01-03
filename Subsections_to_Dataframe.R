#Adding the images to a data.frame

#Load in EBImage
library(EBImage)

#Put Subsectiosn into a list. When using your laptop use Users/USER!!!!
treeList <- list.files('C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/Organized Subsections_1/', full.names = TRUE) 
yesTreeList <- list.files('C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/1', full.names = TRUE) 
noTreeList <- list.files('C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/0', full.names = TRUE) 

#Resizing Images and Reorganizing
yesTreeMatricies <- readImage(yesTreeList)
noTreeMatricies <-readImage(noTreeList)

yesTreeMatricies <-channel(yesTreeMatricies, "gray")
noTreeMatricies <-channel(noTreeMatricies, "gray")

yesTreeMatriciesResized <- resize(yesTreeMatricies, w = 48, h = 48)
noTreeMatriciesResized <- resize(noTreeMatricies, w = 48, h = 48)

setwd('C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/1_1')
for (i in 1:450)
{
  png (paste0 ("Tree.", i, ".png", sep = ""))    
  par (mar = c(0,0,0,0))
  image(yesTreeMatriciesResized[,,i], axes = FALSE, col = grey (seq (0, 1, length = 256)))
  dev.off()
}
