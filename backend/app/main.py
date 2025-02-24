from fastapi import FastAPI, UploadFile, File
from ocr_model import perform_ocr
from classification_model import classify_medicine

app = FastAPI()

@app.post("/ocr/")
async def ocr(file: UploadFile = File(...)):
    contents = await file.read()
    result = perform_ocr(contents)
    return {"result": result}

@app.post("/classify/")
async def classify(file: UploadFile = File(...)):
    contents = await file.read()
    result = classify_medicine(contents)
    return {"result": result}
