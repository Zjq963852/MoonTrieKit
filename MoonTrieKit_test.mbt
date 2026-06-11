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
