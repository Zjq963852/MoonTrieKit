# Changelog

## 0.2.0 - 2026-06-25

- 新增 `RankingPolicy`，支持配置权重、前缀奖励和词长惩罚。
- 新增 `remove`、`set_weight` 和 `increment_weight`。
- 新增 `top_ranked`、`complete_ranked_page`、`ranked_page` 与 `RankedPage`。
- 新增 `DictionaryStats`、统计 JSON 和 `Trie::validate`。
- CLI 增加分页、动态权重、统计和一致性校验演示。
- 测试由 11 个增至 19 个。
- 新增功能证据清单，明确源码、测试和提交的对应关系。

## 0.1.1 - 2026-06-17

- 补充与 `Yoorkin/trie@0.2.10` 的关系说明。
- 新增 `WeightedTerm`、`CompletionItem` 和 `complete_ranked`。
- 新增 `longest_prefix_of` 和 `QueryTrace`。
- 测试增至 11 个。

## 0.1.0 - 2026-06-11

- 初始化 MoonBit 工程、基础词典模型、前缀查询和自动补全。
- 增加 CLI、CI、Issue 模板、PR 模板、路线图和公开开发追踪。
