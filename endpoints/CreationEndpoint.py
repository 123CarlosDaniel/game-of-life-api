from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from config.db import get_db
from controllers.CreationController import get_creations, post_creation, get_creation, get_creations_by_owner, update_creation, delete_creation
from models.CreationModel import CreationCreateModel
from dependencies.getUser import get_current_user

router = APIRouter(prefix="/creation")


@router.get("")
def creation_get(db: Session = Depends(get_db)):
  return get_creations(db)


@router.get("/{id}")
def creation_get(id, db: Session = Depends(get_db)):
  return get_creation(id, db)


@router.get("")
def creation_by_owner(
  ownerId: str,
  db: Session = Depends(get_db)):
  return get_creations_by_owner(ownerId, db)


@router.post("")
def creation_post(
  creation: CreationCreateModel,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return post_creation(creation, current_user.get("id"), db)


@router.put("/{id}")
def creation_update(
  id: str,
  creation: CreationCreateModel,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return update_creation(id, creation, current_user.get("id"), db)


@router.delete("/{id}")
def creation_delete(
  id: str,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return delete_creation(id, current_user.get("id"), db)
