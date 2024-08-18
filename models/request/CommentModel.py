from pydantic import BaseModel

class CommentModel(BaseModel):
  opinion: str