# superpowertan

AI 任务编排开发框架 —— SP 外层 + 职能层执行纪律。

## 核心理念

- **SP 外层**：主控流程（planning → architecture → implementation → verification → integration）
- **职能层**：agency-agents-zh 的 180 个角色，按标准流程执行 + 自我校验
- **串行为主**：默认串行执行，并行机会显式抛出给用户决策

## 使用方式

```
/skill superpowertan:orchestrated-development
```

然后输入你的任务，例如：

```
开发一个用户注册功能（含邮箱验证）
```

## 流程阶段

```
用户任务
    ↓
【阶段 1】planning    - 职能识别 + 计划生成
    ↓
【阶段 2】architecture - 系统设计 + API 契约
    ↓
【阶段 3】implementation - 职能执行 + 自我校验
    ↓
【阶段 4】verification  - 测试验证（固定加入）
    ↓
【阶段 5】integration   - 最终联调交付
    ↓
交付物清单
```

## Skills

| Skill | 描述 |
|-------|------|
| `orchestrated-development` | 主入口 |
| `orchestrated-planning` | 职能识别 + 计划生成 |
| `orchestrated-architecture` | 系统设计 + API 契约 |
| `orchestrated-implementation` | 职能执行 + 自我校验 |
| `orchestrated-verification` | 测试验证（固定阶段） |
| `orchestrated-integration` | 最终联调交付 |

## 职能层

角色来自 [agency-agents-zh](https://github.com/jnMetaCode/agency-agents-zh) 项目（180 个 AI 角色）。

详见 [agents/README.md](agents/README.md)。

## 与 Superpowers 的区别

| | Superpowers | superpowertan |
|---|---|---|
| 流程控制 | 单一 skill 的步骤约束 | 多阶段编排 + 职能协作 |
| 角色 | 不涉及 | 调用 180 个专业角色 MD |
| 数据流 | 纯 prompt 上下文 | 阶段间标准化交付物 |
| QA | verification skill | 测试 agent 固定加入 |
| 适用场景 | 单一任务/模块 | 完整功能/系统开发 |

## 安装

```bash
# 克隆项目
git clone https://github.com/your-repo/superpowertan.git

# 或链接到 Claude Code skills 目录
ln -s /home/tlmdn/git_code/superpowertan/skills ~/.claude/skills/superpowertan
```

## 集成角色库

角色定义（180 个 AI 角色）已集成在 `agency-agents-zh/` 目录中，来源：[agency-agents-zh](https://github.com/jnMetaCode/agency-agents-zh)

## License

Apache-2.0
