import io
import os
import torch
from PIL import Image
import torchvision.transforms as transforms

# Load the PyTorch model
model_path = os.path.join(os.pardir, "classification_model.pth")
model = torch.load(model_path, map_location=torch.device("cpu"))
model.eval()

# Define the image transformations
transform = transforms.Compose([
    transforms.Resize((224, 224)),  # Resize to the input shape of the model
    transforms.ToTensor(),  # Convert the image to a tensor
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])  # Normalize the image
])


# Classes for the type of pill involved
PILL_CLASSES = {
    'acc': 0, 'advil': 1, 'akineton': 2, 'algoflex': 3, 'algopyrin': 4, 'ambroxol': 5, 'apranax': 6, 'aspirin': 7, 
    'atoris': 8, 'atorvastatin': 9, 'betaloc': 10, 'bila': 11, 'c': 12, 'calci': 13, 'cataflam': 14, 'cetirizin': 15, 
    'co': 16, 'cold': 17, 'coldrex': 18, 'concor': 19, 'condrosulf': 20, 'controloc': 21, 'covercard': 22, 'coverex': 23, 
    'diclopram': 24, 'donalgin': 25, 'dorithricin': 26, 'doxazosin': 27, 'dulodet': 28, 'dulsevia': 29, 'enterol': 30, 
    'escitil': 31, 'favipiravir': 32, 'frontin': 33, 'furon': 34, 'ibumax': 35, 'indastad': 36, 'jutavit': 37, 'kalcium': 38, 
    'kalium': 39, 'ketodex': 40, 'koleszterin': 41, 'l': 42, 'lactamed': 43, 'lactiv': 44, 'laresin': 45, 'letrox': 46, 
    'lordestin': 47, 'magne': 48, 'mebucain': 49, 'merckformin': 50, 'meridian': 51, 'metothyrin': 52, 'mezym': 53, 
    'milgamma': 54, 'milurit': 55, 'naprosyn': 56, 'narva': 57, 'naturland': 58, 'nebivolol': 59, 'neo': 60, 'no': 61, 
    'noclaud': 62, 'nolpaza': 63, 'nootropil': 64, 'normodipine': 65, 'novo': 66, 'nurofen': 67, 'ocutein': 68, 'olicard': 69, 
    'panangin': 70, 'pantoprazol': 71, 'provera': 72, 'quamatel': 73, 'reasec': 74, 'revicet': 75, 'rhinathiol': 76, 
    'rubophen': 77, 'salazopyrin': 78, 'sedatif': 79, 'semicillin': 80, 'sicor': 81, 'sinupret': 82, 'sirdalud': 83, 
    'strepfen': 84, 'strepsils': 85, 'syncumar': 86, 'teva': 87, 'theospirex': 88, 'tricovel': 89, 'tritace': 90, 
    'urotrin': 91, 'urzinol': 92, 'valeriana': 93, 'verospiron': 94, 'vita': 95, 'vitamin': 96, 'voltaren': 97, 'xeter': 98, 
    'zadex': 99
}

def classify_medicine(image_bytes):
    # Convert bytes to PIL Image
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    
    # Apply the transformations
    input_data = transform(image).unsqueeze(0)  # Add batch dimension

    # Run the model
    with torch.no_grad():
        output_data = model(input_data)

    # Assuming the output is a softmax probability distribution
    probabilities = torch.nn.functional.softmax(output_data[0], dim=0)
    class_index = torch.argmax(probabilities).item()
    confidence = probabilities[class_index].item()

    return {"class_index": class_index, "confidence": confidence}