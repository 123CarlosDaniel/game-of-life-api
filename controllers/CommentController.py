from utils.generateId import cuid_generator
from sqlalchemy.orm import Session
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from models.CommentModel import CommentModel


def post_comment(creationId: str, comment: CommentModel, userId: str, db: Session):
  try:
    creation = db.execute(text("SELECT 1 FROM creation WHERE id = :id and ownerId = :userId"),
                          {"id": creationId, "userId": userId}).fetchone()

    if not creation:
      return {"error": "Not found"}, 404

    commentId = cuid_generator.generate()
    db.execute(text("""INSERT INTO comment (id, opinion, ownerId, creationId)
                      VALUES (:id, :opinion, :userId, :creationId)"""),
              {"id": commentId, "opinion": comment.opinion, "userId": userId, "creationId": creationId})
    db.commit()
    return {"id": commentId, "message": "Created successfully"}
  except SQLAlchemyError as e:
    db.rollback()
    return {"error", str(e)}, 500
