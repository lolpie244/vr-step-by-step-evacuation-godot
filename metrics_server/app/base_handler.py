import db
import models
from fastapi import APIRouter


router = APIRouter()


@router.post("/client")
async def create_client(client: models.Client, session: db.SessionDep):
    session.add(client)
    session.commit()
    session.refresh(client)
    return client
