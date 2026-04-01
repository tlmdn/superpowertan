# superpowertan - AI 任务编排开发框架

基于 agency-agents-zh 角色库 + SP 执行纪律的编排式开发框架。

## 核心理念

- **SP 外层**：主控流程（planning → architecture → implementation → verification → integration）
- **职能层**：agency-agents-zh 的 180 个角色 MD，按标准流程执行 + 自我校验
- **串行为主**：默认串行执行，并行机会显式抛出给用户决策

## 项目结构

```
superpowertan/
├── skills/                              # Skill 定义
│   ├── orchestrated-development.md       # 主入口
│   ├── orchestrated-planning.md          # 职能识别 + 计划生成
│   ├── orchestrated-architecture.md     # 系统设计
│   ├── orchestrated-implementation.md    # 执行 + 自我校验
│   ├── orchestrated-verification.md     # 测试视角（固定加入）
│   └── orchestrated-integration.md       # 最终交付
└── agency-agents-zh/                    # 角色库（180 个 AI 角色 MD）
    ├── engineering/                      # 工程开发类
    ├── testing/                         # 测试质量类
    └── ...
```

## 使用方式

```bash
# 激活 superpowertan
/skill superpowertan:orchestrated-development

# 输入任务
开发一个用户注册功能（含邮箱验证）
```

## 流程阶段

1. **planning** - LLM 判断需要的职能组合，生成执行计划
2. **architecture** - 架构师产出系统设计 + API 契约
3. **implementation** - 各职能按自身流程执行，自我校验后交付
4. **verification** - 测试工程师验证（固定阶段）
5. **integration** - 最终联调交付

## 职能识别规则

LLM 根据任务关键词和上下文自动识别职能，候选池为 agency-agents-zh 的 180 个角色。

## 角色执行标准

每个角色 MD 必须：
1. 按自身定义的工作流程步骤执行
2. 对照"交付物模板"自我校验
3. 产出标准化交付物供下一阶段使用
