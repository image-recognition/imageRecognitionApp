# Machine Learning

Since the major part of the project is going to be machine learning. 
Thus, I have created a dedicated location to store all the machine learning code for the project.

## iOS Image Classifier
### Library Used: CreateMLUI
#### Download Required: No
Relevant links used to study about the given library 
- https://developer.apple.com/videos/play/wwdc2018/703/
- https://apple.github.io/turicreate/docs/userguide/image_classifier/how-it-works.html
### Compilation Instructions
- Open the iOS Image Classifier folder and open *Image Classifier Create.playground* in Xcode.
- Run the file by pressing the run button in the Xcode.
- After this press the following keystrokes *command+option+enter* it will open up an prompt to train model inside which you'll need to load the test and train folders along with the number of iternations you wish to run on the data(this will impact the accuracy of the model). For my case I found any value in between 15 - 20 to be reasonably accurate and quick to train.
- After the model has been trained it'll give to its accuracy along with the number of iterations that had been run on it.
- You can verify the results by using any random image from the internet that partially relates to the images for which the  model has been trained.
- At last remember to save the model to save your progress. This model can be directly added to the project by dragging and dropping it there and all the classes and code for it will be generated automatically by Xcode.
