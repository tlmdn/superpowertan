---
name: orchestrated-verification
description: 测试视角验证（固定阶段）。所有流程都必须经过的测试验证阶段。基于 architecture 阶段的 API 契约设计测试用例，逐项验证并产出 PASS/FAIL 报告。包含开发-测试循环机制，bug 修复后自动返回 implementation。
---

# orchestrated-verification

## 目标

测试视角验证 implementation 阶段的产出，确认满足设计要求。**包含循环机制**：有 bug 时返回 implementation 修复，无 bug 时进入 integration。

## 关键原则

- **这是固定阶段，不可跳过**
- **🔴 1级 + 🟡 2级 bug 必须修复才能继续**
- **🟢 3级 bug 可忽略**
- **有 bug 就循环回 implementation，无 bug 则进入 integration**

## 输入

- architecture 阶段产出的 API 契约
- implementation 阶段各职能的交付物
- 如为循环：implementation 阶段修复后的 bug 上下文

## 角色调用

**主测试角色**：`testing/testing-api-tester`
**MD 路径**：`./agency-agents-zh/testing/testing-api-tester.md`

**辅助测试角色**（按需）：
- `testing/testing-accessibility-auditor`（无障碍验证）
- `testing/testing-performance-benchmarker`（性能验证）
- `testing/testing-reality-checker`（端到端验证）

## 执行流程

```
verification 执行
       ↓
收集 bug 列表
       ↓
🔴 1级 + 🟡 2级 > 0 ?  ──→ 是 ──→ 记录 bug 上下文
       ↓ 否                      ↓
   进入 integration        抛给用户确认
                                ↓
                          用户确认后
                                ↓
                    返回 implementation
                          携带 bug 上下文
```

### 1. 测试规划

基于 architecture 阶段的 API 契约，设计测试用例：

```markdown
## 测试规划

### 测试范围
- API 端点覆盖：[列出所有需要测试的端点]
- 场景覆盖：[正常路径 + 异常路径]
- 边界条件：[列出边界测试用例]

### 测试用例设计

| TC-ID | 端点 | 场景 | 输入 | 预期输出 |
|-------|------|------|------|---------|
| TC-01 | POST /api/v1/users | 正常注册 | 合法用户信息 | 201 + 用户数据 |
| TC-02 | POST /api/v1/users | 重复邮箱 | 已存在邮箱 | 409 + 错误码 |
| TC-03 | POST /api/v1/users | 非法格式 | 缺少必填字段 | 400 + 校验错误 |
| ... | ... | ... | ... | ... |
```

### 2. 逐项执行测试

按以下顺序执行：

#### 功能测试
- API 端点是否按契约实现
- 请求/响应格式是否匹配
- 错误码是否正确返回

#### 无障碍测试（如涉及前端）
- WCAG 2.1 AA 合规
- 键盘导航支持
- 屏幕阅读器兼容

#### 性能测试
- API 响应时间是否达标
- 并发处理能力

### 3. Bug 严重级别

对于每个 FAIL 的测试用例，使用以下严重级别判断：

#### 🔴 1级：致命/阻塞 (Critical & Blocker)

**定义**：系统核心功能不可用，或存在重大安全/性能隐患。

**技术表现**：进程崩溃（Panic/OOM）、死锁、核心 API 4xx/5xx、关键数据计算错误（算错钱、删错库）。

**业务影响**：阻塞集成测试进度，无法进入下一阶段；或者上线后会造成重大事故。

**判断准则**："如果不修，系统就无法交付或存在法律/安全风险。"

#### 🟡 2级：严重/受限 (Major & Impaired)

**定义**：功能实现不完整，或者代码质量严重低下导致维护困难。

**技术表现**：边界情况（Corner Case）未处理导致逻辑错误、严重的性能瓶颈、代码逻辑极其混乱（不可读）、未遵循核心架构模式。

**业务影响**：用户主流程勉强能跑通，但体验极差或在特殊条件下会失败；增加了巨大的技术债。

**判断准则**："可以跑通 Demo，但不能作为稳定版本发布。"

#### 🟢 3级：轻微/建议 (Minor & Suggestion)

**定义**：不影响逻辑运行，属于代码洁癖，规范或小瑕疵。

**技术表现**：变量命名不规范、魔法数字未定义常量、注释拼写错误、多余的空行、可以优化的语法糖。

**业务影响**：用户无感知，不影响功能，仅影响开发人员的协作效率。

**判断准则**："修了更好，不修也能上线，建议随手改掉。"

### 4. 循环决策

执行完测试后，根据 bug 数量决定：

#### 情况 A：有 🔴 1级 或 🟡 2级 bug

**Bug 上下文格式**：
```json
{
  "phase": "verification",
  "loop_count": 1,
  "bugs": [
    {
      "severity": "🔴 1级",
      "tc_id": "TC-05",
      "description": "PATCH /api/todos/:id 对不存在 ID 返回 500 而非 404",
      "location": "src/routes/todos.js:42",
      "reproduce": "curl -X PATCH http://localhost:3000/api/todos/nonexistent-id -d '{}'",
      "suggested_fix": "添加 existence check 后返回 404"
    }
  ],
  "recommend": "return_to_implementation"
}
```

**输出给用户**：
```markdown
## 🔄 循环决策

**发现 🔴 1级 + 🟡 2级 bug 共 N 个**

| # | 严重级 | TC-ID | 问题描述 |
|---|--------|-------|---------|
| 1 | 🔴 1级 | TC-05 | PATCH /api/todos/:id 对不存在 ID 返回 500 |
| 2 | 🟡 2级 | TC-12 | 响应时间超过 200ms 阈值 |

**建议**：返回 implementation 阶段修复这些问题

**选项**：
- [A] 继续修复（进入 implementation）
- [B] 跳过这些问题（需明确说明原因，不推荐）
```

用户选择后，携带 bug 上下文返回 implementation 阶段。

#### 情况 B：仅有 🟢 3级 bug 或无 bug

```markdown
## ✅ QA 通过

- 🔴 1级 bug：0
- 🟡 2级 bug：0
- 🟢 3级 bug：N（可忽略）

**可以进入 integration 阶段**
```

## 输出格式

```markdown
# Verification 阶段报告

## 测试摘要
- **测试用例总数**：N
- **通过**：M
- **失败**：K
- **通过率**：X%
- **循环次数**：N

## 测试结果

### 功能测试
| TC-ID | 端点 | 场景 | 结果 |
|-------|------|------|------|
| TC-01 | POST /api/v1/users | 正常注册 | ✅ PASS |
| TC-02 | POST /api/v1/users | 重复邮箱 | ✅ PASS |
| TC-03 | POST /api/v1/users | 非法格式 | ✅ PASS |

### 无障碍测试（如适用）
| 检查项 | 结果 |
|--------|------|
| WCAG 2.1 AA | ✅ 通过 |
| 键盘导航 | ✅ 通过 |
| 屏幕阅读器 | ⚠️ 需优化 |

### 性能测试
| 指标 | 目标 | 实际 | 结果 |
|------|------|------|------|
| P95 响应时间 | < 200ms | 150ms | ✅ 达标 |

## 问题清单

### 🔴 1级问题（阻塞 - 必须修复）
| # | 问题 | 位置 | 建议修复 |
|---|------|------|---------|
| 1 | [问题] | [位置] | [建议] |

### 🟡 2级问题（受限 - 应该修复）
| # | 问题 | 位置 | 建议修复 |
|---|------|------|---------|
| 1 | [问题] | [位置] | [建议] |

### 🟢 3级问题（建议 - 可忽略）
| # | 问题 | 位置 | 建议修复 |
|---|------|------|---------|
| 1 | [问题] | [位置] | [建议] |

## QA 结论

**最终判定**：✅ PASS / ❌ FAIL / 🔄 LOOP

- **✅ PASS**：无 🔴 1级 + 🟡 2级 bug，进入 integration
- **❌ FAIL**：存在未解决的 🔴 1级 bug，阻塞流程
- **🔄 LOOP**：存在 🟡 2级 bug，返回 implementation

## 测试证据
[截图 / curl 示例 / 日志等证据链接]
```

## 循环返回 implementation 时的指令

当决定返回 implementation 时，输出：

```markdown
# 🔄 返回 implementation

## Bug 上下文（用于 implementation 修复）

```json
{
  "phase": "verification",
  "loop_count": {N},
  "bugs": [...],
  "recommend": "return_to_implementation"
}
```

## 对 implementation 的指令

请根据上述 bug 列表，修复每个 🔴 1级 和 🟡 2级 问题。

修复完成后，重新进入 verification 阶段验证。
```

## 通过条件

- 所有 🔴 1级（阻塞）问题已解决
- 所有 🟡 2级（受限）问题已解决（或明确记录暂不处理的原因）
- 🟢 3级（建议）问题可忽略
- 功能测试用例 100% 通过
- 无障碍和性能测试达到目标（如果适用）
