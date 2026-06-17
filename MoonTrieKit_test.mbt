///|
test "trie starts empty and inserts unique words" {
  let trie = @MoonTrieKit.Trie::new()
  assert_true(trie.is_empty())
  assert_true(trie.insert("moon"))
  assert_false(trie.insert("moon"))
  assert_false(trie.insert(""))
  assert_eq(trie.len(), 1)
  assert_true(trie.contains("moon"))
  assert_false(trie.contains("moons"))
}

///|
test "lookup result stores query metadata" {
  let result = @MoonTrieKit.LookupResult::new("mo", true, 2)
  assert_eq(result.query, "mo")
  assert_true(result.matched)
  assert_eq(result.count, 2)
}

///|
test "trie builds from word arrays and exports copies" {
  let trie = @MoonTrieKit.Trie::from_words(["moon", "moon", "bit", ""])
  let words = trie.to_array()
  assert_eq(trie.len(), 2)
  assert_eq(words.length(), 2)
  assert_true(trie.contains("bit"))
  assert_eq(trie.weight_of("moon"), 1)
  assert_true(trie.to_json().contains("\"moon\""))
}

///|
test "prefix matching counts dictionary entries" {
  let trie = @MoonTrieKit.Trie::from_words(["moon", "mooncake", "bit"])
  assert_true(@MoonTrieKit.starts_with("mooncake", "moon"))
  assert_true(trie.has_prefix("moo"))
  assert_false(trie.has_prefix("cat"))
  assert_eq(trie.count_prefix("moon"), 2)
  assert_eq(trie.count_prefix("bit"), 1)
}

///|
test "autocomplete returns prefix matches with limits" {
  let trie = @MoonTrieKit.Trie::from_words([
    "moon", "mooncake", "moonbit", "trie",
  ])
  let first_two = trie.complete("moon", limit=2)
  assert_eq(first_two.length(), 2)
  assert_eq(first_two[0], "moon")
  assert_eq(first_two[1], "mooncake")
  assert_eq(trie.complete("missing").length(), 0)
}

///|
test "lookup reports exact match and prefix counts" {
  let trie = @MoonTrieKit.Trie::from_words(["moon", "moonbit", "mooncake"])
  let result = trie.lookup("moon")
  assert_true(result.matched)
  assert_eq(result.count, 3)
  assert_true(result.to_json().contains("\"query\":\"moon\""))
}

///|
test "common prefix length supports grouped suggestions" {
  assert_eq(@MoonTrieKit.common_prefix_length("moon", "moonbit"), 4)
  assert_eq(@MoonTrieKit.common_prefix_length("moon", "bit"), 0)
  let trie = @MoonTrieKit.Trie::from_words(["moon", "moonbit", "mooncake"])
  assert_eq(trie.longest_common_prefix_length(), 4)
}

///|
test "short first completion ranks compact suggestions first" {
  let trie = @MoonTrieKit.Trie::from_words(["mooncake", "moon", "moonbit", "mo"])
  let ranked = trie.complete_short_first("mo", limit=3)
  assert_eq(ranked.length(), 3)
  assert_eq(ranked[0], "mo")
  assert_eq(ranked[1], "moon")
  assert_eq(ranked[2], "moonbit")
}

///|
test "weighted dictionaries preserve payload and de-duplicate words" {
  let trie = @MoonTrieKit.Trie::from_weighted([
    @MoonTrieKit.WeightedTerm::new("moon", 5),
    @MoonTrieKit.WeightedTerm::new("moonbit", 9),
    @MoonTrieKit.WeightedTerm::new("moon", 1),
    @MoonTrieKit.WeightedTerm::new("module", -3),
  ])
  assert_eq(trie.len(), 3)
  assert_eq(trie.weight_of("moonbit"), 9)
  assert_eq(trie.weight_of("module"), 0)
  assert_true(trie.to_weighted_json().contains("\"weight\":9"))
}

///|
test "ranked completion prefers weight then compact terms" {
  let trie = @MoonTrieKit.Trie::from_weighted([
    @MoonTrieKit.WeightedTerm::new("mooncake", 3),
    @MoonTrieKit.WeightedTerm::new("moon", 3),
    @MoonTrieKit.WeightedTerm::new("moonbit", 7),
    @MoonTrieKit.WeightedTerm::new("module", 9),
  ])
  let ranked = trie.complete_ranked("moo", limit=3)
  assert_eq(ranked.length(), 3)
  assert_eq(ranked[0].word, "moonbit")
  assert_eq(ranked[1].word, "moon")
  assert_eq(ranked[2].word, "mooncake")
  assert_eq(trie.complete_ranked("missing", limit=2).length(), 0)
}

///|
test "query trace explains exact match longest prefix and suggestions" {
  let trie = @MoonTrieKit.Trie::from_weighted([
    @MoonTrieKit.WeightedTerm::new("moon", 5),
    @MoonTrieKit.WeightedTerm::new("moonbit", 8),
    @MoonTrieKit.WeightedTerm::new("moonbit/pkg", 4),
  ])
  assert_eq(trie.longest_prefix_of("moonbit/pkg/add"), "moonbit/pkg")
  let trace = trie.explain("moon", limit=2)
  assert_true(trace.exact)
  assert_eq(trace.prefix_hits, 3)
  assert_eq(trace.suggestions.length(), 2)
  assert_true(trace.to_json().contains("\"longest_prefix\":\"moon\""))
}
