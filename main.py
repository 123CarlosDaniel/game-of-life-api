from fastapi import FastAPI
from endpoints.UserEndpoint import router as user_router
from endpoints.CreationEndpoint import router as creation_router
from endpoints.CommentEndpoint import router as comment_router
from endpoints.ReactionEndpoint import router as reaction_router

app = FastAPI()

app.include_router(user_router, tags=["users"])
app.include_router(creation_router, tags=["creations"])
app.include_router(comment_router, tags=["comments"])
app.include_router(reaction_router, tags=["reactions"])