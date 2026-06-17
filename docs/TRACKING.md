# MoonTrieKit 公开开发追踪

本文件用于记录比赛阶段的公开开发线索，便于后续在 GitHub / GitLink 上对应提交、工单和合并请求。

## 已完成

- 初始化 MoonBit 包结构和项目元信息。
- 建立 Trie / LookupResult 基础模型。
- 实现插入去重、批量构建和词典导出。
- 实现前缀匹配、前缀计数、自动补全和短词优先补全。
- 实现最长公共前缀分析、检索摘要和 JSON 导出。
- 实现 WeightedTerm 带权词条和权重查询。
- 实现 complete_ranked 权重排序补全。
- 实现 longest_prefix_of 最长前缀匹配。
- 实现 QueryTrace 查询解释和 JSON 输出。
- 补充与 Yoorkin/trie@0.2.10 的关系说明。
- 建立 CLI、CI、Issue 模板、PR 模板和变更记录。

## 与已有项目的差异证据

- `Yoorkin/trie@0.2.10` 公开说明为 simple implementation，README 示例主要覆盖 `Trie::of`、`add`、`lookup`。
- MoonTrieKit 当前聚焦“开发工具可用的词典索引”：带权词条、排序补全、最长前缀匹配、查询解释、JSON 调试输出。
- MoonTrieKit 的目标使用场景是编辑器提示、命令面板、配置键查询、路径式 token 匹配和轻量搜索框，而不是只提供基础容器。

## 建议创建的工单

- `feature: 使用节点表优化 Trie 存储`
- `feature: 增加删除词条能力`
- `feature: 增加分页 top-k 补全`
- `docs: 增加大小写归一化策略`
- `test: 增加大词典性能测试`

## 建议维护节奏

- 每次新增公开 API 后同步补测试。
- 每个阶段至少更新一次 `CHANGELOG.md`。
- 比赛报名或阶段检查前，手动同步 GitHub 与 GitLink。
