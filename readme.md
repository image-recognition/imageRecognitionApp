# Smart List

This is the repository for all the codes of our unit SIT 305 - Android and iOS Mobile Programming

git repository link: https://github.com/image-recognition/imageRecognitionApp

## Team Members

- Sohil Kaushal SID: 218053209
- Shubham Jindal SID: 218053165

## Project Overview

The main objective of the project is to design an iOS based app which implements the concepts of  Machine Learning. The app will use the camera of the device to identify the object that has been placed in front of it. Furthermore, the user will be able to view all the recently identified items in the form of a list and custom lists can also be created by the user.

The project will be compatible with iOS devices and I am aiming for High Distinction.

### Advanced Concepts Explored

- Core Data Persistence
- Dynamic Layouts
- Custom Camera View
- CoreML and Vision
- Using Keras
- Using coremltools to convert ml model from one form to other
- Using Keras to create a Machine Learning Model
- Various ways of collecting and Slicing Datasets

### Objects List

The objects that can be currently recognised by the application are as follow:
- apple
- butter
- banana
- backpack
- bread
- car
- cheese
- couch
- eggs
- iPhone
- keyboard
- MacBook
- milk
- onion
- pasta
- pen
- pizza
- refrigerator
- rice
- shoes
- spectacles
- table
- television
- water bottle

## Compile Instructions

The app is currently working with limited capabilities. The instructions to build it are as follows:

- An iOS device (as the application uses camera view which cannot be used on a simulator) is required to run the application.
- Clone the repo onto your local machine by using
	```
		git clone https://github.com/image-recognition/imageRecognitionApp.git
	```
- Open the Project in Xcode.

- After, the project has been opened click on the play button on the top left corner of Xcode.

- Click on the prompt to allow camera permissions to the device.

## Directory Layout

The project at the moment consists of two folders and they are:
- ImageRecognitionApp [main application folder].
- Machine Learning Resources [all the machine learning code for the application].

### ImageRecognitionApp

This folder contains the code for the core application and can be compiled using the instructions listed in under the Compile Instructions header.

### Machine Learning Resources

*Please note these changes were made on the MachineLearning branch you can see these changes by using the following command*
`git checkout branch_name`
This folder contains code for Machine Learning written in Python. This directory can further be broken down into 3 sub directories and they are as follows:
- Data Set Builder and Model Builder: This directory contains our final codes for our neural network
- Keras Image Classifier: This is an initial version of 'Data Set Builder and Model Builder' and we built upon this in order to make the process much more user friendly and intuitive.
- iOS Image Classifier: An image classifier that we built using Apple's provided libraries this was scrapped because it automated the entire process which resulted in less learning experience for us.

## Major Features
The major features of our app are as follows:

- Action Screen: The app has an action screen that would permit the user to carry out all the operations. It also contains a tabbed view that would help the user to navigate through the user interface. The first tab is used to scan and identify the object that has been put in front of it, the second tab contains contain history of all the objects that have been scanned previously, the final tab would contain custom lists that have been created by the user, these lists will be fully customisable and they are completely modular. Finally, there is a fourth tab that contains all the user settings and the ability to generate logs.

- Data Persistence: The app has data persistence built into it so, the whatever changes are made by the user are save in the application in the form of an internal data structure.

- Machine Learning Model: For the purpose of this application we have created and trained a neural network of our own. Initially this model was supposed to identify a wide range of objects. However due to various limitations including time and hardware constraints we were only able to design the model for a limited dataset of 24 objects as listed above.

## Additional Features
- Auto flash: The application has an auto flash feature that would help to capture clear images of the object placed in front and it would also give the application over other competitors as most of them don’t use this feature.

- Log File: Whenever the application crashes the crash information will be stored in a log file that would be helpful for both developer and user while reporting errors especially in beta testing phase.

- Different Modes: The app as two modes a dark mode and a light mode. The dark mode is easy on eyes and since it is pitch black it would help save some battery as well. Whereas the light mode is for day to day use.

## API Reference

### Application

Below is a list of all the main classes with their main functions.

#### ViewController
Methods:
##### viewDidLoad: Called when the view is loaded, default user settings for the first time are set here.
- Parameters: None
- Return: None

##### viewWillAppear: Set the view according to dark mode setting.
- Parameter: animated - If true, the view is being added to the window using an animation.
- Return: None

##### save: Used to save object names in the history or list.
- Parameters:
- object - list or history object in which the name has to be saved.
- name - name of the object

- Return: None

##### photoOutput: Provides the delegate with the captured image and associated metadata resulting from a photo capture.
- Parameters: 
- captureOutput: The photo output performing the capture.
- photo: An object containing the captured image pixel buffer, along with any metadata and attachments captured along with the photo (such as a preview image or depth map).
- error: If the capture process could not proceed successfully, an error object describing the failure; otherwise, nil.

- Return: None

##### captureOutput: Notifies the delegate that a new video frame was written.
- Parameters:
- captureOutput: The capture output object.
- sampleBuffer: A CMSampleBuffer object containing the video frame data and additional information about the frame, such as its format and presentation time.
- connection: The connection from which the video was received.

- Return: None

#### The other classes of the project mostly contain the in-built functions used to populate the table views and cells.

### Machine Learning Model

Since we used keras it gave us an high level API to tensorflow which made the process of designing the neural network much easier that what we originally anticipated.The main classes for the machine learning model is as follows:

#### Class Name: ImageClassifier

 This class contains the structure for each of the layer of the model. This
 class has no constructors but has one static method **builder**

##### Method Name: builder

- Parameters:

	- height: height of the given image
  - width:  width of the given image
  - depth:  depth of the given image
	- classes: classes in which the object might be classified

- Returns: this function return
