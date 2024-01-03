library(keras)
library(EBImage)


#setwd('C:/Users/USER/Desktop/Final Project/Data Frames')

load_LiDAR <- function()
{
  load_image_file <- function(filename) 
  {
    ret = list()
    f = file(filename,'rb')
    readBin(f,'integer',n=1,size=4,endian='big')
    ret$n = readBin(f,'integer',n=1,size=4,endian='big')
    nrow = readBin(f,'integer',n=1,size=4,endian='big')
    ncol = readBin(f,'integer',n=1,size=4,endian='big')
    x = readBin(f,'integer',n=ret$n*nrow*ncol,size=1,signed=F)
    ret$x = matrix(x, ncol=nrow*ncol, byrow=T)
    close(f)
    ret
  }
  load_label_file <- function(filename) 
  {
    f = file(filename,'rb')
    readBin(f,'integer',n=1,size=4,endian='big')
    n = readBin(f,'integer',n=1,size=4,endian='big')
    y = readBin(f,'integer',n=n,size=1,signed=F)
    close(f)
    y
  }
  train <<- load_image_file('C:/Users/USER/Desktop/Final Project/Data Frames/48x48 ubyte MNIST Data Frame/train-images-idx3-ubyte')
  test <<- load_image_file('C:/Users/USER/Desktop/Final Project/Data Frames/48x48 ubyte MNIST Data Frame/test-images-idx3-ubyte')
  
  train$y <<- load_label_file('C:/Users/USER/Desktop/Final Project/Data Frames/48x48 ubyte MNIST Data Frame/train-labels-idx1-ubyte')
  test$y <<- load_label_file('C:/Users/USER/Desktop/Final Project/Data Frames/48x48 ubyte MNIST Data Frame/test-labels-idx1-ubyte') 
}

#Using the function, load in our LiDAR Dataframe
LiDAR <- load_LiDAR()

batch_size <- 128
num_classes <- 2
epochs <- 100

#Input Image Dimensions
img_rows <- 48
img_cols <- 48

#Remove Column n
train$n <- NULL
test$n <- NULL


#Convert list into 1d array
train$y <- as.array(train$y)
test$y <- as.array(test$y)

#Data Pre-Processing
x_train <- train$x
y_train <- train$y
x_test <- test$x
y_test <- test$y

#Redefine Dimension of train/test inputs
x_train <- array_reshape(x_train, c(nrow(x_train), img_rows, img_cols, 1))
x_test <- array_reshape(x_test, c(nrow(x_test), img_rows, img_cols, 1))
input_shape <- c(img_rows, img_cols, 1)

#Transform RGB values into [0,1] range
x_train <- x_train/255
x_test <- x_test/255

c('x_train_shape:', dim(x_train), '\n')
cat(nrow(x_train), 'train samples\n')
cat(nrow(x_test), 'test samples \n')

#Convert Class vectors to binary class matrices

y_train <- to_categorical(y_train, num_classes)
y_test <- to_categorical(y_test, num_classes)

#Initialize the Model
CNNmodel <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3,3), activation = 'relu', #Filtering through matrixes 
                input_shape = input_shape) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3,3), activation = 'relu') %>% #Filtering through more matrixes
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  layer_dropout(rate = 0.25) %>%
  layer_flatten()%>%
  layer_dense(units = 200, activation = 'relu') %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = num_classes, activation = 'softmax')
  
#Compile the Model
CNNmodel %>% compile(
  loss = loss_categorical_crossentropy,
  optimizer = optimizer_adadelta(),
  metrics = c('accuracy')
)

#Train the Model
#model %>% fit(
  #x_train, y_train,
  #batch_size = batch_size,
  #epochs = epochs,
  #validation_split = 0.2
#)

early_stop <- callback_early_stopping(monitor = "val_loss", 
                                      patience = 20)

history <- fit(CNNmodel, 
               x_train, 
               y_train,
               validation_split = 0.2, batch_size = batch_size,
               epochs = epochs,
               callbacks = list(early_stop))


plot(history, smooth = F)
scores <- CNNmodel %>% evaluate(x_test, y_test, verbose = 0)

scores


par(mfrow = c(2,2))
class_names <- c("No Tree", "Tree" )


plot(as.cimg(t(x_train[10,,,1])),
     main=paste("Label:", class_names[y_train[10]+1]))
plot(as.cimg(t(x_train[20,,,1])),
     main=paste("Label:", class_names[y_train[20]+1]))
plot(as.cimg(t(x_train[30,,,1])),
     main=paste("Label:", class_names[y_train[30]+1]))
plot(as.cimg(t(x_train[100,,,1])),
     main=paste("Label:", class_names[y_train[100]+1]))












