from sqlalchemy.orm import Session
from sqlalchemy import text
from utils.generateId import cuid_generator
from sqlalchemy.exc import SQLAlchemyError
from fastapi import HTTPException


def post_reaction(creationId: str, userId: str, db: Session):
  try:
    creation = db.execute(text("SELECT 1 FROM creation WHERE id = :id"),
                          {"id": creationId}).fetchone()
    if not creation:
      raise HTTPException(404, "Not found")
    reaction = db.execute(text("SELECT 1 FROM reaction WHERE creationId = :id and ownerId = :userId"),
                          {"id": creationId, "userId": userId}).fetchone()
    if reaction:
      raise HTTPException(409, "Already reacted")
    reactionId = cuid_generator.generate()
    db.execute(text("""INSERT INTO reaction (id, ownerId, creationId)
                      VALUES (:id, :userId, :creationId)"""),
               {"id": reactionId, "userId": userId, "creationId": creationId})
    db.commit()
    return {"id": reactionId, "message": "Created successfully"}
  except SQLAlchemyError as e:
    db.rollback()
    raise HTTPException(500, "Internal server error")


def delete_reaction(reactionId: str, userId: str, db: Session):
  try:
    reaction = db.execute(text("SELECT 1 FROM reaction WHERE id = :id and ownerId = :userId"),
                          {"id": reactionId, "userId": userId}).fetchone()
    if not reaction:
      raise HTTPException(404, "Not found")
    db.execute(text("DELETE FROM reaction WHERE id = :id"), {"id": reactionId})
    db.commit()
    return {"message": "Deleted successfully"}
  except SQLAlchemyError as e:
    db.rollback()
    raise HTTPException(500, "Internal server error")


def delete_reaction_by_creation(creationId: str, userId: str, db: Session):
  try:
    reaction = db.execute(text("SELECT id FROM reaction WHERE creationId = :id and ownerId = :userId"),
                          {"id": creationId, "userId": userId}).fetchone()
    if not reaction:
      raise HTTPException(404, "Not found")

    db.execute(text("DELETE FROM reaction WHERE id = :id"),
               {"id": reaction[0]})
    db.commit()
    return {"message": "Deleted successfully"}
  except SQLAlchemyError as e:
    db.rollback()
    raise HTTPException(500, "Internal server error")
