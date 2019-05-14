import argparse
import os
import pickle
import random

import cv2
import matplotlib
import numpy as np
from imutils import paths
from keras.optimizers import Adam
from keras.preprocessing.image import ImageDataGenerator
from keras.preprocessing.image import img_to_array
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelBinarizer

from model import ImageClassifier

EPOCHS = 100
INITIAL_LEARNING_RATE = 1e-3
BATCH_SIZE = 32
IMAGE_DIMENSIONS = (96, 96, 3)

data = []
class_labels = []

matplotlib.use("Agg")

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
argument_parser.add_argument("-p", "--plot",
                             type=str,
                             default="plot.png",
                             help="path to output accuracy/loss plot")
parser = vars(argument_parser.parse_args())

print("Loading Images ......")
image_paths = sorted(list(paths.list_images(parser["dataset"])))
# TODO: https://stackoverflow.com/questions/22639587/random-seed-what-does-it-do
#  Use for comments
random.seed(42)
random.shuffle(image_paths)

for path in image_paths:
    image = cv2.imread(path)
    image = cv2.resize(image, (IMAGE_DIMENSIONS[0], IMAGE_DIMENSIONS[1]))
    image = img_to_array(image)
    data.append(image)

    class_label = path.split(os.path.sep)[-2]
    class_labels.append(class_label)

data = np.array(data, dtype="float") / 255.0
class_labels = np.array(class_labels)

# TODO: Link for comments
# https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html
lb = LabelBinarizer()
class_labels = lb.fit_transform(class_labels)

(trainX, testX, trainY, testY) = train_test_split(data,
                                                  class_labels,
                                                  test_size=0.2,
                                                  random_state=42)

# TODO: Commenting
image_augmentation_generator = ImageDataGenerator(rotation_range=25,
                                                  width_shift_range=0.1,
                                                  height_shift_range=0.1,
                                                  shear_range=0.2,
                                                  zoom_range=0.2,
                                                  horizontal_flip=True,
                                                  fill_mode="nearest")

print("Compiling the Model......")
model = ImageClassifier.builder(height=IMAGE_DIMENSIONS[0],
                                width=IMAGE_DIMENSIONS[1],
                                depth=IMAGE_DIMENSIONS[2],
                                classes=len(lb.classes_))
optimiser = Adam(lr=INITIAL_LEARNING_RATE, decay=INITIAL_LEARNING_RATE / EPOCHS)
model.compile(loss="categorical_crossentropy",
              optimizer=optimiser,
              metrics=["accuracy"])

print("Starting Training......")
model.fit_generator(image_augmentation_generator.flow(trainX, trainY, batch_size=BATCH_SIZE),
                    validation_data=(testX, testY), steps_per_epoch=len(trainX) // BATCH_SIZE,
                    epochs=EPOCHS, verbose=1)

print("Saving Model......")
model.save(parser["model"])

print("Saving label binaries to disk")
f = open(parser["labelbin"], "wb")
f.write(pickle.dumps(lb))
f.close()
