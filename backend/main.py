from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import engine, Base
from routers import auth_router, notes, quiz, errors

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Teman Belajar AI", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router.router)
app.include_router(notes.router)
app.include_router(quiz.router)
app.include_router(errors.router)


@app.get("/")
def root():
    return {"message": "Teman Belajar AI API is running 🚀"}
