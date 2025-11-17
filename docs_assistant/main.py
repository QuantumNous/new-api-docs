"""
文档自动更新服务主程序
定时更新 changelog 和 special-thanks 文档
"""

import os
import time
import logging
from datetime import datetime
from contributors import update_special_thanks_all_langs
from changelog import update_changelog_all_langs

# 环境变量配置
UPDATE_INTERVAL = int(os.environ.get('UPDATE_INTERVAL', 1800))  # 默认30分钟

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('docs-updater')

UPDATE_TASKS = {
    'contributors': {
        'name': '贡献者和赞助商列表',
        'func': update_special_thanks_all_langs,
        'interval': 3600,
        'last_update': 0
    },
    'changelog': {
        'name': '发布日志',
        'func': update_changelog_all_langs,
        'interval': 1800,
        'last_update': 0
    }
}


def execute_task(task_id, task_config):
    """执行单个更新任务"""
    logger.info(f"开始更新{task_config['name']}")
    try:
        success = task_config['func']()
        if success:
            logger.info(f"{task_config['name']}更新成功")
            return True
        else:
            logger.warning(f"{task_config['name']}更新失败，将在下次更新周期重试")
            return False
    except Exception as e:
        logger.error(f"{task_config['name']}更新异常: {str(e)}")
        return False


def get_next_check_time(tasks):
    """计算下次检查时间"""
    current_time = time.time()
    next_times = [task['last_update'] + task['interval'] for task in tasks.values()]
    next_check = min(next_times) - current_time
    
    if next_check <= 0:
        return 10
    return max(min(next_check, 600), 30)


def main():
    """主函数"""
    logger.info("启动文档更新服务")
    logger.info(f"更新间隔: 贡献者列表={UPDATE_TASKS['contributors']['interval']}秒, "
                f"发布日志={UPDATE_TASKS['changelog']['interval']}秒")
    
    while True:
        try:
            current_time = time.time()
            
            for task_id, task_config in UPDATE_TASKS.items():
                if current_time - task_config['last_update'] >= task_config['interval']:
                    if execute_task(task_id, task_config):
                        task_config['last_update'] = current_time
            
            next_check = get_next_check_time(UPDATE_TASKS)
            logger.info(f"下次检查将在 {next_check:.0f} 秒后进行")
            time.sleep(next_check)
            
        except Exception as e:
            logger.error(f"更新循环出错: {str(e)}")
            time.sleep(300)


if __name__ == "__main__":
    main()
