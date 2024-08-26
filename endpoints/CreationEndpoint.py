from fastapi import APIRouter, Depends, Query 
from sqlalchemy.orm import Session
from config.db import get_db
from controllers.CreationController import get_creations, post_creation, get_creation, get_creations_by_owner, update_creation, delete_creation, save_data, get_data
from models.response import CreationGetAllModel, CreationGetModel, CreationDataGetModel
from models.request import CreationCreateModel, CreationDataModel
from models.common import GetListResponseModel, ErrorResponse, PostResponseModel


from dependencies.getUser import get_current_user, get_current_user_optional

router = APIRouter(prefix="/creation")


@router.get("/all", response_model=GetListResponseModel[CreationGetAllModel],
            responses={
  500: {"model": ErrorResponse, "description": "Internal server error"}
})
def creations_get(
  page: int = Query(1, description="Page number, must be >= 1", ge=1),
  per_page: int = Query(
    10, description="Number of creations per page, must be >= 1", ge=1),
  sort_by: str = Query(
    "asc", description="Sort by 'asc' or 'desc'", enum=["asc", "desc"]),
  current_user: dict = Depends(get_current_user_optional),
  db: Session = Depends(get_db)):
  return get_creations(db, current_user.get("id"), page, per_page, sort_by)


@router.get("/{id}", response_model=CreationGetModel, responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"}
})
def creation_get(
  id: str,
  current_user: dict = Depends(get_current_user_optional),
  db: Session = Depends(get_db)):
  return get_creation(id, current_user.get("id"), db)


@router.get("", response_model=GetListResponseModel[CreationGetAllModel], responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"}
})
def creations_by_owner(
  owner_id: str,
  page: int = Query(1, description="Page number, must be >= 1", ge=1),
  per_page: int = Query(
    10, description="Number of creations per page, must be >= 1", ge=1),
  sort_by: str = Query(
    "asc", description="Sort by 'asc' or 'desc'", enum=["asc", "desc"]),
  current_user: dict = Depends(get_current_user_optional),
  db: Session = Depends(get_db)):
  return get_creations_by_owner(owner_id, page, per_page, sort_by, current_user.get("id"), db)


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
  404: {"model": ErrorResponse, "description": "Not found"},
  401: {"model": ErrorResponse, "description": "Unauthorized"}
})
def creation_update(
  id: str,
  creation: CreationCreateModel,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return update_creation(id, creation, current_user.get("id"), db)


@router.delete("/{id}", responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"},
  401: {"model": ErrorResponse, "description": "Unauthorized"}
})
def creation_delete(
  id: str,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return delete_creation(id, current_user.get("id"), db)


@router.post("/{id}/save_data", responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"},
  401: {"model": ErrorResponse, "description": "Unauthorized"}
})
def creation_save_data(
  id: str,
  data: CreationDataModel,
  current_user: dict = Depends(get_current_user),
  db: Session = Depends(get_db)):
  return save_data(id, data, current_user.get("id"), db)


@router.get("/{id}/get_data",  responses={
  500: {"model": ErrorResponse, "description": "Internal server error"},
  404: {"model": ErrorResponse, "description": "Not found"}
})
def creation_get_data(
  id: str,
  db: Session = Depends(get_db)):
  return get_data(id, db)
