from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from config.db import get_db
from dependencies.getUser import get_current_user
from controllers.CommentController import post_comment
from models.CommentModel import CommentModel

router = APIRouter(prefix="/comment")


@router.post("")
def comments_post(creationId: str, comment: CommentModel, current_user: dict = Depends(get_current_user), db: Session = Depends(get_db)):
  return post_comment(creationId, comment, current_user.get("id"), db)

