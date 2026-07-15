from pydantic import BaseModel, EmailStr
from typing import List, Optional
from datetime import datetime


class RegisterRequest(BaseModel):
    email: str
    name: str
    password: str


class LoginRequest(BaseModel):
    email: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: int
    name: str


class NoteResponse(BaseModel):
    id: int
    title: str
    filename: str
    content_text: str
    created_at: datetime

    class Config:
        from_attributes = True


class OptionItem(BaseModel):
    label: str
    text: str


class QuestionResponse(BaseModel):
    id: int
    question_text: str
    options: List[OptionItem]

    class Config:
        from_attributes = True


class QuestionDetail(QuestionResponse):
    correct_answer: str
    explanation: str

    class Config:
        from_attributes = True


class SubmitAnswerRequest(BaseModel):
    question_id: int
    selected_answer: str


class SubmitAnswerResponse(BaseModel):
    is_correct: bool
    correct_answer: str
    explanation: str


class QuizResultResponse(BaseModel):
    total: int
    correct: int
    wrong: int
    score: float


class ErrorJournalItem(BaseModel):
    question_id: int
    question_text: str
    options: List[OptionItem]
    correct_answer: str
    explanation: str
    your_answer: str
    attempted_at: datetime

    class Config:
        from_attributes = True


class GenerateResponse(BaseModel):
    message: str
    total_questions: int
