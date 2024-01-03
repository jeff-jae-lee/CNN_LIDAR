# R Script to convert cross section point cloud to PNG


# Set file location


png (filename = "~/slice_9.png")

par (mar = c(0,0,0,0))
plot (V1,V3, type = "p", asp = 1, pch = ".", cex = 1, axes = 0, xaxs = "i", yaxs = "i")
dev.off ()


setwd("C:/Users/USER/Desktop/Cross Sections/")
ldf <- list() # creates a list0
listtxt <- dir(pattern = "*.txt") # creates the list of all the txt files in the directory
for (k in 1:length(listtxt)){
  ldf[[k]] <- read.delim(listtxt[k],header = F,sep = ",")
}



for(j in 1:length(ldf)){
  
  attach(ldf[[j]])
  setwd("C:/Users/USER/Desktop/CSPNG/")
  png(paste0("slice_",j, ".png", sep = ""))
  
  par (mar = c(0,0,0,0))
  plot (V1,V3, type = "p", asp = 1, pch = ".", cex = 1, axes = 0, xaxs = "i", yaxs = "i")
  
  dev.off ()
  detach(ldf[[j]])
}
q
