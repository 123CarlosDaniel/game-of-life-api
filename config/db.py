from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_PORT = os.getenv("DB_PORT")
DB_DATABASE = os.getenv("DB_DATABASE")

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_DATABASE}"

engine = create_engine(DATABASE_URL)

session = sessionmaker(bind=engine, autocommit=False, autoflush=False)

def get_db():
  db = session()
  try:
    yield db
  finally:
    db.close()