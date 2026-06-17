# Changelog

## 0.1.1 - 2026-06-17

- 补充与 `Yoorkin/trie@0.2.10` 的关系说明，明确项目不只是基础 Trie 容器。
- 新增 `WeightedTerm`，支持带权词典构建和权重查询。
- 新增 `CompletionItem` 与 `complete_ranked`，支持权重优先、短词补偿的排序补全。
- 新增 `longest_prefix_of`，支持命令路由、路径 token 和配置键最长匹配。
- 新增 `QueryTrace`，支持输出 exact、prefix_hits、longest_prefix 和 suggestions。
- 更新 CLI 演示与测试，当前 MoonBit 测试扩展到 11 个。

## 0.1.0 - 2026-06-11

- 初始化 MoonTrieKit 项目结构和元信息。
- 增加 Trie、LookupResult、插入去重、批量构建和数组导出。
- 增加前缀匹配、前缀计数、自动补全和短词优先补全。
- 增加最长公共前缀分析、检索摘要和 JSON 导出。
- 增加 CLI 演示、CI 配置、Issue 模板和 PR 模板。
- 增加 README、路线图、公开开发追踪和示例文档。
