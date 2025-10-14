import asyncio
from pathlib import Path
from celery import current_task
from backend.celery_app.celery import celery_app
from backend.services.organize import organize as do_organize

@celery_app.task(bind=True)
def organize_task(self, strm_root: str, output: str, max_ver: int):
    """异步整理 + 实时推送日志"""
    async def _run():
        for pct in range(0, 101, 10):          # 模拟进度
            self.update_state(state='PROGRESS', meta={'percent': pct})
            await asyncio.sleep(0.5)
        # 真实整理逻辑
        do_organize(Path(strm_root), Path(output), max_versions=max_ver)
        return {'percent': 100, 'detail': 'done'}

    loop = asyncio.get_event_loop()
    return loop.run_until_complete(_run())
