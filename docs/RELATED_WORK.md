# 相关项目与差异说明

核验日期：2026-06-25。

## 社区已有项目

Mooncakes 上已有 `Yoorkin/trie@0.2.10`。其公开定位是 MoonBit 的基础 Trie 数据结构实现，示例主要覆盖构建、插入和查找。

MoonTrieKit 不以复制或替代基础 Trie 容器为目标，而是面向编辑器、命令面板和轻量搜索组件，提供更上层的动态带权词典索引。

## MoonTrieKit 已实现的差异

- `WeightedTerm`：表达使用频次、热度、最近使用或业务推荐权重。
- `CompletionItem` 与 `complete_ranked`：返回词条、权重和可解释分数。
- `RankingPolicy`：允许调整权重系数、前缀奖励和词长惩罚。
- `remove`、`set_weight`、`increment_weight`：支持运行期词典维护。
- `top_ranked`：返回全局热门词条。
- `RankedPage`：提供稳定分页、总命中数和 `has_more`。
- `longest_prefix_of`：支持命令路由、配置键和路径 token。
- `QueryTrace`：将一次查询的精确命中、前缀统计、最长前缀和建议列表导出为 JSON。
- `DictionaryStats` 与 `validate`：提供词典摘要和一致性检查。

## 不夸大的边界

当前底层使用数组保存词条和权重，便于保持 API 清晰并完成正确性验证。项目没有声称当前版本在大规模数据上已经达到压缩 Trie 或专用搜索引擎的性能。

后续将通过节点表、Radix 压缩或可插拔存储优化底层，并用公开 benchmark 验证改进。现阶段的独立价值在于带权维护、排序策略、分页、查询解释和工具链集成接口。

## 证据

所有申报能力必须能在公开源码和测试中找到。逐项证据见 [`EVIDENCE.md`](EVIDENCE.md)。
