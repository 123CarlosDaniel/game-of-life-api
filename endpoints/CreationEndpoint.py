from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from config.db import get_db
from controllers.CreationController import get_creations, post_creation, get_creation, get_creations_by_owner, update_creation, delete_creation
from models.request.CreationModel import CreationCreateModel
from models.response.CreationGetAllModel import CreationGetAllModel
from models.common.ErrorResponseModel import ErrorResponse
from dependencies.getUser import get_current_user

router = APIRouter(prefix="/creation")

@router.get("/all", response_model=CreationGetAllModel, responses={
  500: {"model": ErrorResponse, "description": "Internal server error"}
})
def creations_get(
  page_number: int = Query(1, description="Page number, must be >= 1", ge=1),
  per_page: int = Query(10, description="Number of creations per page, must be >= 1", ge=1),
  sort_by: str = Query("asc", description="Sort by 'asc' or 'desc'", enum=["asc", "desc"]),
  db: Session = Depends(get_db)):
  return get_creations(db, page_number, per_page, sort_by)


@router.get("/{id}")
def creation_get(
  id: str,
  db: Session = Depends(get_db)):
  return get_creation(id, db)


@router.get("")
def creations_by_owner(
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
