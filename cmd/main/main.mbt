///|
fn main {
  let dict = @trie.Trie::from_weighted([
    @trie.WeightedTerm::new("moon", 5),
    @trie.WeightedTerm::new("moonbit", 9),
    @trie.WeightedTerm::new("mooncake", 3),
    @trie.WeightedTerm::new("module", 7),
    @trie.WeightedTerm::new("moonbit/pkg", 4),
  ])
  let ranked = dict.complete_ranked("moo", limit=3)
  let trace = dict.explain("moon", limit=3)
  println("size=\{dict.len()}")
  println("prefix_count=\{dict.count_prefix("moo")}")
  println("top_ranked=\{ranked[0].word}")
  println("longest_prefix=\{dict.longest_prefix_of("moonbit/pkg/add")}")
  println(trace.to_json())
  println(dict.to_weighted_json())
}
