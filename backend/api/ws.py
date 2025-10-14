from fastapi import WebSocket, WebSocketDisconnect
from fastapi import APIRouter
import json
import redis
from backend.core.config import REDIS_URL

router = APIRouter()
rd = redis.from_url(REDIS_URL, decode_responses=True)

@router.websocket("/ws/log/{task_id}")
async def websocket_log(websocket: WebSocket, task_id: str):
    await websocket.accept()
    pubsub = rd.pubsub()
    await pubsub.subscribe(f"task:{task_id}")
    try:
        async for message in pubsub.listen():
            if message['type'] == 'message':
                await websocket.send_text(message['data'])
    except WebSocketDisconnect:
        await pubsub.unsubscribe()
