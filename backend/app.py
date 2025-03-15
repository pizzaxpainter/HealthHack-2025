import gradio as gr
import datetime
import json
import os
from classification_model import classify_medicine
from ocr_model import perform_ocr

MEDS_FILE = "medications.json"

def load_medications():
    if os.path.exists(MEDS_FILE):
        try:
            with open(MEDS_FILE, "r") as f:
                return json.load(f)
        except Exception:
            return []
    return []

def save_medications(meds):
    with open(MEDS_FILE, "w") as f:
        json.dump(meds, f)

def classify_image(image):
    with open(image, "rb") as f:
        image_bytes = f.read()
    result = classify_medicine(image_bytes)
    return f"Class: {result['pill_class']}, Confidence: {result['confidence']:.2f}"

def ocr_image(image):
    with open(image, "rb") as f:
        image_bytes = f.read()
    return perform_ocr(image_bytes)

def add_medication(name, dosage, frequency, start_date, end_date, notes):
    # Convert dates to ISO strings for consistency
    if isinstance(start_date, (float, int)):
        start_date = datetime.datetime.fromtimestamp(start_date).date().isoformat()
    elif isinstance(start_date, datetime.datetime):
        start_date = start_date.date().isoformat()
    elif isinstance(start_date, datetime.date):
        start_date = start_date.isoformat()
    
    if isinstance(end_date, (float, int)):
        end_date = datetime.datetime.fromtimestamp(end_date).date().isoformat()
    elif isinstance(end_date, datetime.datetime):
        end_date = end_date.date().isoformat()
    elif isinstance(end_date, datetime.date):
        end_date = end_date.isoformat()
    
    meds = load_medications()
    meds.append({
         "name": name,
         "dosage": dosage,
         "frequency": frequency,
         "start_date": start_date,
         "end_date": end_date,
         "notes": notes
    })
    save_medications(meds)
    return "✅ Medication added successfully!"

def view_medications():
    meds = load_medications()
    if not meds:
        return "No medications added."
    return "\n".join([
        f"{med['name']} - {med['dosage']} - {med['frequency']} ({med['start_date']} to {med['end_date']})"
        for med in meds
    ])

def get_today_medications():
    meds = load_medications()
    today = datetime.date.today()
    today_name = today.strftime("%A")
    today_meds = []
    
    for med in meds:
        try:
            start = datetime.date.fromisoformat(med["start_date"])
            end = datetime.date.fromisoformat(med["end_date"])
            frequency = med["frequency"]
            
            # Skip if today is not within the medication date range
            if not (start <= today <= end):
                continue
                
            # Handle weekly medications - only show on the appropriate day
            if frequency == "Weekly" and today_name != "Monday":  # Assuming weekly meds are taken on Monday
                continue
                
            today_meds.append(med)
        except Exception:
            continue
            
    if not today_meds:
        return "No medications scheduled for today."
        
    return "\n".join([
        f"{med['name']} - {med['dosage']} - {med['frequency']}"
        + (f" ({_get_time_of_day(med['frequency'])})" if _get_time_of_day(med['frequency']) else "")
        for med in today_meds
    ])

def _get_time_of_day(frequency):
    """Helper function to return time of day based on frequency"""
    if frequency == "Every morning":
        return "Morning"
    elif frequency == "Every evening":
        return "Evening"
    elif frequency == "Once daily":
        return "Morning"
    elif frequency == "Twice daily":
        return "Morning and Evening"
    elif frequency == "Three times daily":
        return "Morning, Afternoon, and Evening"
    elif frequency == "Four times daily":
        return "Morning, Noon, Afternoon, and Night"
    elif frequency == "Every 12 hours":
        return "Morning and Evening"
    return ""

def get_weekly_schedule():
    meds = load_medications()
    today = datetime.date.today()
    week_meds = {(today + datetime.timedelta(days=i)).isoformat(): [] for i in range(7)}
    days_of_week = [(today + datetime.timedelta(days=i)).strftime("%A") for i in range(7)]
    
    for med in meds:
        try:
            start = datetime.date.fromisoformat(med["start_date"])
            end = datetime.date.fromisoformat(med["end_date"])
            frequency = med["frequency"]
        except Exception:
            continue
            
        for i, day_str in enumerate(week_meds.keys()):
            day_date = datetime.date.fromisoformat(day_str)
            day_name = days_of_week[i]
            
            # Skip if day is not within the medication date range
            if not (start <= day_date <= end):
                continue
                
            # For weekly medications, only include on Mondays
            if frequency == "Weekly" and day_name != "Monday":
                continue
                
            med_info = f"{med['name']} - {med['dosage']} - {med['frequency']}"
            timing = _get_time_of_day(frequency)
            if timing:
                med_info += f" ({timing})"
                
            week_meds[day_str].append(med_info)
    
    # Format the output with day names for better readability
    formatted_output = {}
    for i, (day_str, meds_list) in enumerate(week_meds.items()):
        day_name = days_of_week[i]
        formatted_output[f"{day_name} ({day_str})"] = meds_list
        
    return json.dumps(formatted_output, indent=2)

with gr.Blocks() as app:
    gr.Markdown("# 💊 Medication Tracker")
    
    with gr.Tabs():
        with gr.Tab("📸 Identify Medicine"):
            gr.Markdown("Upload an image to identify the medicine.")
            with gr.Row():
                image_input = gr.Image(type="filepath")
            classify_output = gr.Textbox()
            
            classify_button = gr.Button("Classify Medicine")
            classify_button.click(classify_image, inputs=image_input, outputs=classify_output)
            
            gr.Markdown("### Add this medication to your tracker")
            identified_name = gr.Textbox(label="Medication Name")
            identified_dosage = gr.Textbox(label="Dosage (e.g., 500mg)")
            identified_frequency = gr.Dropdown(
            label="Frequency", 
            choices=["Once daily", "Twice daily", "Three times daily", "Four times daily", 
                "Every morning", "Every evening", "Every 12 hours", "Weekly", "As needed"],
            value="Once daily"
            )
            identified_start_date = gr.DateTime(label="Start Date")
            identified_end_date = gr.DateTime(label="End Date")
            identified_notes = gr.Textbox(label="Additional Notes")
            identified_add_button = gr.Button("Add to My Medications")
            identified_add_output = gr.Textbox()
            
            identified_add_button.click(
            add_medication, 
            inputs=[identified_name, identified_dosage, identified_frequency, 
                identified_start_date, identified_end_date, identified_notes], 
            outputs=identified_add_output
            )
    
        with gr.Tab("🔍 Extract Medical Label"):
            gr.Markdown("Upload an image of a prescription or label to extract text.")
            image_input_ocr = gr.Image(type="filepath")
            ocr_button = gr.Button("Extract Text")
            ocr_output = gr.Textbox()
            ocr_button.click(ocr_image, inputs=image_input_ocr, outputs=ocr_output)
    
        with gr.Tab("📝 Add Medication"):
            gr.Markdown("Add your medications manually.")
            name = gr.Textbox(label="Medication Name")
            dosage = gr.Textbox(label="Dosage (e.g., 500mg)")
            frequency = gr.Dropdown(
                label="Frequency", 
                choices=["Once daily", "Twice daily", "Three times daily", "Four times daily", 
                         "Every morning", "Every evening", "Every 12 hours", "Weekly", "As needed"],
                value="Once daily"
            )
            start_date = gr.DateTime(label="Start Date")
            end_date = gr.DateTime(label="End Date")
            notes = gr.Textbox(label="Additional Notes")
            add_button = gr.Button("Add Medication")
            add_output = gr.Textbox()
            add_button.click(add_medication, inputs=[name, dosage, frequency, start_date, end_date, notes], outputs=add_output)
    
        with gr.Tab("📅 Medication Schedule"):
            gr.Markdown("View your scheduled medications.")
            today_button = gr.Button("View Today's Medications")
            today_output = gr.Textbox(label="Today's Medications")
            today_button.click(get_today_medications, outputs=today_output)
            
            weekly_button = gr.Button("View Weekly Schedule")
            weekly_output = gr.Textbox(label="Weekly Schedule")
            weekly_button.click(get_weekly_schedule, outputs=weekly_output)
            
            all_meds_button = gr.Button("View All Medications")
            all_meds_output = gr.Textbox(label="All Medications")
            all_meds_button.click(view_medications, outputs=all_meds_output)

app.launch()
