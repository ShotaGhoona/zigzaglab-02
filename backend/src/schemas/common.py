from pydantic import BaseModel
from typing import Any, Optional, Dict

class SuccessResponse(BaseModel):
    success: bool = True
    data: Any
    message: str = "Success"

class ErrorResponse(BaseModel):
    success: bool = False
    error: Dict[str, Any]

class PaginationInfo(BaseModel):
    current_page: int
    per_page: int
    total_items: int
    total_pages: int
    has_next: bool
    has_prev: bool

class PaginatedResponse(BaseModel):
    success: bool = True
    data: Dict[str, Any]
    
    @classmethod
    def create(cls, items: list, pagination: PaginationInfo):
        return cls(
            data={
                "items": items,
                "pagination": pagination
            }
        )