import db
from models import BaseModel
from sqlmodel import Field
from fastapi import APIRouter


class Fps(BaseModel, table=True):
    fps: int = Field(nullable=False)
    details: str | None = Field()


router = APIRouter()


@router.post("/fps")
async def create_timer_entry(fps: Fps, session: db.SessionDep):
    session.add(fps)
    session.commit()
    session.refresh(fps)
    return fps
