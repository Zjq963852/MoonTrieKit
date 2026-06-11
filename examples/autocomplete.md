# Autocomplete Example

目标：从词典中查询指定前缀，返回适合搜索框展示的短词优先建议。

```moonbit nocheck
let dict = @MoonTrieKit.Trie::from_words([
  "moon", "moonbit", "mooncake", "module",
])

let matches = dict.complete_short_first("moo", limit=3)
let lookup = dict.lookup("moon")

println(matches[0])
println(lookup.to_json())
```

示例输出：

```text
moon
{"query":"moon","matched":true,"count":3}
```
