import numpy as np
import tensorflow as tf
from PIL import Image

# Load the TFLite model
interpreter = tf.lite.Interpreter(model_path="path/to/your/model.tflite")
interpreter.allocate_tensors()

# Get input and output tensors
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

def classify_medicine(image_bytes):
    # Convert bytes to PIL Image
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    
    # Resize the image to the input shape of the model
    image = image.resize((input_details[0]['shape'][1], input_details[0]['shape'][2]))
    
    # Convert the image to a numpy array and normalize
    input_data = np.array(image, dtype=np.float32) / 255.0
    input_data = np.expand_dims(input_data, axis=0)  # Add batch dimension

    # Set the input tensor
    interpreter.set_tensor(input_details[0]['index'], input_data)

    # Run the model
    interpreter.invoke()

    # Get the output tensor
    output_data = interpreter.get_tensor(output_details[0]['index'])
    
    # Assuming the output is a softmax probability distribution
    class_index = np.argmax(output_data[0])
    confidence = output_data[0][class_index]

    return {"class_index": class_index, "confidence": confidence}
