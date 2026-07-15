from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import User, Question, QuizAttempt
from schemas import SubmitAnswerRequest, SubmitAnswerResponse, QuizResultResponse
from auth import get_current_user

router = APIRouter(prefix="/api/quiz", tags=["Quiz"])


@router.post("/submit", response_model=SubmitAnswerResponse)
def submit_answer(
    req: SubmitAnswerRequest,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    question = db.query(Question).filter(Question.id == req.question_id).first()
    if not question:
        raise HTTPException(status_code=404, detail="Soal tidak ditemukan")

    is_correct = req.selected_answer.upper() == question.correct_answer.upper()

    attempt = QuizAttempt(
        user_id=user.id,
        question_id=question.id,
        selected_answer=req.selected_answer.upper(),
        is_correct=is_correct,
    )
    db.add(attempt)
    db.commit()

    return SubmitAnswerResponse(
        is_correct=is_correct,
        correct_answer=question.correct_answer,
        explanation=question.explanation,
    )


@router.get("/result/{note_id}", response_model=QuizResultResponse)
def quiz_result(
    note_id: int,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    from models import Note
    note = db.query(Note).filter(Note.id == note_id, Note.user_id == user.id).first()
    if not note:
        raise HTTPException(status_code=404, detail="Catatan tidak ditemukan")

    questions = db.query(Question).filter(Question.note_id == note_id).all()
    q_ids = [q.id for q in questions]
    if not q_ids:
        return QuizResultResponse(total=0, correct=0, wrong=0, score=0)

    attempts = db.query(QuizAttempt).filter(
        QuizAttempt.user_id == user.id,
        QuizAttempt.question_id.in_(q_ids),
    ).all()

    total_answered = len(set(a.question_id for a in attempts))
    correct = sum(1 for a in attempts if a.is_correct)
    unique_correct = sum(1 for q_id in q_ids if any(a.question_id == q_id and a.is_correct for a in attempts))

    total_q = len(questions)
    wrong = total_q - unique_correct
    score = round((unique_correct / total_q) * 100, 1) if total_q > 0 else 0

    return QuizResultResponse(
        total=total_q,
        correct=unique_correct,
        wrong=wrong,
        score=score,
    )
