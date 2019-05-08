from keras.models import model_from_json
import coremltools 
import os

json_file = open('model_structure.json')
model_json = json_file.read()
keras_model = model_from_json(model_json)
keras_model.load_weights('model_weights.h5')
coreml_model = coremltools.converters.keras.convert(keras_model, input_names="input", output_names="output")
coreml_model.author = 'Sohil Kaushal'
coreml_model.license = 'MIT'
coreml_model.short_description = 'Predicts the image inserted by User'
coreml_model.input_description['input'] = 'Input from camera/gallery'
coreml_model.output_description['output'] = 'Output on screen'

coreml_model.save('object_model.mlmodel')
