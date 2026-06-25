# MoonTrieKit 功能证据清单

核验日期：2026-06-25。

| 申报能力 | 公开源码符号 | 对应测试 | 引入提交 |
| --- | --- | --- | --- |
| 带权词条 | `WeightedTerm`、`from_weighted`、`weight_of` | `weighted dictionaries preserve payload and de-duplicate words` | `6cae189` |
| 排序补全 | `CompletionItem`、`complete_ranked` | `ranked completion prefers weight then compact terms` | `6cae189` |
| 查询解释 | `QueryTrace`、`explain`、`to_json` | `query trace explains exact match longest prefix and suggestions` | `6cae189` |
| 动态词典维护 | `remove`、`set_weight`、`increment_weight` | `dictionary mutation keeps words and weights aligned` | `6f86eff` |
| 可配置评分 | `RankingPolicy`、`complete_ranked_with` | `ranking policy can favor compact terms over weight` | `6f86eff` |
| 全局 Top-K | `top_ranked` | `top ranked returns global weighted suggestions` | `6f86eff` |
| 排序分页 | `complete_ranked_page`、`ranked_page`、`RankedPage` | `ranked pages are stable and non-overlapping`、`ranked page exposes total hits and continuation` | `6f86eff`、`48f0d94` |
| 统计与质量检查 | `DictionaryStats`、`stats`、`validate` | `dictionary stats summarize weighted corpus`、`public constructors maintain dictionary invariants` | `48f0d94` |

## 当前验证

- `moon fmt --check`：通过。
- `moon test`：19 个测试全部通过。
- `moon run cmd/main`：输出排序、分页、动态权重、统计和校验结果。

补报前必须确认 GitHub 和 GitLink 主分支都包含上述提交及后续文档提交。
