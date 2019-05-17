
import argparse
import os
import pickle
import random

import cv2
import numpy as np
from imutils import paths
from keras.optimizers import Adam
from keras.preprocessing.image import ImageDataGenerator
from keras.preprocessing.image import img_to_array
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelBinarizer

from model import ImageClassifier

# Defining Constants EPOCHS: epochs is the number of iterations we want to run over the dataset
# INITIAL_LEARNING_RATE: Intail learning rate is required by the optimisation algorith and it is contantly updated
# over and over each epch BATCH_SIZE: Specifies how many images must be taken for training each time
# IMAGE_DIMENSIONS: Specifies the height, width and depth of each image
EPOCHS = 500
INITIAL_LEARNING_RATE = 1e-3
BATCH_SIZE = 32
IMAGE_DIMENSIONS = (96, 96, 3)

data = []
class_labels = []

# Building an argument parser that will enable us to specify all the requirements by using the terminal window
# -d --dataset: It is used to specify the path to the dataset folder from where the images will be parsed
# -m --model: It is used to specify the path where the output model will be saved
# -l --labelbin: It is used to specify the path where the output model will be saved
argument_parser = argparse.ArgumentParser()
argument_parser.add_argument("-d", "--dataset",
                             required=True,
                             help="path to input dataset (i.e., directory of images)")
argument_parser.add_argument("-m", "--model",
                             required=True,
                             help="path to output model")
argument_parser.add_argument("-l", "--labelbin",
                             required=True,
                             help="path to output label binariser")
# saving the argument parser in the form of a variable
parser = vars(argument_parser.parse_args())

# Loading the images from the argument passed as -d --dataset
print("Loading Images ......")
image_paths = sorted(list(paths.list_images(parser["dataset"])))
#  https://stackoverflow.com/questions/22639587/random-seed-what-does-it-do
#  Randomising the image paths so that the model is forced to learn about images rather than memorising them
#  Before they are randomised they are seeded first.
random.seed(42)
random.shuffle(image_paths)
# reading the image paths and resizing them to fit the specified dimensions
for path in image_paths:
    image = cv2.imread(path)
    image = cv2.resize(image, (IMAGE_DIMENSIONS[0], IMAGE_DIMENSIONS[1]))
    image = img_to_array(image)
    data.append(image)

    class_label = path.split(os.path.sep)[-2]
    class_labels.append(class_label)

data = np.array(data, dtype="float") / 255.0
class_labels = np.array(class_labels)

# https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html
lb = LabelBinarizer()
class_labels = lb.fit_transform(class_labels)

(trainX, testX, trainY, testY) = train_test_split(data,
                                                  class_labels,
                                                  test_size=0.2,
                                                  random_state=42)

# Because the dataset is limited thus we use image data generator to multiply the given images
image_augmentation_generator = ImageDataGenerator(rotation_range=25,
                                                  width_shift_range=0.1,
                                                  height_shift_range=0.1,
                                                  shear_range=0.2,
                                                  zoom_range=0.2,
                                                  horizontal_flip=True,
                                                  fill_mode="nearest")

# Compiling the model using the image classifier class
# ImageClassifier:
#   builder: It is used to build the neural network.
#     parameters:
#       height: height of the given image
#       width:  width of the given image
#       depth:  depth of the given image
#       classes: classes in which the object might be classified
#     returns:
#       A constructed neural network with a number of layers
print("Compiling the Model......")
model = ImageClassifier.builder(height=IMAGE_DIMENSIONS[0],
                                width=IMAGE_DIMENSIONS[1],
                                depth=IMAGE_DIMENSIONS[2],
                                classes=len(lb.classes_))
# Specifying the optimiser that would be used for this algorithm
# Adam: The optimising algorithm that we are planning to use to train the model
#   parameters:
#       lr: initial learning rate of the algorithm. It is specified using INITIAL_LEARNING_RATE constant
#       decay: decay rate of the algorithm. It is calculated using the formula INITIAL_LEARNING_RATE / EPOCHS
optimiser = Adam(lr=INITIAL_LEARNING_RATE, decay=INITIAL_LEARNING_RATE / EPOCHS)
# Compiling the model using the inbuilt .complie function
#   compile: Compile the given model using an optimiser,
#   loss function, and specifying the metrics that we want to determine
#       loss: loss function for the algorithm
#       optimizer: the optimiser that we defined in the last step of code
#       metrics: the metrics that we want to determine
model.compile(loss="categorical_crossentropy",
              optimizer=optimiser,
              metrics=["accuracy"])

# fitting the model to the given dataset
# fit_generator: inbuilt function used to train the model. Trains the model on
#   data generated batch-by-batch by a Python generator. This allows you to do real-time data augmentation on images on
#   CPU in parallel to training your model on GPU.
#   generator: A generator or an instance of Sequence (keras.utils.Sequence)
#       object in order to avoid duplicate data when using multiprocessing.
#       It must be a tuple of type (input, target, sample_weights)
#   steps_per_epoc: Total number of steps (batches of samples) to yield from generator
#       before declaring one epoch finished and starting the next epoch
#   validation_data: data on which to evaluate the loss and any model metrics at the end of each epoch.
#       The model will not be trained on this data. it is of the form of a tuple.
#   epochs: number of epochs the model needs to be trained for
#   verbose: to specify if an output is needed.
#       if 0: Silent
#       if 1: progress bar
#       if 2: one line per epoch
print("Starting Training......")
model.fit_generator(image_augmentation_generator.flow(trainX, trainY, batch_size=BATCH_SIZE),
                    validation_data=(testX, testY), steps_per_epoch=len(trainX) // BATCH_SIZE,
                    epochs=EPOCHS, verbose=1)
# Saving the model on a user specified path
print("Saving Model......")
model.save(parser["model"])
# Saving the label binaries on a user specified path
print("Saving label binaries to disk")
f = open(parser["labelbin"], "wb")
f.write(pickle.dumps(lb))
f.close()
