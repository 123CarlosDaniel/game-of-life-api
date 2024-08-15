from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from config.db import get_db
from controllers.UserController import get_users

router = APIRouter(prefix="/user")

@router.get("")
def users_get(db: Session = Depends(get_db)):
  return get_users(db)

