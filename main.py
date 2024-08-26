from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from endpoints.UserEndpoint import router as user_router
from endpoints.CreationEndpoint import router as creation_router
from endpoints.CommentEndpoint import router as comment_router
from endpoints.ReactionEndpoint import router as reaction_router
from dotenv import load_dotenv
import os

load_dotenv()

app = FastAPI()

origins = [
    # "http://localhost:3000",
    os.getenv("APP_URL"),
    # Agrega otros orígenes si es necesario, como dominios o puertos adicionales
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(user_router, tags=["users"])
app.include_router(creation_router, tags=["creations"])
app.include_router(comment_router, tags=["comments"])
app.include_router(reaction_router, tags=["reactions"])