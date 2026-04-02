---
name: orchestrated-delivery
description: 最终交付汇总 + 产出门户
---

# orchestrated-delivery

## 目标

汇总各阶段产出，打包成完整的交付物，供用户/甲方/老板确认。

## 前置条件

- architecture 阶段完成
- implementation 阶段完成（所有职能自我校验通过）
- verification 阶段通过（🔴1级和🟡2级问题已修复）
- integration 阶段完成

## 输入

- planning 阶段的执行计划
- architecture 阶段的系统设计文档
- implementation 阶段的各职能交付物
- verification 阶段的测试报告
- integration 阶段的联调结果

## 交付物清单

### 1. 系统设计文档
来源：architecture 阶段

包含：
- 背景与目标
- 架构设计
- API 契约（含完整请求/响应示例）
- 数据模型
- 非功能需求

### 2. 代码仓库
来源：implementation 阶段

包含：
- 完整源代码（Git 仓库链接）
- 环境配置说明
- 本地运行指南

### 3. API 文档
来源：implementation 阶段（技术文档工程师职能）

包含：
- 所有端点说明
- 请求/响应格式
- 错误码表
- 认证方式（如需要）
- 示例代码（cURL / JavaScript / Python）

### 4. 测试报告
来源：verification 阶段

包含：
- 测试摘要（用例数、通过率）
- 测试结果明细
- 问题清单（含严重级别）
- QA 结论

### 5. 用户使用文档 ← 新增
来源：implementation 阶段或专门的技术文档工程师

根据项目类型产出：

#### Web/App
```markdown
# 用户操作手册

## 功能概览
[截图 + 功能列表]

## 快速开始
[3 步上手指南]

## 功能说明
### 功能 1
- 入口：[在哪里找到]
- 操作：[怎么做]
- 预期：[结果]

## 常见问题
| 问题 | 解答 |
|------|------|
| ... | ... |
```

#### API 服务
```markdown
# API 使用指南

## 快速开始
[获取 Token → 调用接口]

## 接口列表
### POST /api/v1/resource
- 说明：
- 参数：
- 示例：

## SDK（如有）
- npm install xxx
- 使用示例
```

#### CLI 工具
```markdown
# 命令参考

## 安装
```bash
npm install -g xxx
```

## 命令
### xxx create
创建新资源

```bash
xxx create [options]
```

选项：
- `--name`：名称
- `--type`：类型

## 示例
```bash
xxx create --name my-project
```
```

### 6. 最终交付报告
汇总所有交付物，格式如下：

## 输出格式

```markdown
# 项目交付报告 - [项目名称]

## 项目信息
- **项目名称**：[名称]
- **交付日期**：[日期]
- **版本**：[版本号]
- **交付周期**：[从哪天到哪天]

## 交付物清单

| # | 交付物 | 位置/链接 | 状态 |
|---|--------|----------|------|
| 1 | 系统设计文档 | [链接] | ✅ |
| 2 | 源代码仓库 | [链接] | ✅ |
| 3 | API 文档 | [链接] | ✅ |
| 4 | 测试报告 | [链接] | ✅ |
| 5 | 用户使用文档 | [链接] | ✅ |

## 验收确认

- [x] 系统设计文档已提供
- [x] 代码可正常运行
- [x] API 文档完整准确
- [x] 测试全部通过（🔴1级🟡2级问题已修复）
- [x] 用户文档齐全

## 遗留问题

如有未解决问题：

| # | 问题 | 严重级别 | 影响 | 处理方式 |
|---|------|---------|------|---------|
| 1 | [问题] | 🟡 2级 | [影响] | [处理] |

## 下一步（如有）

[后续迭代计划 / 维护建议]

---

**项目经理**：[名字]
**日期**：[YYYY-MM-DD]
```

## 职责划分

| 交付物 | 负责职能 | 说明 |
|--------|---------|------|
| 系统设计文档 | 软件架构师 | engineering/engineering-software-architect |
| 源代码 | 各开发职能 | 按 implementation 阶段角色 |
| API 文档 | 后端架构师 / 技术文档工程师 | engineering/engineering-backend-architect 或 engineering/engineering-technical-writer |
| 测试报告 | 测试工程师 | testing/testing-api-tester |
| 用户使用文档 | 技术文档工程师 | engineering/engineering-technical-writer |

## 重要约束

1. **用户文档是必须交付物**：不交付用户文档的项目视为未完成
2. **遗留问题必须透明**：有就是有，不能隐瞒
3. **交付物必须可访问**：提供链接或文件路径，不能说"在我本地"
