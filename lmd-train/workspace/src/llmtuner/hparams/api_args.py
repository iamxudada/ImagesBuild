from dataclasses import dataclass, field, asdict
from typing import Any, Dict


@dataclass
class ApiArguments:
    r"""
    训练或推理保存参数
    """
    task_id: str = field(
        default=None,
        metadata={"help": "任务id"}
    )
    api_url: str = field(
        default=None,
        metadata={"help": "api地址"}
    )

    def __post_init__(self):
        # print(self.task_id)
        if self.task_id is None:
            raise ValueError("task_id不允许为空")
        # print(self.api_url)
        if self.api_url is None:
            raise ValueError("api_url不允许为空")

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)
