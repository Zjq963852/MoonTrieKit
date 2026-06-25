# MoonTrieKit

MoonTrieKit 是面向 MoonBit 开发工具的带权词典索引、排序补全与查询解释基础库。它适用于编辑器提示、命令面板、配置键查询、路径式 token 匹配和轻量搜索框。

项目不把目标停留在“实现一个基础 Trie 容器”，而是提供工具链真正需要的动态词典维护、可配置评分、稳定分页、查询轨迹和质量检查。

## 当前能力

- `Trie`：插入、去重、批量构建、删除和数组导出。
- `WeightedTerm`：使用权重表达频次、热度、最近使用或业务推荐因子。
- `set_weight`、`increment_weight`：动态更新排序权重。
- `complete`：按插入顺序完成基础前缀补全。
- `complete_short_first`：优先返回更短的建议。
- `complete_ranked`：根据权重、前缀奖励和词长惩罚排序。
- `RankingPolicy`：公开配置排序参数，避免业务方复制评分算法。
- `top_ranked`：不限定前缀的全局 Top-K。
- `complete_ranked_page`、`ranked_page`：稳定分页、总命中数和 `has_more`。
- `longest_prefix_of`：命令路由、配置键和路径 token 的最长前缀匹配。
- `QueryTrace`：输出精确命中、前缀命中数、最长前缀和排序建议。
- `DictionaryStats`：汇总词条数、总权重、最长词条和零权重词条。
- `validate`：检查词条与权重数组、空词条、负权重和重复词条。

## 快速示例

```moonbit nocheck
let dict = @MoonTrieKit.Trie::from_weighted([
  @MoonTrieKit.WeightedTerm::new("moon", 5),
  @MoonTrieKit.WeightedTerm::new("moonbit", 9),
  @MoonTrieKit.WeightedTerm::new("mooncake", 3),
  @MoonTrieKit.WeightedTerm::new("module", 7),
])

let policy = @MoonTrieKit.RankingPolicy::new(
  weight_factor=1000,
  prefix_bonus=10,
  length_penalty=1,
)
let matches = dict.complete_ranked_with("moo", policy, limit=3)
let page = dict.ranked_page("moo", offset=0, limit=2)
let trace = dict.explain("moon")

println(matches[0].word)
println(page.to_json())
println(trace.to_json())
```

运行：

```bash
moon fmt --check
moon test
moon run cmd/main
```

当前共有 19 个确定性测试。功能与测试的逐项对应关系见 [`docs/EVIDENCE.md`](docs/EVIDENCE.md)。

## 与社区项目的关系

Mooncakes 已有 `Yoorkin/trie@0.2.10`，其定位是基础 Trie 数据结构。MoonTrieKit 不以替代该项目为目标，而是聚焦开发工具的词典索引层：

- 动态带权词典，而非只做基础插入和查询；
- 可配置排序、全局 Top-K 和稳定分页；
- 最长前缀、查询解释和 JSON 调试输出；
- 统计、质量校验和可复核的功能证据。

完整差异说明见 [`docs/RELATED_WORK.md`](docs/RELATED_WORK.md)。

## 仓库

- GitHub: <https://github.com/Zjq963852/MoonTrieKit>
- GitLink: <https://www.gitlink.org.cn/cn-zjq/MoonTrieKit>

## License

Apache-2.0
