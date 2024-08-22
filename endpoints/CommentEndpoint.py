from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from config.db import get_db
from dependencies.getUser import get_current_user
from controllers.CommentController import post_comment, delete_comment, update_comment
from models.request import CommentModel
from models.common import ErrorResponse

router = APIRouter(prefix="/comment")


@router.post("", responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"},
  401: {"model": ErrorResponse, "description": "Unauthorized"}
})
def comments_post(
  creation_id: str,
  comment: CommentModel,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return post_comment(creation_id, comment, current_user.get("id"), db)


@router.delete("/{commentId}", responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"},
  401: {"model": ErrorResponse, "description": "Unauthorized"}
})
def comment_delete(
  comment_id: str,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return delete_comment(comment_id, current_user.get("id"), db)


@router.put("/{commentId}", responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"},
  401: {"model": ErrorResponse, "description": "Unauthorized"}
})
def comment_update(
  comment_id: str,
  comment: CommentModel,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return update_comment(comment_id, comment, current_user.get("id"), db)
