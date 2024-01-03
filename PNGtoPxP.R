#Converting Cross-Section to Pixsets

# Load libraries
library(EBImage)

#Reading images
imageFiles <- list.files('C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/PNG Cross Sections', full.names = TRUE)

#Convert images to matricies
imageMatricies <- readImage(imageFiles)

#Change to grayscale
imageMatricies <- channel(imageMatricies, "gray")
#imageMatricies <- apply(imageMatricies, 2, rev)

#Function to subset a matrix into x by y matrices
matrixSplitter <- function (M, r, c)
{
  simplify2array (lapply (split (M, interaction ((row (M) - 1) %/% r + 1,(col (M) - 1) %/% c + 1)),
  function(x) {dim(x) <- c(r,c); x;}))
} 

splitMatricies <- list();

for (i in 1:70)
{
  splitMatricies[[i]] <- matrixSplitter(imageMatricies[,,i], 48, 48)
  
}

#Initializing For loop Variables
blackcounter = 0 #To see how many black pixels are in each 
setwd("C:/Users/young/OneDrive/Documents/University/UH/Fall 2018/Math 4397/Final Project/LiDAR Project/Noise Free Subsections")

for(i in 1:70)
{
  for (j in 1:100)
  {
    for (k in 1:48)
    {
      for (l in 1:48)
      {
        if (splitMatricies[[i]][l,k,j] == 0)
        {
          blackcounter = blackcounter + 1
        }
      }
    }
    
    if (blackcounter > 20)
    {
      png (paste0 ("subsection_", i,"_", j, ".png", sep = ""))    
      par (mar = c(0,0,0,0))
      image(splitMatricies[[i]][,,j], axes = FALSE, col = grey (seq (0, 1, length = 256)))
      dev.off()
    }
    
    blackcounter = 0
  }
}

