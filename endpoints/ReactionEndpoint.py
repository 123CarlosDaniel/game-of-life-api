from fastapi import Depends, APIRouter
from sqlalchemy.orm import Session
from config.db import get_db
from dependencies.getUser import get_current_user
from models.request import ReactionModel
from models.common import ErrorResponse
from controllers.ReactionController import post_reaction, delete_reaction, delete_reaction_by_creation

router = APIRouter(prefix="/reaction")

@router.post("", responses={
  404: {"model": ReactionModel, "description": "Not found"},
  401: {"model": ErrorResponse, "description": "Unauthorized"},
  500: {"model": ErrorResponse, "description": "Internal server error"}
})
def reactions_post(
  creation_id: str,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return post_reaction(creation_id, current_user.get("id"), db)


@router.delete("/{reactionId}", responses={
  404: {"model": ReactionModel, "description": "Not found"}
})
def reaction_delete(
  reaction_id: str,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return delete_reaction(reaction_id, current_user.get("id"), db)

@router.delete("", responses={
  404: {"model": ReactionModel, "description": "Not found"}
})
def reaction_delete(
  creation_id: str,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return delete_reaction_by_creation(creation_id, current_user.get("id"), db)