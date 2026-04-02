---
name: orchestrated-development
description: AI 任务编排开发框架主入口 - 输入任务，触发完整开发流程
---

# orchestrated-development

AI 任务编排开发框架的主入口。当你收到一个需要开发的功能/模块/系统时，使用这个 skill。

## 触发条件

当用户提出以下类型的任务时使用：
- "开发一个 XXX 功能"
- "实现 XXX 模块"
- "构建 XXX 系统"
- "做一个 XXX 项目"
- 任何需要设计 + 编码 + 测试的完整开发任务

## 工作流程

```
用户任务
    ↓
【阶段 1】planning - 职能识别 + 计划生成
    ↓
【阶段 2】architecture - 系统设计 + API 契约
    ↓
【阶段 3】implementation - 职能执行 + 自我校验
    ↓
【阶段 4】verification - 测试验证（固定加入）
    ↓
【阶段 5】integration - 最终联调交付
    ↓
【阶段 6】delivery - 交付汇总 + 用户文档
    ↓
完整交付包（老板汇报用）
```

## 阶段详解

### 阶段 1：planning

**目标**：识别完成该任务需要的职能组合，生成执行计划。

**执行**：
1. 读取 `orchestrated-planning.md` skill
2. 分析用户任务，识别需要的职能
3. 列出可选并行的阶段（抛给用户决策）
4. 生成结构化执行计划

**职能识别候选池**：
- 来自 `agency-agents-zh` 项目（180 个角色）
- 路径格式：`category/role-name`（如 `engineering/engineering-frontend-developer`）

**职能识别规则**：
- LLM 根据任务关键词和上下文自动判断
- 每个识别的职能必须说明：为什么需要、交付什么
- 标记哪些可以并行（需架构阶段定义完 API 契约后才能开始）

**输出**：
```markdown
# 执行计划

## 任务理解
[一句话描述任务]

## 识别的职能
| 职能 | 角色 | 交付物 | 可并行？ |
|------|------|--------|---------|
| 前端开发 | engineering/engineering-frontend-developer | 前端代码 | 否（依赖 API 契约） |
| 后端开发 | engineering/engineering-backend-architect | 后端代码 + API 文档 | 否 |
| 测试 | testing/testing-api-tester | 测试报告 | 是（依赖实现完成） |

## 执行顺序
1. [阶段 2] architecture - 架构师产出 API 契约
2. [阶段 3] implementation - 后端开发
3. [阶段 3] implementation - 前端开发（并行机会：否，因依赖 API）
4. [阶段 4] verification - 测试
5. [阶段 5] integration - 联调交付

## 并行机会
以下阶段可以并行执行，需用户确认：
- [ ] 选项 A：后端和前端串行（安全，先定义好 API 再开发前端）
- [ ] 选项 B：后端和前端并行（如果 API 契约足够清晰）
```

### 阶段 2：architecture

**目标**：产出系统设计文档和 API 契约。

**执行**：
1. 读取 `orchestrated-architecture.md` skill
2. 调用相关架构师角色（如 `engineering/engineering-software-architect`）
3. 产出系统设计 + API 契约

**输出**：
```markdown
# 系统设计文档

## 背景与目标
[问题定义 + 成功标准]

## 架构设计
[组件图 + 数据流]

## API 契约
[端点定义 + 请求/响应示例]

## 数据模型
[核心表/集合设计]

## 非功能需求
[性能 + 安全 + 可用性]
```

### 阶段 3：implementation

**目标**：各职能按自身流程执行，自我校验后交付。

**执行**：
1. 读取 `orchestrated-implementation.md` skill
2. 按计划顺序调用各职能角色
3. 每个职能执行自身定义的步骤流程
4. 职能自我对照交付模板校验
5. 产出标准化交付物

**职能执行标准**：
- 调用角色 MD 作为完整 system prompt
- 角色按自身定义的"工作流程"步骤执行
- 执行完毕后，对照"交付物模板"自检
- 自检通过后才算交付完成

### 阶段 4：verification

**目标**：测试视角验证实现是否满足设计。

**执行**：
1. 读取 `orchestrated-verification.md` skill
2. 调用测试工程师角色（如 `testing/testing-api-tester`）
3. 基于 architecture 阶段的 API 契约设计测试用例
4. 逐项验证，产出 PASS/FAIL 报告

**注意**：这是固定阶段，所有流程都必须经过。

### 阶段 5：integration

**目标**：前后端联调，验证完整流程。

**执行**：
1. 读取 `orchestrated-integration.md` skill
2. 联调前后端，验证完整流程
3. 产出部署指南

### 阶段 6：delivery

**目标**：汇总所有产出，打包成完整交付包。

**执行**：
1. 读取 `orchestrated-delivery.md` skill
2. 汇总各阶段交付物
3. 产出用户使用文档
4. 产出最终交付报告

## 完整交付物清单

| # | 交付物 | 负责职能 | 状态 |
|---|--------|---------|------|
| 1 | 系统设计文档 | 软件架构师 | ✅ |
| 2 | 源代码仓库 | 各开发职能 | ✅ |
| 3 | API 文档 | 后端架构师 / 技术文档工程师 | ✅ |
| 4 | 测试报告 | 测试工程师 | ✅ |
| 5 | 用户使用文档 | 技术文档工程师 | ✅ |
| 6 | 最终交付报告 | 主控 skill | ✅ |

## 重要约束

1. **串行为主**：默认串行执行，确保每步交付后再走下一步
2. **自我校验**：每个职能必须对照交付模板自检后才算完成
3. **测试固定**：verification 阶段不可跳过
4. **用户文档必须**：不交付用户文档的项目视为未完成
5. **标准化产出**：每个阶段产出格式相对固定，便于下一阶段使用

## 调用子 skill

依次调用以下 skill：
1. `superpowertan:orchestrated-planning`
2. `superpowertan:orchestrated-architecture`
3. `superpowertan:orchestrated-implementation`
4. `superpowertan:orchestrated-verification`
5. `superpowertan:orchestrated-integration`
6. `superpowertan:orchestrated-delivery`
