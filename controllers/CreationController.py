from sqlalchemy.orm import Session
from sqlalchemy import text
from utils.generateId import cuid_generator
from sqlalchemy.exc import SQLAlchemyError


def get_creations(db: Session):
  result = db.execute(text("SELECT * FROM creation")).fetchall()
  creations = [
    {
    "id": creation.id,
    "ownerId": creation.ownerId,
    "title": creation.title,
    "description": creation.description,
    "data": creation.data
  } for creation in result]
  return creations

def get_creation(id: str, db: Session):
  result = db.execute(text("SELECT * FROM CREATION WHERE id = :id"), {"id": id}).fetchone()
  creation = {
    "id": result.id,
    "ownerId": result.ownerId,
    "title": result.title,
    "description": result.description,
    "data": result.data
  }
  return creation

def get_creations_by_owner(ownerId: str, db: Session):
  user = db.execute(text("select 1 from user where id = :id"), {"id": ownerId}).fetchone()
  if not user:
    return {"error": "User not found"}, 404
  result = db.execute(text("SELECT * FROM creation where ownerId = :ownerId"), {"ownerId": ownerId}).fetchall()
  creations = [
    {
    "id": creation.id,
    "ownerId": creation.ownerId,
    "title": creation.title,
    "description": creation.description,
    "data": creation.data
  } for creation in result]
  return creations
  
  
def post_creation(creation, userId, db: Session):
  try:
    user = db.execute(text("select 1 from user where id = :id"), {"id": userId}).fetchone()
    if not user:
      return {"error": "User not found"}, 404

    creationId = cuid_generator.generate()
    db.execute(
      text("""INSERT INTO creation (id, ownerId, title, description, data) 
          VALUES (:id, :ownerId, :title, :description, :data)
          """),
      {"id": creationId, 
      "ownerId": userId,
      "title": creation.title,
      "description": creation.description,
      "data": creation.data}
    )
    db.commit()
    return {"id": creationId, "message": "Created successfully"}
  except SQLAlchemyError as e:
    db.rollback()
    return {"error", str(e)}, 500

