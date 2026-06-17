# MoonTrieKit

MoonTrieKit 是一个面向 MoonBit 的带权词典索引、自动补全与查询解释基础库。

项目聚焦词典构建、前缀匹配、自动补全、带权排序、最长命令前缀匹配、查询 Trace 和检索摘要，适合编辑器提示、命令面板、搜索框、配置键查询、教学算法示例和轻量文本工具复用。

## 当前能力

- `Trie` 词典模型，支持插入、去重、批量构建、数组导出和带权词条。
- `WeightedTerm` 带权词条，支持热度、频次、最近使用等排序因子。
- 精确查询 `contains`，前缀判断 `starts_with`，前缀计数 `count_prefix`。
- 自动补全 `complete`，保留插入顺序。
- 短词优先补全 `complete_short_first`，适合命令面板和搜索框提示。
- 权重优先补全 `complete_ranked`，返回 `CompletionItem` 与可解释分数。
- 最长前缀匹配 `longest_prefix_of`，适合命令路由、配置键和路径式 token 查询。
- `QueryTrace` 查询解释，汇总 exact、prefix_hits、longest_prefix 和 suggestions。
- `LookupResult` 检索摘要，支持 JSON 导出。
- 公共前缀长度分析，支持提示分组和词典压缩场景。
- CLI 演示、CI、Issue 模板和 PR 模板。

## 与已有项目的关系

社区已有 `Yoorkin/trie@0.2.10`，其公开说明是一个简单 Trie 数据结构实现，README 示例集中在 `Trie::of`、`add`、`lookup` 等基础插入和查找能力。

MoonTrieKit 不把目标停留在“基础 Trie 容器”，而是面向开发工具和搜索提示场景提供更上层的词典索引能力：

- 支持带权词条 `WeightedTerm`，可表达热度、频次或推荐权重。
- 支持 `complete_ranked`，返回带 `score` 的 `CompletionItem`，便于命令面板和编辑器提示排序。
- 支持 `longest_prefix_of`，用于命令路由、路径 token 和配置键最长匹配。
- 支持 `QueryTrace`，把一次查询的精确命中、前缀命中数、最长前缀和建议列表导出为 JSON，方便调试和可视化。
- 后续计划继续补节点表后端、删除、分页 top-k、大小写策略和 benchmark，使其成为面向工具链的检索基础库。

## 快速示例

```moonbit nocheck
let dict = @MoonTrieKit.Trie::from_weighted([
  @MoonTrieKit.WeightedTerm::new("moon", 5),
  @MoonTrieKit.WeightedTerm::new("moonbit", 9),
  @MoonTrieKit.WeightedTerm::new("mooncake", 3),
  @MoonTrieKit.WeightedTerm::new("module", 7),
])

let matches = dict.complete_ranked("moo", limit=3)
let trace = dict.explain("moon")

println(matches[0].word)
println(trace.to_json())
```

运行演示：

```bash
moon run cmd/main
```

运行测试：

```bash
moon test
```

## 设计原则

1. 核心库保持后端中立，不依赖浏览器、文件系统或外部搜索服务。
2. API 使用 MoonBit 原生结构体和数组，便于 CLI、编辑器工具和教学示例复用。
3. 公开能力都配套确定性测试，后续可将内部存储替换为节点表而不破坏调用方。

## 仓库

- GitHub: <https://github.com/Zjq963852/MoonTrieKit>
- GitLink: <https://www.gitlink.org.cn/cn-zjq/MoonTrieKit>
