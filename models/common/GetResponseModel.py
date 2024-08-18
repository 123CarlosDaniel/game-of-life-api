from typing import Generic, TypeVar, List
from pydantic import BaseModel

T = TypeVar('T')

class GetResponseModel(BaseModel, Generic[T]):
  data: List[T]
  pages: int