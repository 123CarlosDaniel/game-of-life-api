from typing import Generic, TypeVar, List
from pydantic import BaseModel

T = TypeVar('T')

class GetListResponseModel(BaseModel, Generic[T]):
  data: List[T]
  pages: int