from keras import Sequential
from keras.layers.core import Activation, Flatten, Dropout, Dense
from keras.layers.convolutional import Conv2D, MaxPooling2D
from keras.layers.normalization import BatchNormalization
from keras import backend as model_backend
import imutils


# # ImageClassifier:
#   builder: It is used to build the neural network.
#     parameters:
#       height: height of the given image
#       width:  width of the given image
#       depth:  depth of the given image
#       classes: classes in which the object might be classified
#     returns:
#       A constructed neural network with a number of layers
class ImageClassifier:
    @staticmethod
    def builder(width, height, depth, classes):
        model = Sequential()
        input_shape = (width, height, depth)
        channel_dimension = -1
        if model_backend.image_data_format() == "channels_first":
            input_shape = (width, height, depth)
            channel_dimension = 1

        model.add(Conv2D(32, (3, 3), padding="same", input_shape=input_shape))
        model.add(Activation("relu"))
        model.add(BatchNormalization(axis=channel_dimension))
        model.add(MaxPooling2D(pool_size=(3, 3)))
        model.add(Dropout(0.25))

        model.add(Conv2D(64, (3, 3), padding="same", input_shape=input_shape))
        model.add(Activation("relu"))
        model.add(BatchNormalization(axis=channel_dimension))
        model.add(Conv2D(64, (3, 3), padding="same", input_shape=input_shape))
        model.add(Activation("relu"))
        model.add(BatchNormalization(axis=channel_dimension))
        model.add(MaxPooling2D(pool_size=(2, 2)))
        model.add(Dropout(0.25))

        model.add(Conv2D(128, (3, 3), padding="same", input_shape=input_shape))
        model.add(Activation("relu"))
        model.add(BatchNormalization(axis=channel_dimension))
        model.add(Conv2D(128, (3, 3), padding="same", input_shape=input_shape))
        model.add(Activation("relu"))
        model.add(BatchNormalization(axis=channel_dimension))
        model.add(MaxPooling2D(pool_size=(2, 2)))
        model.add(Dropout(0.25))

        model.add(Flatten())
        model.add(Dense(1024))
        model.add(Activation("relu"))
        model.add(BatchNormalization())
        model.add(Dropout(.50))

        model.add(Dense(classes))
        model.add(Activation("softmax"))

        return model
