from typing import Annotated

from fastapi import Depends
from sqlalchemy import Engine
from sqlmodel import (
    Session,
    create_engine as sql_model_create_engine,
)


def create_engine(*args, **kwargs) -> Engine:
    global _engine
    _engine = sql_model_create_engine(*args, **kwargs)
    return _engine


def get_engine() -> Engine:
    if _engine is None:
        raise RuntimeError("Engine not initialized")
    return _engine


def get_session():
    with Session(get_engine()) as session:
        yield session


SessionDep = Annotated[Session, Depends(get_session)]
_engine: Engine | None = None
