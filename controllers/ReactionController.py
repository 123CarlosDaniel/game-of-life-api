from sqlalchemy.orm import Session
from sqlalchemy import text
from utils.generateId import cuid_generator
from sqlalchemy.exc import SQLAlchemyError
from models.ReactionModel import ReactionModel


def post_reaction(creationId: str, reaction: ReactionModel, userId: str, db: Session):
  pass