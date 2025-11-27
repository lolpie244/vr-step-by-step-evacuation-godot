from datetime import datetime
from sqlmodel import (
    Field,
    SQLModel,
)


class Client(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    device: str = Field()


class BaseModel(SQLModel, table=False):
    id: int | None = Field(default=None, primary_key=True)
    scene: str | None = Field(index=True, nullable=True)

    client_id: int = Field(default=None, foreign_key="client.id")
    created_at: datetime = Field(default_factory=datetime.now, nullable=False)
