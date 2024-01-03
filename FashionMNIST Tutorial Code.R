##Basic Classification for Convolutional NN

#Load Library Keras
library(keras)

#Attaching the Fashion MNIST data. 28x28 pixel count
fashion_mnist <- dataset_fashion_mnist()

c(train_images, train_labels) %<-% fashion_mnist$train
c(test_images, test_labels) %<-% fashion_mnist$test

#Mapping an image to a single label
class_names = c('Tshirt/top', 'Trouser', 'Pullover', 'Dress',
                'Coat', 'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot')

#Exploring the data
dim(train_images)

dim(train_labels)

train_labels[1:20]

dim(test_images)

dim(test_labels)

##Preprocessing the data
library(tidyr)
library(ggplot2)

#Creates sample
image_1 <- as.data.frame(train_images[1, , ])
colnames(image_1) <- seq_len(ncol(image_1))
image_1$y <- seq_len(nrow(image_1))
image_1 <- gather(image_1, "x", "value", -y)
image_1$x <- as.integer(image_1$x)

ggplot(image_1, aes(x = x, y = y, fill = value)) + geom_tile() +
  scale_fill_gradient(low ="white", high ="black", na.value=NA) +
  scale_y_reverse() + theme_minimal() + theme(panel.grid = element_blank())+
  theme(aspect.ratio = 1) + xlab("") +ylab("")

#IMPORTANT THAT THESE VALUES HAVE A RANGE OF 0 TO 1
train_images <- train_images/255
test_images <- test_images/255

#Displays first 25 images from training set and class name below each. 
#This is to verify that the data is in correct format
par(mfcol=c(5,5))
par(mar=c(0, 0, 1.5, 0), xaxs='i', yaxs='i')

for(i in 1:25){
  
  img <- train_images[i, , ]
  img <- t(apply(img, 2, rev))
  image(1:28, 1:28, img, col = gray((0:255)/255), xaxt='n', yaxt='n',
        main=paste(class_names[train_labels[i]+1]))
  
}

#Setup the layers
model <- keras_model_sequential()
model %>%
  layer_flatten(input_shape = c(28,28)) %>%
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dense(units = 10, activation = 'softmax')
  
#Compiling the Model
model %>% compile(
  
  optimizer = 'adam',
  loss = 'sparse_categorical_crossentropy',
  metrics = c('accuracy')
  
)
  
#TRAINing THE MODEL
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
model %>% fit(train_images, train_labels, epochs = 5)

#Evaluating Accuracy
score <- model %>% evaluate(test_images, test_labels)

cat('Test loss:', score$loss, "\n")
cat('Test accuracy:', score$acc, "\n")

#Resulted in worse test accuracy = overfitted model

##Make Predictions******
predictions <- model %>% predict(test_images)
predictions[1, ]

which.max(predictions[1, ])

class_pred <- model %>% predict_classes(test_images)
class_pred[1:20]

test_labels[1]

par(mfcol=c(5,5))
par(mar=c(0, 0, 1.5, 0), xaxs='i', yaxs='i')

for(i in 1:25){
  
  img <- test_images[i, , ]
  img <- t(apply(img, 2, rev))
  #subtract 1 as labels from 0 to 9
  predicted_label <- which.max(predictions[i,]) - 1
  true_label <- test_labels[i]
  
  if(predicted_label == true_label){
    color <- '#008800'
  } else {
    color <- '#bb0000'
  }
  image(1:28, 1:28, img, col=gray((0:255)/255), xaxt = 'n', yaxt ='n',
        main = paste0(class_names[predicted_label +1], " (", 
                      class_names[true_label +1], ")"), 
        col.main = color)
  
}

#Using trained model to make a prediction about a single image.
#Grabs an image from test dataset
#Take care to keep the batch dimenson, as this is expected by the model

img <- test_images[1, , , drop = FALSE]
dim(img)

predictions <- model %>% predict(img)
predictions

#Subtract 1 as labels are 0-based
prediction <- predictions[1, ] - 1
which.max(prediction)

#Directly getting the class prediction again:
class_pred <- model %>% predict_classes(img)
class_pred








  
  
  
  