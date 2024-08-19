from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from config.db import get_db
from controllers.CreationController import get_creations, post_creation, get_creation, get_creations_by_owner, update_creation, delete_creation
from models.response import CreationGetAllModel, CreationGetModel
from models.request import CreationCreateModel
from models.common import GetListResponseModel, ErrorResponse, PostResponseModel

from dependencies.getUser import get_current_user, get_current_user_optional

router = APIRouter(prefix="/creation")

@router.get("/all", response_model=GetListResponseModel[CreationGetAllModel], responses={
  500: {"model": ErrorResponse, "description": "Internal server error"}
})
def creations_get(
  page_number: int = Query(1, description="Page number, must be >= 1", ge=1),
  per_page: int = Query(10, description="Number of creations per page, must be >= 1", ge=1),
  sort_by: str = Query("asc", description="Sort by 'asc' or 'desc'", enum=["asc", "desc"]),
  current_user: dict = Depends(get_current_user_optional),
  db: Session = Depends(get_db)):
  return get_creations(db, current_user.get("id"), page_number, per_page, sort_by)


@router.get("/{id}", response_model=CreationGetModel, responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"}
})
def creation_get(
  id: str,
  db: Session = Depends(get_db)):
  return get_creation(id, db)


@router.get("", response_model=GetListResponseModel[CreationGetAllModel], responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"}
})
def creations_by_owner(
  ownerId: str,
  page_number: int = Query(1, description="Page number, must be >= 1", ge=1),
  per_page: int = Query(10, description="Number of creations per page, must be >= 1", ge=1),
  sort_by: str = Query("asc", description="Sort by 'asc' or 'desc'", enum=["asc", "desc"]),
  db: Session = Depends(get_db)):
  return get_creations_by_owner(ownerId, page_number, per_page, sort_by, db)


@router.post("", response_model=PostResponseModel, responses={
  500: {"model": ErrorResponse, "description": "Internal server error"}
})
def creation_post(
  creation: CreationCreateModel,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return post_creation(creation, current_user.get("id"), db)


@router.put("/{id}", responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"}
})
def creation_update(
  id: str,
  creation: CreationCreateModel,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return update_creation(id, creation, current_user.get("id"), db)


@router.delete("/{id}", responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"}
})
def creation_delete(
  id: str,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return delete_creation(id, current_user.get("id"), db)
