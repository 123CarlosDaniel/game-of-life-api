from pydantic import BaseModel


class CreationGetAllModel(BaseModel):
  id: str
  ownerId: str
  ownerName: str
  ownerImage: str
  title: str
  description: str
  createdAt: str
  updatedAt: str
  reactions: int
  comments: int
  isReactionActive: bool


class CreationGetModel(BaseModel):
  id: str
  ownerId: str
  ownerName: str
  ownerImage: str
  title: str
  description: str
  createdAt: str
  updatedAt: str
  reactions: int
  comments: int
  commentsList: list[dict]
  isReactionActive: bool
  
class CreationDataGetModel(BaseModel):
  data: str