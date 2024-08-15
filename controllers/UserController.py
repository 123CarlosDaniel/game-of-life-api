from sqlalchemy import text

def get_users(db):
  result = db.execute(text("SELECT * FROM user")).fetchall()
  users = [
    {
    "id": user.id,
    "name": user.name,
    "username": user.username,
    "emailVerified": user.emailVerified,
    "image": user.image
  } for user in result]
  return users