from celery import Celery
from backend.celery_app.celery import celery_app
from backend.services.health_check import check_strm_health

@celery_app.on_after_configure.connect
def setup_periodic_tasks(sender, **kwargs):
    # 每天 03:00 执行一次（用户可在 Web 修改）
    sender.add_periodic_task(
        crontab(hour=3, minute=0),
        check_strm_health.s(),
        name='daily-health-check'
    )

@celery_app.task
def check_strm_health():
    from backend.services.health_check import HealthChecker
    checker = HealthChecker()
    checker.run()
