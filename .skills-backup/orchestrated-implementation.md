---
name: orchestrated-implementation
description: 职能执行 + 自我校验
---

# orchestrated-implementation

## 目标

按职能角色执行实现，每个角色按自身流程执行完毕后自我校验交付。

## 输入

- architecture 阶段产出的系统设计 + API 契约
- planning 阶段识别的职能列表

## 执行原则

1. **按计划顺序执行**：除非用户同意，不跳步
2. **调用角色 MD**：将对应角色 MD 作为 system prompt 完整加载
3. **角色自执行**：让角色按自身定义的步骤流程执行
4. **自我校验交付**：角色对照交付模板自检后交付

## 角色执行模板

对每个需要执行的职能：

```markdown
## 执行：[职能名称]

### 角色信息
- **角色路径**：`{category}/{role-name}`
- **角色 MD**：`./agency-agents-zh/{category}/{role-name}.md`

### 调用方式
1. 读取角色 MD，完整加载 system prompt
2. 注入 context：任务描述 + architecture 产出
3. 让角色按自身"工作流程"步骤执行
4. 要求角色对照"交付物模板"自我校验

### Context 注入
将以下信息作为角色 prompt 的前缀：

```
## 任务 Context

### 系统设计
[architecture 阶段产出的完整系统设计文档]

### API 契约
[architecture 阶段定义的所有 API 端点]

### 你的任务
[具体需要这个角色实现的内容]

### 执行要求
1. 按角色 MD 中定义的工作流程步骤执行
2. 步骤执行完毕后，对照"交付物模板"自检
3. 自检通过后，输出完整的交付物
```

### 自我校验清单
角色执行完毕后，必须对照以下清单自检：

- [ ] **交付物完整**：是否包含"交付物模板"中的所有项？
- [ ] **格式合规**：是否符合模板指定的格式？
- [ ] **步骤完整**：角色定义的工作流程步骤是否全部完成？
- [ ] **代码可运行**：如果是代码交付，是否可以正常运行？
- [ ] **文档齐全**：是否包含必要的使用文档？

### 交付物模板（各角色通用）

```markdown
# [项目名称] - [职能名称]

## 实现摘要
[一句话描述实现了什么]

## 交付物列表
- [ ] 代码文件清单
- [ ] 配置文件清单
- [ ] 文档清单

## 关键设计决策
[在这个实现中做的主要决策 + 理由]

## 使用说明
[如何运行、使用]

## 已知限制
[已知的边界条件和限制]

## 下一步（如有）
[如果时间不够，哪些可以后续补充]
```

## 常见职能执行指南

### 后端开发
**角色**：`engineering/engineering-backend-architect`
**MD 路径**：`./agency-agents-zh/engineering/engineering-backend-architect.md`

**执行要点**：
1. 参照 MD 中的"工作流程"：
   - 步骤 1：数据层（Schema + 索引 + 迁移脚本）
   - 步骤 2：业务层（核心业务逻辑）
   - 步骤 3：API 层（端点实现 + 输入验证）
   - 步骤 4：安全（认证 + 授权 + 错误处理）
2. 严格按 architecture 定义的 API 契约实现
3. 产出：代码 + API 文档 + 单元测试

### 前端开发
**角色**：`engineering/engineering-frontend-developer`
**MD 路径**：`./agency-agents-zh/engineering/engineering-frontend-developer.md`

**执行要点**：
1. 参照 MD 中的"工作流程"：
   - 步骤 1：项目搭建和架构
   - 步骤 2：组件开发
   - 步骤 3：性能优化
   - 步骤 4：测试和质量保证
2. 严格按 API 契约调用后端
3. 默认要求：无障碍 + 移动优先 + Core Web Vitals
4. 产出：代码 + 测试报告 + Lighthouse 分数

### 移动开发
**角色**：`engineering/engineering-mobile-app-builder`
**MD 路径**：`./agency-agents-zh/engineering/engineering-mobile-app-builder.md`

### DevOps
**角色**：`engineering/engineering-devops-automator`
**MD 路径**：`./agency-agents-zh/engineering/engineering-devops-automator.md`

## 交付物流转

每个职能交付后，记录：

```markdown
## 交付记录

| 职能 | 角色 | 交付物 | 状态 | 自检通过 |
|------|------|--------|------|---------|
| 后端开发 | backend-architect | 代码 + API 文档 | ✅ 完成 | ✅ |
| 前端开发 | frontend-developer | 代码 + 测试报告 | ✅ 完成 | ✅ |
```

## 遇到问题时的处理

1. **角色执行卡住**：追问角色，提示参考 MD 中的"故障处理"章节
2. **需要补充信息**：回到 architecture 阶段补充设计
3. **发现架构问题**：记录问题，继续执行，标记待处理
4. **无法自检通过**：角色自行返工，直到通过

## 输出

完成所有职能执行后，输出：

```markdown
# Implementation 阶段交付

## 执行摘要
[各职能执行情况]

## 交付物清单

### 后端
- [代码链接]
- [API 文档链接]

### 前端
- [代码链接]
- [测试报告链接]

### 其他
- [如有额外交付物]

## 待解决问题
[执行中发现的问题 + 建议处理方式]

## 进入 Verification
确认所有交付物自检通过，进入测试验证阶段。
```
