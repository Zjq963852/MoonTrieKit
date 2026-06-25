# MoonTrieKit 公开开发追踪

## 已完成

- [x] MoonBit 包结构和项目元信息
- [x] 基础词典、插入去重和批量构建
- [x] 前缀判断、计数和基础自动补全
- [x] 短词优先补全和最长公共前缀
- [x] 带权词条和排序补全
- [x] 最长前缀匹配和 QueryTrace
- [x] 词条删除、权重设置和增量更新
- [x] RankingPolicy 可配置评分
- [x] 全局 Top-K 和稳定分页
- [x] DictionaryStats 和一致性校验
- [x] CLI、CI、Issue 模板和 PR 模板
- [x] 社区差异说明和功能证据清单
- [x] 19 个确定性测试

## 下一阶段

- [ ] 节点表或 Radix 压缩存储
- [ ] 大小写和 Unicode 归一化策略
- [ ] Top-K 缓存与增量失效
- [ ] 1K、10K、100K 词条 benchmark
- [ ] 编辑器命令面板完整示例

每项新能力应通过独立提交和公开工单追踪，并同步更新测试、CHANGELOG 和证据清单。
