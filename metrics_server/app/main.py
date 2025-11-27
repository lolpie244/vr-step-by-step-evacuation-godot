import os
import db
import metrics
import base_handler

from sqlmodel import SQLModel
from sqlalchemy import URL
from fastapi import FastAPI
from contextlib import asynccontextmanager
from dotenv import load_dotenv

load_dotenv("../.env")

db.create_engine(
    URL.create(
        "postgresql+psycopg2",
        username=os.getenv("DB_USERNAME"),
        password=os.getenv("DB_PASSWORD"),
        host=os.getenv("DB_HOST"),
        port=int(os.getenv("DB_PORT") or ""),
        database=os.getenv("DB_DATABASE"),
    )
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    SQLModel.metadata.create_all(db.get_engine())
    yield


app = FastAPI(lifespan=lifespan)
for router in metrics.ROUTERS:
    app.include_router(router)

app.include_router(base_handler.router)
