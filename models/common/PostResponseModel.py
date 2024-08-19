from pydantic import BaseModel

class PostResponseModel(BaseModel):
  id: str
  message: str