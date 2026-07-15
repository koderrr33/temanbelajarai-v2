import google.generativeai as genai
from config import GEMINI_API_KEY

genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel("gemini-1.5-flash")


def ocr_from_file(filepath: str, mime_type: str) -> str:
    sample_file = genai.upload_file(path=filepath, mime_type=mime_type)
    response = model.generate_content(
        [sample_file, "Extract all text from this document exactly as written. Return only the text content, no commentary."]
    )
    return response.text
