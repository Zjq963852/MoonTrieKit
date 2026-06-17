# Autocomplete Example

目标：从带权词典中查询指定前缀，返回适合搜索框和命令面板展示的排序建议。

```moonbit nocheck
let dict = @MoonTrieKit.Trie::from_weighted([
  @MoonTrieKit.WeightedTerm::new("moon", 5),
  @MoonTrieKit.WeightedTerm::new("moonbit", 9),
  @MoonTrieKit.WeightedTerm::new("mooncake", 3),
  @MoonTrieKit.WeightedTerm::new("module", 7),
])

let matches = dict.complete_ranked("moo", limit=3)
let trace = dict.explain("moon", limit=3)

println(matches[0].word)
println(trace.to_json())
```

示例输出：

```text
moonbit
{"query":"moon","exact":true,"prefix_hits":3,"longest_prefix":"moon","suggestions":[...]}
```
