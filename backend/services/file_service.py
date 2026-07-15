import os
import uuid
from fastapi import UploadFile, HTTPException
from config import UPLOAD_DIR, ALLOWED_EXTENSIONS

os.makedirs(UPLOAD_DIR, exist_ok=True)


def save_upload(file: UploadFile) -> str:
    ext = os.path.splitext(file.filename or "file.pdf")[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(status_code=400, detail=f"Tipe file {ext} tidak didukung. Gunakan PDF, JPG, PNG, atau WEBP.")

    filename = f"{uuid.uuid4().hex}{ext}"
    filepath = os.path.join(UPLOAD_DIR, filename)

    content = file.file.read()
    with open(filepath, "wb") as f:
        f.write(content)

    return filepath, filename
