# MoonTrieKit

MoonTrieKit 是一个面向 MoonBit 的 Trie 前缀树、自动补全与词典检索基础库。

项目聚焦词典构建、前缀匹配、自动补全、短词优先排序、最长公共前缀和检索摘要，适合编辑器提示、命令面板、搜索框、配置键查询、教学算法示例和轻量文本工具复用。

## 当前能力

- `Trie` 词典模型，支持插入、去重、批量构建和数组导出。
- 精确查询 `contains`，前缀判断 `starts_with`，前缀计数 `count_prefix`。
- 自动补全 `complete`，保留插入顺序。
- 短词优先补全 `complete_short_first`，适合命令面板和搜索框提示。
- `LookupResult` 检索摘要，支持 JSON 导出。
- 公共前缀长度分析，支持提示分组和词典压缩场景。
- CLI 演示、CI、Issue 模板和 PR 模板。

## 快速示例

```moonbit nocheck
let dict = @MoonTrieKit.Trie::from_words([
  "moon", "moonbit", "mooncake", "module",
])

let matches = dict.complete_short_first("moo", limit=3)
let lookup = dict.lookup("moon")

println(matches[0])
println(lookup.to_json())
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
- GitLink: 待从 GitHub 导入后填写
