from fastapi import Depends, APIRouter
from sqlalchemy.orm import Session
from config.db import get_db
from dependencies.getUser import get_current_user
from models.ReactionModel import ReactionModel
from controllers.ReactionController import post_reaction

router = APIRouter(prefix="/reaction")

@router.post("")
def reactions_post(creationId: str, reaction: ReactionModel, current_user: dict = Depends(get_current_user), db: Session = Depends(get_db)):
  return post_reaction(creationId, reaction, current_user.get("id"), db)