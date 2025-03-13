import io
import requests
from PIL import Image

def perform_ocr(image_bytes):
    if not image_bytes:
        raise ValueError("Empty image bytes provided")
    # Validate image bytes
    try:
        Image.open(io.BytesIO(image_bytes)).convert("RGB")
    except Exception as e:
        raise ValueError(f"Invalid image bytes provided: {e}")

    # OCR.space API endpoint and payload (using the free 'helloworld' key)
    api_url = "https://api.ocr.space/parse/image"
    payload = {
        'apikey': 'helloworld',  # Free API key with usage limits
        'language': 'eng'
    }
    files = {
        'file': ('image.jpg', image_bytes)
    }

    response = requests.post(api_url, data=payload, files=files)
    result = response.json()

    if result.get("IsErroredOnProcessing"):
        error = result.get("ErrorMessage") or "Unknown error"
        raise ValueError(f"OCR processing error: {error}")

    parsed_text = result.get("ParsedResults")[0].get("ParsedText", "")
    paragraphs = parsed_text.split('\n')
    formatted_text = "\n\n".join(p.strip() for p in paragraphs if p.strip())
    return formatted_text
