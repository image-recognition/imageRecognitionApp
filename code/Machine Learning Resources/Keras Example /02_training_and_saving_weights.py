import keras
from keras.datasets import cifar10
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, Conv2D, MaxPooling2D
from pathlib import Path
import os
# Adding condition to make sure that tensorflow runs
os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'
# loading the dataset into the variables
(x_train, y_train), (x_test, y_test) = cifar10.load_data()
# Preparing data for
x_train = x_train.astype("float32")
x_test = x_test.astype("float32")
x_train = x_train / 255
x_test = x_test / 255
# sorting data based into categories
y_train = keras.utils.to_categorical(y_train, 10)
y_test = keras.utils.to_categorical(y_test, 10)

# Creating Model
model = Sequential()
model.add(Conv2D(32, (3, 3), padding='same', activation='relu', input_shape=(32, 32, 3)))
model.add(Conv2D(32, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
# Dropping random data to ensure that the model learns rather than memorizing the dataset
model.add(Dropout(0.25))

model.add(Conv2D(64, (3, 3), padding='same', activation='relu'))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
# Flattening the dataset
model.add(Flatten())
# Adding Dense layers
model.add(Dense(512, activation='relu'))
model.add(Dropout(0.50))
model.add(Dense(10, activation='softmax'))
# Compiling the model using appropriate parameters
model.compile(
    loss='categorical_crossentropy',
    optimizer='adam',
    metrics=['accuracy']
)

# Printing the model summary
model.summary()

# Training dataset
model.fit(
    x_train,
    y_train,
    batch_size=64,
    epochs=30,
    validation_data=(x_test, y_test),
    shuffle=True
)

# Saving the neural network
model_structure = model.to_json()
file = Path("model_structure.json")
file.write_text(model_structure)
# saving the trained weights
model.save_weights("model_weights.h5")
