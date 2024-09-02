from sqlalchemy.orm import Session
from fastapi import HTTPException, status, Security, Depends
from fastapi.security import APIKeyHeader
from typing import Optional
from jose import JWTError, jwt
from dotenv import load_dotenv
from config.db import get_db
from sqlalchemy import text
import os


load_dotenv()
SECRET_KEY=os.getenv("SECRET_KEY")
ALGORITHM = "HS256"

api_key_header = APIKeyHeader(name="Authorization", auto_error=False)

def get_current_user(
  authorization: Optional[str] = Security(api_key_header),
  db: Session = Depends(get_db),
  ):
  if authorization is None or not authorization.startswith("Bearer "):
    raise_error()
  try:
    token = authorization.split(" ")[1]
    payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    user_id = payload.get("userId")
    if user_id is None:
      raise_error()

    user = db.execute(text("select 1 from user where id = :id"), {"id": user_id}).fetchone()
    if not user:
      return {"error": "User not found"}, 404

    return {"id": user_id}
  except JWTError:
    raise_error()

def get_current_user_optional(
  authorization: Optional[str] = Security(api_key_header),
  db: Session = Depends(get_db),
  ):
  if authorization is None or not authorization.startswith("Bearer "):
    return {"id": None}
  try:
    token = authorization.split(" ")[1]
    payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    user_id = payload.get("userId")
    if user_id is None:
      raise_error()

    user = db.execute(text("select 1 from user where id = :id"), {"id": user_id}).fetchone()
    if not user:
      return {"id": None}

    return {"id": user_id}
  except JWTError:
    raise_error()

def raise_error():
  raise HTTPException(
      status_code=status.HTTP_401_UNAUTHORIZED,
      detail="Could not validate credentials",
      headers={"WWW-Authenticate": "Bearer"},
    )