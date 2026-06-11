///|
fn main {
  let dict = @trie.Trie::from_words([
    "moon", "moonbit", "mooncake", "module", "trie", "tree",
  ])
  let matches = dict.complete_short_first("moo", limit=3)
  let lookup = dict.lookup("moon")
  println("size=\{dict.len()}")
  println("prefix_count=\{dict.count_prefix("moo")}")
  println("first_match=\{matches[0]}")
  println(lookup.to_json())
  println(dict.to_json())
}
