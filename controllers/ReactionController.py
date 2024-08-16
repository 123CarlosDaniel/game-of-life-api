from sqlalchemy.orm import Session
from sqlalchemy import text
from utils.generateId import cuid_generator
from sqlalchemy.exc import SQLAlchemyError
from fastapi import HTTPException
from models.ReactionModel import ReactionModel


def post_reaction(creationId: str, reaction: ReactionModel, userId: str, db: Session):
  creation = db.execute(text("SELECT 1 FROM creation WHERE id = :id"),
                        {"id": creationId}).fetchone()
  if not creation:
    raise HTTPException(404, "Not found")

  reactionId = cuid_generator.generate()
  db.execute(text("""INSERT INTO reaction (id, reaction, ownerId, creationId)
                    VALUES (:id, :reaction, :userId, :creationId)"""),
             {"id": reactionId, "reaction": reaction.reaction, "userId": userId, "creationId": creationId})
  db.commit()
  return {"id": reactionId, "message": "Created successfully"}


def delete_reaction(reactionId: str, userId: str, db: Session):
  reaction = db.execute(text("SELECT 1 FROM reaction WHERE id = :id and ownerId = :userId"),
                        {"id": reactionId, "userId": userId}).fetchone()
  if not reaction:
    raise HTTPException(404, "Not found")
  db.execute(text("DELETE FROM reaction WHERE id = :id"), {"id": reactionId})
  db.commit()
  return {"message": "Deleted successfully"}


def delete_reaction_by_creation(creationId: str, userId: str, db: Session):
  reaction = db.execute(text("SELECT id FROM reaction WHERE creationId = :id and ownerId = :userId"),
                        {"id": creationId, "userId": userId}).fetchone()
  if not reaction:
    raise HTTPException(404, "Not found")
  
  db.execute(text("DELETE FROM reaction WHERE id = :id"),
             {"id": reaction[0]})
  db.commit()
  return {"message": "Deleted successfully"}
