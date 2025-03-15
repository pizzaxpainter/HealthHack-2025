import io
import os
import torch
import torch.nn.functional as F
import torchvision.transforms as transforms
from PIL import Image
import timm

# Define your pill classes (ensure this matches your training setup)
PILL_CLASSES = {
    'acc': 0, 'advil': 1, 'akineton': 2, 'algoflex': 3, 'algopyrin': 4, 'ambroxol': 5, 
    'apranax': 6, 'aspirin': 7, 'atoris': 8, 'atorvastatin': 9, 'betaloc': 10, 
    'bila': 11, 'c': 12, 'calci': 13, 'cataflam': 14, 'cetirizin': 15, 'co': 16, 
    'cold': 17, 'coldrex': 18, 'concor': 19, 'condrosulf': 20, 'controloc': 21, 
    'covercard': 22, 'coverex': 23, 'diclopram': 24, 'donalgin': 25, 'dorithricin': 26, 
    'doxazosin': 27, 'dulodet': 28, 'dulsevia': 29, 'enterol': 30, 'escitil': 31, 
    'favipiravir': 32, 'frontin': 33, 'furon': 34, 'ibumax': 35, 'indastad': 36, 
    'jutavit': 37, 'kalcium': 38, 'kalium': 39, 'ketodex': 40, 'koleszterin': 41, 
    'l': 42, 'lactamed': 43, 'lactiv': 44, 'laresin': 45, 'letrox': 46, 'lordestin': 47, 
    'magne': 48, 'mebucain': 49, 'merckformin': 50, 'meridian': 51, 'metothyrin': 52, 
    'mezym': 53, 'milgamma': 54, 'milurit': 55, 'naprosyn': 56, 'narva': 57, 
    'naturland': 58, 'nebivolol': 59, 'neo': 60, 'no': 61, 'noclaud': 62, 
    'nolpaza': 63, 'nootropil': 64, 'normodipine': 65, 'novo': 66, 'nurofen': 67, 
    'ocutein': 68, 'olicard': 69, 'panangin': 70, 'pantoprazol': 71, 'provera': 72, 
    'quamatel': 73, 'reasec': 74, 'revicet': 75, 'rhinathiol': 76, 'rubophen': 77, 
    'salazopyrin': 78, 'sedatif': 79, 'semicillin': 80, 'sicor': 81, 'sinupret': 82, 
    'sirdalud': 83, 'strepfen': 84, 'strepsils': 85, 'syncumar': 86, 'teva': 87, 
    'theospirex': 88, 'tricovel': 89, 'tritace': 90, 'urotrin': 91, 'urzinol': 92, 
    'valeriana': 93, 'verospiron': 94, 'vita': 95, 'vitamin': 96, 'voltaren': 97, 
    'xeter': 98, 'zadex': 99
}

# Set device to CPU
device = torch.device("cpu")

# Instantiate the model architecture (same as training)
model = timm.create_model("rexnet_150", pretrained=True, num_classes=len(PILL_CLASSES))
model.to(device)

# Load the trained state dict
model_path = os.path.join("classification_model.pth")
model.load_state_dict(torch.load(model_path, map_location=device))
model.eval()

# Define image transformations
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

def classify_medicine(image_bytes):
    """Convert image bytes to prediction using the loaded model."""
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    input_tensor = transform(image).unsqueeze(0).to(device)
    
    with torch.no_grad():
        output = model(input_tensor)
    
    probabilities = F.softmax(output[0], dim=0)
    class_index = torch.argmax(probabilities).item()
    confidence = probabilities[class_index].item()
    
    # Invert the PILL_CLASSES dictionary for easy lookup
    PILL_CLASSES_INVERTED = {v: k for k, v in PILL_CLASSES.items()}
    pill_class = PILL_CLASSES_INVERTED.get(class_index, "Unknown")
    
    return {"class_index": class_index, "pill_class": pill_class, "confidence": confidence}

export = classify_medicine