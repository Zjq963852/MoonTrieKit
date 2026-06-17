# 相关项目差异说明

本文件用于回应报名初审中关于 MoonTrieKit 与社区已有 `Yoorkin/trie@0.2.10` 项目关系的疑问。

## 社区已有项目

`Yoorkin/trie@0.2.10` 的 Mooncakes 页面显示其名称为 `trie`，作者为 `Yoorkin`，版本为 `0.2.10`，许可证为 Apache-2.0，仓库指向 `github.com/Yoorkin/trie`。该仓库当前重定向到 `moonbit-community/trie`，公开描述为 “A simple implementation of a Trie data structure in MoonBit”。README 示例主要展示 `Trie::of`、`add`、`lookup` 等基础插入和查找能力。

## MoonTrieKit 的差异

MoonTrieKit 不定位为单纯的 Trie 容器复刻，而定位为面向 MoonBit 开发工具生态的带权词典索引与查询解释基础库。

- `WeightedTerm`：支持词条权重，可表达使用频次、热度、最近使用或业务推荐因子。
- `complete_ranked`：返回 `CompletionItem`，包含 word、weight、score，便于编辑器提示和命令面板排序。
- `longest_prefix_of`：支持命令路由、配置键、路径式 token 的最长前缀匹配。
- `QueryTrace`：把 exact、prefix_hits、longest_prefix、suggestions 输出为 JSON，适合调试、教学和可视化。
- `complete_short_first` 与 `complete_ranked` 并存，分别覆盖短词优先和权重优先两类补全策略。

## 后续路线

后续计划把当前稳定 API 下面的存储从数组后端演进为节点表后端，并补充删除、分页 top-k、大小写归一化策略、benchmark 和更贴近编辑器/命令面板的示例。这样 MoonTrieKit 的价值会落在“可解释、可排序、可集成”的工具链检索层，而不是与已有基础 Trie 项目重复。
