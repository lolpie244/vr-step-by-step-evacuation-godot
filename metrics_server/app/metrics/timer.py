import db
from models import BaseModel
from sqlmodel import Field
from fastapi import APIRouter, Request
from typing import List


class Timer(BaseModel, table=True):
    name: str = Field(index=True, nullable=False)
    time_ms: float = Field(nullable=False)
    details: str | None = Field()


router = APIRouter()


@router.post("/timer")
async def create_timer_entry(timer: Timer, session: db.SessionDep):
    session.add(timer)
    session.commit()
    session.refresh(timer)
    return timer


@router.post("/timer/batch")
async def create_timer_batch(timers: List[Timer], session: db.SessionDep):
    session.add_all(timers)
    session.commit()

    for timer in timers:
        session.refresh(timer)

    return timers
