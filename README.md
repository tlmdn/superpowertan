# superpowertan

AI 任务编排开发框架 —— SP 外层 + 职能层执行纪律。

## 核心理念

- **SP 外层**：主控流程（planning → architecture → implementation → verification → integration → delivery）
- **职能层**：agency-agents-zh 的 180 个角色，按标准流程执行 + 自我校验
- **串行为主**：默认串行执行，并行机会显式抛出给用户决策

## 适用场景

当你需要**完整开发一个功能/模块/系统**时使用，而不是单一任务。

例如：
- "开发一个用户注册功能（含邮箱验证）"
- "实现订单管理模块"
- "构建一个内部管理系统"

## 安装

### 方式一：本地链接（推荐用于开发）

```bash
# 1. 克隆或复制项目到本地
git clone https://github.com/your-repo/superpowertan.git /path/to/superpowertan

# 2. 链接到 Claude Code skills 目录
mkdir -p ~/.claude/skills/superpowertan
ln -s /path/to/superpowertan/skills/* ~/.claude/skills/superpowertan/
```

### 方式二：直接复制

如果你不需要更新，只是使用：

```bash
# 复制 skills 到 Claude Code 配置目录
cp -r /path/to/superpowertan/skills/* ~/.claude/skills/
```

### 验证安装

在 Claude Code 中运行：

```
/skills
```

应该能看到 `superpowertan` 下的 7 个 skill。

## 使用方式

### 激活主 skill

```
/skill superpowertan:orchestrated-development
```

然后直接输入你的开发任务：

```
开发一个 TODO 列表功能（前端 + 后端）
```

### 流程阶段

```
用户任务
    ↓
【阶段 1】planning      - 职能识别 + 计划生成
    ↓
【阶段 2】architecture  - 系统设计 + API 契约
    ↓
【阶段 3】implementation - 职能执行 + 自我校验
    ↓
【阶段 4】verification  - 测试验证（固定加入）
    ↓
【阶段 5】integration   - 最终联调交付
    ↓
【阶段 6】delivery     - 交付汇总 + 用户文档
    ↓
完整交付包（6 项产出）
```

## Skills

| Skill | 描述 |
|-------|------|
| `orchestrated-development` | 主入口（调用其他 6 个 skill） |
| `orchestrated-planning` | 职能识别 + 计划生成 |
| `orchestrated-architecture` | 系统设计 + API 契约 |
| `orchestrated-implementation` | 职能执行 + 自我校验 |
| `orchestrated-verification` | 测试验证（固定阶段） |
| `orchestrated-integration` | 最终联调交付 |
| `orchestrated-delivery` | 交付汇总 + 用户文档 |

## 完整交付物清单

| # | 交付物 | 说明 |
|---|--------|------|
| 1 | 系统设计文档 | 架构设计 + API 契约 + 数据模型 |
| 2 | 源代码 | 可运行的完整代码 |
| 3 | API 文档 | 开发者接口说明 |
| 4 | 测试报告 | QA 验证结果 |
| 5 | 用户使用文档 | 操作手册 |
| 6 | 最终交付报告 | 汇总 + 验收确认 |

## 项目结构

```
superpowertan/
├── skills/                          # 7 个 skill 定义
│   ├── orchestrated-development.md
│   ├── orchestrated-planning.md
│   ├── orchestrated-architecture.md
│   ├── orchestrated-implementation.md
│   ├── orchestrated-verification.md
│   ├── orchestrated-integration.md
│   └── orchestrated-delivery.md
├── agency-agents-zh/               # 角色库（180 个 AI 角色 MD）
│   ├── engineering/                # 工程开发类
│   ├── testing/                   # 测试质量类
│   ├── product/                  # 产品设计类
│   └── ...（共 16 个类别）
├── CLAUDE.md                      # 项目说明（Claude Code 自动读取）
├── README.md                      # 本文件
└── LICENSE
```

## 与 Superpowers 的区别

| | Superpowers | superpowertan |
|---|---|---|
| 流程控制 | 单一 skill 的步骤约束 | 多阶段编排 + 职能协作 |
| 角色 | 不涉及 | 调用 180 个专业角色 MD |
| 数据流 | 纯 prompt 上下文 | 阶段间标准化交付物 |
| QA | verification skill | 测试 agent 固定加入 |
| 适用场景 | 单一任务/模块 | 完整功能/系统开发 |
| 交付物 | 无固定格式 | 6 项标准交付物 |

## 集成角色库

角色定义（180 个 AI 角色）已集成在 `agency-agents-zh/` 目录中。

来源：[agency-agents-zh](https://github.com/jnMetaCode/agency-agents-zh)

## 同步角色库更新

如需同步原始项目的最新角色：

```bash
cd /path/to/superpowertan
rm -rf agency-agents-zh
git clone https://github.com/jnMetaCode/agency-agents-zh.git agency-agents-zh
rm -rf agency-agents-zh/.git
```

## License

Apache-2.0
