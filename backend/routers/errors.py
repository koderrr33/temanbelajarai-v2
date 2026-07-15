from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models import User, Question, QuizAttempt
from schemas import ErrorJournalItem
from auth import get_current_user

router = APIRouter(prefix="/api/errors", tags=["Errors"])


@router.get("", response_model=list[ErrorJournalItem])
def error_journal(
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    wrong_attempts = (
        db.query(QuizAttempt)
        .filter(QuizAttempt.user_id == user.id, QuizAttempt.is_correct == False)
        .order_by(QuizAttempt.created_at.desc())
        .all()
    )

    seen = set()
    result = []
    for a in wrong_attempts:
        if a.question_id in seen:
            continue
        seen.add(a.question_id)

        q = db.query(Question).filter(Question.id == a.question_id).first()
        if not q:
            continue

        result.append(ErrorJournalItem(
            question_id=q.id,
            question_text=q.question_text,
            options=q.options,
            correct_answer=q.correct_answer,
            explanation=q.explanation,
            your_answer=a.selected_answer,
            attempted_at=a.created_at,
        ))

    return result
