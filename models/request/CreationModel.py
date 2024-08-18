from pydantic import BaseModel

class CreationCreateModel(BaseModel):
  title : str
  description : str
  data : str