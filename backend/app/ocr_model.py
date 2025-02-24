import io
from PIL import Image
import torch
from transformers import TrOCRProcessor, VisionEncoderDecoderModel

# Load the model and processor
processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-printed")
model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-base-printed")

def perform_ocr(image_bytes):
    # Convert bytes to PIL Image
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")

    # Preprocess the image
    pixel_values = processor(image, return_tensors="pt").pixel_values

    # Perform OCR
    with torch.no_grad():
        generated_ids = model.generate(pixel_values)
    
    # Decode the generated ids to text
    ocr_result = processor.decode(generated_ids[0], skip_special_tokens=True)
    return ocr_result
