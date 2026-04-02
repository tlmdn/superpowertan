---
name: orchestrated-architecture
description: 系统设计与 API 契约产出。当进入架构设计阶段时使用，调用架构师角色产出系统设计文档、数据模型、API 契约。定义清晰的接口供后续 implementation 阶段使用。
---

# orchestrated-architecture

## 目标

产出系统设计文档和 API 契约，作为后续 implementation 阶段的依据。

## 输入

- planning 阶段识别的架构师职能
- 用户任务的详细描述

## 角色调用

调用 `engineering/engineering-software-architect` 或相关架构师角色。

读取角色 MD：
```
./agency-agents-zh/engineering/engineering-software-architect.md
```

## 执行流程

1. **理解任务**：细读用户任务描述，确认背景和目标
2. **系统设计**：产出系统架构文档
3. **API 契约**：定义清晰的接口规范（供前端并行开发）
4. **数据模型**：核心表/集合设计
5. **非功能需求**：性能、安全、可用性目标

## 输出格式

```markdown
# 系统设计文档 - [项目/模块名称]

## 1. 背景与目标

### 问题陈述
[要解决什么问题]

### 成功标准
- [可量化的指标]
- [可验收的条件]

### 约束条件
- 技术约束（如必须用某技术栈）
- 业务约束（如某时间点上线）
- 资源约束（如人员、预算）

## 2. 架构设计

### 系统架构图
[文字描述组件和关系]

### 核心组件
| 组件 | 职责 | 技术选型 |
|------|------|---------|
| API Gateway | 请求路由、认证 | - |
| Backend Service | 业务逻辑 | - |
| Database | 数据存储 | - |
| Cache | 热点数据缓存 | - |

### 通信模式
- 同步：[REST / gRPC / GraphQL]
- 异步：[消息队列 / 事件驱动]

## 3. API 契约

### 核心端点

#### [POST] /api/v1/resource
**描述**：[创建资源]

**请求**：
```json
{
  "field1": "string - 字段1说明",
  "field2": "number - 字段2说明"
}
```

**响应（成功 201）**：
```json
{
  "id": "string - 资源ID",
  "field1": "string",
  "field2": "number",
  "createdAt": "ISO8601 时间戳"
}
```

**响应（错误 400）**：
```json
{
  "ok": false,
  "error": "string - 错误信息",
  "code": "VALIDATION_ERROR"
}
```

#### [GET] /api/v1/resource/{id}
**描述**：[获取单个资源]

**响应（成功 200）**：[同上结构]

**响应（错误 404）**：
```json
{
  "ok": false,
  "error": "Resource not found",
  "code": "NOT_FOUND"
}
```

### 错误码规范
| 错误码 | HTTP 状态 | 说明 |
|--------|----------|------|
| VALIDATION_ERROR | 400 | 输入校验失败 |
| NOT_FOUND | 404 | 资源不存在 |
| UNAUTHORIZED | 401 | 未认证 |
| FORBIDDEN | 403 | 无权限 |
| INTERNAL_ERROR | 500 | 服务器内部错误 |

## 4. 数据模型

### 实体设计

#### User
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK | 主键 |
| email | VARCHAR(255) | UNIQUE, NOT NULL | 邮箱 |
| passwordHash | VARCHAR(255) | NOT NULL | 密码哈希 |
| createdAt | TIMESTAMP | NOT NULL | 创建时间 |
| updatedAt | TIMESTAMP | NOT NULL | 更新时间 |

### 索引设计
| 索引 | 字段 | 类型 | 用途 |
|------|------|------|------|
| idx_users_email | email | UNIQUE | 登录查询 |
| idx_users_created | createdAt | INDEX | 排序查询 |

## 5. 非功能需求

### 性能目标
- API 响应时间 P95 < 200ms
- 数据库查询时间 < 50ms
- 支持 1000 QPS

### 安全要求
- 密码 bcrypt 加密
- JWT token 认证
- 输入参数校验
- SQL 注入防护

### 可用性目标
- 系统可用性 > 99.9%
- 错误率 < 0.1%

## 6. 技术决策记录

| 决策 | 选择 | 备选 | 理由 |
|------|------|------|------|
| 数据库 | PostgreSQL | MySQL | JSON 支持更好 |
| 缓存 | Redis | Memcached | 支持更多数据结构 |

## 7. 部署架构

[如涉及部署，描述容器化方案、K8s 配置等]

---

## 交付确认

架构设计文档完成后，对照检查：

- [ ] API 端点定义完整（CRUD + 错误码）
- [ ] 请求/响应格式清晰可执行
- [ ] 数据模型包含必要索引
- [ ] 非功能需求可量化
- [ ] 技术决策有明确理由

通过后进入 implementation 阶段。
```

## 关键约束

1. **API 契约必须清晰**：前端开发依赖这些契约，不要留模糊定义
2. **错误码必须完整**：覆盖所有可能的失败场景
3. **数据模型必须标注索引**：否则 implementation 阶段需要回头确认
