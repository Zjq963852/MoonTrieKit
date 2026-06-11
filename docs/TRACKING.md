# MoonTrieKit 公开开发追踪

本文件用于记录比赛阶段的公开开发线索，便于后续在 GitHub / GitLink 上对应提交、工单和合并请求。

## 已完成

- 初始化 MoonBit 包结构和项目元信息。
- 建立 Trie / LookupResult 基础模型。
- 实现插入去重、批量构建和词典导出。
- 实现前缀匹配、前缀计数、自动补全和短词优先补全。
- 实现最长公共前缀分析、检索摘要和 JSON 导出。
- 建立 CLI、CI、Issue 模板、PR 模板和变更记录。

## 建议创建的工单

- `feature: 使用节点表优化 Trie 存储`
- `feature: 增加删除词条能力`
- `feature: 增加权重排序补全`
- `test: 增加大词典性能测试`

## 建议维护节奏

- 每次新增公开 API 后同步补测试。
- 每个阶段至少更新一次 `CHANGELOG.md`。
- 比赛报名或阶段检查前，手动同步 GitHub 与 GitLink。
