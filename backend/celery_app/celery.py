from celery import Celery
from backend.core.config import REDIS_URL

celery_app = Celery(
    "strm",
    broker=REDIS_URL,
    backend=REDIS_URL,
    include=["backend.celery_app.tasks"]
)

celery_app.conf.update(
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",
    timezone="Asia/Shanghai"
)
