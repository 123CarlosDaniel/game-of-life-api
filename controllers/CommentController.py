from utils.generateId import cuid_generator
from sqlalchemy.orm import Session
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from models.CommentModel import CommentModel
from fastapi import HTTPException


def post_comment(creationId: str, comment: CommentModel, userId: str, db: Session):
  try:
    creation = db.execute(text("SELECT 1 FROM creation WHERE id = :id"),
                          {"id": creationId}).fetchone()

    if not creation:
      raise HTTPException(404, "Not found")

    commentId = cuid_generator.generate()
    db.execute(text("""INSERT INTO comment (id, opinion, ownerId, creationId)
                      VALUES (:id, :opinion, :userId, :creationId)"""),
              {"id": commentId, "opinion": comment.opinion, "userId": userId, "creationId": creationId})
    db.commit()
    return {"id": commentId, "message": "Created successfully"}
  except SQLAlchemyError as e:
    db.rollback()
    return {"error", str(e)}, 500

def delete_comment(commentId: str, userId: str, db: Session):
  comment = db.execute(text("SELECT 1 FROM comment WHERE id = :id and ownerId = :userId"),
                        {"id": commentId, "userId": userId}).fetchone()
  if not comment:
    raise HTTPException(404, "Not found")
  
  db.execute(text("DELETE FROM comment WHERE id = :id"), {"id": commentId})
  db.commit()
  return {"message": "Deleted successfully"}

def update_comment(commentId: str, comment: CommentModel, userId: str, db: Session):
  commentFound = db.execute(text("SELECT 1 FROM comment WHERE id = :id and ownerId = :userId"),
                        {"id": commentId, "userId": userId}).fetchone()
  if not commentFound:
    raise HTTPException(404, "Not found")

  db.execute(text("""UPDATE comment SET opinion = :opinion WHERE id = :id"""), 
             {"opinion": comment.opinion, "id": commentId})

  db.commit()
  return {"message": "Updated successfully"}