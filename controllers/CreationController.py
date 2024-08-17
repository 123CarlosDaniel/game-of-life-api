from sqlalchemy.orm import Session
from sqlalchemy import text
from utils.generateId import cuid_generator
from sqlalchemy.exc import SQLAlchemyError
from fastapi import HTTPException


def get_creations(db: Session, page_number: int, per_page: int, sort_by: str):
  try:
    result = db.execute(text("CALL creations_get_sp(:page_number, :per_page, :sort_by, @pages)"),
                        {"page_number": page_number, "per_page": per_page, "sort_by": sort_by})
    pages = db.execute(text("SELECT @pages")).scalar()
    creations = result.fetchall()
    creations = [
      {
          "id": creation.creation_id,
          "ownerId": creation.owner_id,
          "ownerName": creation.owner_name,
          "ownerImage": creation.owner_image,
          "title": creation.title,
          "description": creation.description,
          "data": creation.data,
          "createdAt": creation.creation_createdAt,
          "updatedAt": creation.creation_updatedAt,
          "reactions": creation.reaction_count,
          "comments": creation.comments
      } for creation in creations]
    return {
      "data": creations,
      "pages": pages
    }
  except SQLAlchemyError as e:
    raise HTTPException(500, "Internal server error")


def get_creation(id: str, db: Session):
  result = db.execute(
    text("SELECT * FROM CREATION WHERE id = :id"), {"id": id}).fetchone()
  if not result:
    raise HTTPException(404, "Not found")
  creation = {
    "id": result.id,
    "ownerId": result.ownerId,
    "title": result.title,
    "description": result.description,
    "data": result.data
  }
  return creation


def get_creations_by_owner(ownerId: str, db: Session):
  user = db.execute(text("select 1 from user where id = :id"),
                    {"id": ownerId}).fetchone()
  if not user:
    raise HTTPException(404, "Not found")
  result = db.execute(text(
    "SELECT * FROM creation where ownerId = :ownerId"), {"ownerId": ownerId}).fetchall()
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
    raise HTTPException(500, "Internal server error")


def update_creation(id, creation, userId, db: Session):
  creation_found = db.execute(text("SELECT 1 FROM creation WHERE id = :id AND ownerId = :ownerId"),
                              {"id": id, "ownerId": userId}).fetchone()
  if not creation_found:
    raise HTTPException(404, "Not found")

  db.execute(text("""
                  UPDATE creation SET title = :title, description = :description, data = :data
                  WHERE id = :id
                  """), {"id": id, "title": creation.title, "description": creation.description, "data": creation.data})

  db.commit()
  return {"message": "Updated successfully"}


def delete_creation(id, userId, db: Session):
  creation_found = db.execute(text("SELECT 1 FROM creation WHERE id = :id AND ownerId = :ownerId"),
                              {"id": id, "ownerId": userId}).fetchone()
  if not creation_found:
    raise HTTPException(404, "Not found")

  db.execute(text("DELETE FROM creation WHERE id = :id"), {"id": id})

  db.commit()
  return {"message": "Deleted successfully"}
