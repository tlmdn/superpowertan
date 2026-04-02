---
name: orchestrated-planning
description: 职能识别 + 执行计划生成
---

# orchestrated-planning

## 目标

分析用户任务，识别需要的职能组合，生成结构化执行计划。

## 职能候选池

来自 `agency-agents-zh` 项目（路径：`./agency-agents-zh/`）

常用职能映射：

| 任务类型 | 职能路径 |
|---------|---------|
| 前端/Web/界面/表单 | `engineering/engineering-frontend-developer` |
| 后端/API/数据库/服务端 | `engineering/engineering-backend-architect` |
| 移动端/iOS/Android | `engineering/engineering-mobile-app-builder` |
| 架构/系统设计/微服务 | `engineering/engineering-software-architect` |
| 部署/CI/CD/容器/K8s | `engineering/engineering-devops-automator` |
| 测试/验证/回归 | `testing/testing-api-tester` |
| 安全/渗透/漏洞 | `engineering/engineering-security-engineer` |
| 数据管道/ETL | `engineering/engineering-data-engineer` |
| 文档/README | `engineering/engineering-technical-writer` |
| 架构评审/代码评审 | `engineering/engineering-code-reviewer` |
| 产品/需求/PRD | `product/product-manager` |
| UX/交互/可用性 | `design/design-ux-researcher` |
| 品牌/视觉/UI | `design/design-ui-designer` |

## 识别规则

1. **LLM 自主判断**：根据任务关键词、上下文、隐含需求识别职能
2. **每职能必须说明**：
   - 为什么需要这个职能
   - 它的交付物是什么
   - 它依赖哪个阶段的产出
3. **标记并行机会**：哪些职能可以在完成架构阶段后并行执行

## 输出格式

```markdown
# 执行计划 - [任务名称]

## 任务理解
[3-5 句话描述任务：做什么、给谁用、有什么约束]

## 识别的职能

| # | 职能 | 角色路径 | 交付物 | 依赖阶段 | 可并行？ |
|---|------|---------|--------|---------|---------|
| 1 | 架构设计 | engineering/engineering-software-architect | 系统设计文档 + API 契约 | 无 | 否 |
| 2 | 后端开发 | engineering/engineering-backend-architect | 后端代码 | 架构完成 | 否 |
| 3 | 前端开发 | engineering/engineering-frontend-developer | 前端代码 | 架构完成 | 部分（依赖 API） |
| 4 | 测试验证 | testing/testing-api-tester | 测试报告 | 实现完成 | 是 |

## 执行阶段

### 阶段 1：architecture
- 职能：engineering/engineering-software-architect
- 产出：系统设计 + API 契约
- 交付物模板：[见 architecture skill]

### 阶段 2：implementation（后端）
- 职能：engineering/engineering-backend-architect
- 依赖：阶段 1 完成
- 产出：后端代码 + API 文档
- 交付物模板：[见 implementation skill]

### 阶段 3：implementation（前端）
- 职能：engineering/engineering-frontend-developer
- 依赖：阶段 1 完成（API 契约）
- 产出：前端代码
- 交付物模板：[见 implementation skill]

### 阶段 4：verification
- 职能：testing/testing-api-tester
- 依赖：阶段 2 + 阶段 3 完成
- 产出：测试报告
- 交付物模板：[见 verification skill]

### 阶段 5：integration
- 依赖：阶段 4 通过
- 产出：最终交付物

## 并行机会分析

以下阶段存在并行执行的可能：

| 选项 | 描述 | 优点 | 风险 |
|------|------|------|------|
| A | 后端 → 前端（串行） | API 先行，前端无等待 | 总时长 = 后端 + 前端 |
| B | 后端和前端并行 | 总时长缩短 | 需 API 契约足够清晰，否则返工 |

**建议**：除非用户明确要求并行，默认选择选项 A（串行）。

## 执行确认

请确认执行计划：
1. 职能识别是否完整？
2. 并行选项选择哪个？
3. 有无遗漏的职能？

确认后进入架构设计阶段。
```

## 执行时需读取

- 角色 MD 文件：`./agency-agents-zh/{category}/{role}.md`
