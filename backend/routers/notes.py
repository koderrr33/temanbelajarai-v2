from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import User, Note, Question
from schemas import NoteResponse, GenerateResponse, QuestionResponse
from auth import get_current_user
from services.file_service import save_upload
from services.gemini_service import ocr_from_file
from services.deepseek_service import generate_questions

router = APIRouter(prefix="/api/notes", tags=["Notes"])


@router.post("/upload", response_model=NoteResponse)
def upload_note(
    file: UploadFile = File(...),
    title: str = Form("Catatan Baru"),
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    filepath, filename = save_upload(file)

    ext = filename.rsplit(".", 1)[-1].lower()
    mime_map = {"pdf": "application/pdf", "jpg": "image/jpeg", "jpeg": "image/jpeg", "png": "image/png", "webp": "image/webp"}
    mime_type = mime_map.get(ext, "application/octet-stream")

    content_text = ocr_from_file(filepath, mime_type)

    note = Note(user_id=user.id, title=title, filename=filename, content_text=content_text)
    db.add(note)
    db.commit()
    db.refresh(note)

    return note


@router.get("", response_model=list[NoteResponse])
def list_notes(
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    notes = db.query(Note).filter(Note.user_id == user.id).order_by(Note.created_at.desc()).all()
    return notes


@router.get("/{note_id}", response_model=NoteResponse)
def get_note(
    note_id: int,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    note = db.query(Note).filter(Note.id == note_id, Note.user_id == user.id).first()
    if not note:
        raise HTTPException(status_code=404, detail="Catatan tidak ditemukan")
    return note


@router.post("/{note_id}/generate", response_model=GenerateResponse)
def generate_soal(
    note_id: int,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    note = db.query(Note).filter(Note.id == note_id, Note.user_id == user.id).first()
    if not note:
        raise HTTPException(status_code=404, detail="Catatan tidak ditemukan")

    if not note.content_text or len(note.content_text.strip()) < 20:
        raise HTTPException(status_code=400, detail="Teks catatan terlalu pendek untuk generate soal. Upload ulang dengan file yang lebih jelas.")

    existing = db.query(Question).filter(Question.note_id == note_id).count()
    if existing > 0:
        return GenerateResponse(message=f"Soal sudah ada ({existing} soal). Hapus dulu jika ingin generate ulang.", total_questions=existing)

    try:
        soal_list = generate_questions(note.content_text)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Gagal generate soal: {str(e)}")

    for s in soal_list:
        q = Question(
            note_id=note_id,
            question_text=s["pertanyaan"],
            options=s["opsi"],
            correct_answer=s["jawaban"],
            explanation=s.get("penjelasan", ""),
        )
        db.add(q)

    db.commit()
    return GenerateResponse(message="Soal berhasil dibuat", total_questions=len(soal_list))


@router.get("/{note_id}/questions", response_model=list[QuestionResponse])
def list_questions(
    note_id: int,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    note = db.query(Note).filter(Note.id == note_id, Note.user_id == user.id).first()
    if not note:
        raise HTTPException(status_code=404, detail="Catatan tidak ditemukan")

    questions = db.query(Question).filter(Question.note_id == note_id).all()
    return questions
