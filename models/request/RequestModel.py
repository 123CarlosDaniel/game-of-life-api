from pydantic import BaseModel

class CommentModel(BaseModel):
  opinion: str
  

class CreationCreateModel(BaseModel):
  title : str
  description : str
  

class ReactionModel(BaseModel):
  reaction: str

class CreationDataModel(BaseModel):
  data: str