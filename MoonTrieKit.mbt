///|
pub(all) struct Trie {
  words : Array[String]
} derive(Debug)

///|
pub(all) struct LookupResult {
  query : String
  matched : Bool
  count : Int
} derive(Debug, Eq)

///|
pub fn Trie::new() -> Trie {
  { words: [] }
}

///|
fn same_text(a : String, b : String) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if a.get_char(i) != b.get_char(i) {
      return false
    }
  }
  true
}

///|
pub fn Trie::len(self : Trie) -> Int {
  self.words.length()
}

///|
pub fn Trie::is_empty(self : Trie) -> Bool {
  self.words.length() == 0
}

///|
pub fn Trie::contains(self : Trie, word : String) -> Bool {
  for item in self.words {
    if same_text(item, word) {
      return true
    }
  }
  false
}

///|
pub fn Trie::insert(self : Trie, word : String) -> Bool {
  if word.length() == 0 || self.contains(word) {
    false
  } else {
    self.words.push(word)
    true
  }
}

///|
pub fn Trie::from_words(words : Array[String]) -> Trie {
  let trie = Trie::new()
  for word in words {
    ignore(trie.insert(word))
  }
  trie
}

///|
pub fn Trie::to_array(self : Trie) -> Array[String] {
  let result : Array[String] = []
  for word in self.words {
    result.push(word)
  }
  result
}

///|
pub fn LookupResult::new(
  query : String,
  matched : Bool,
  count : Int,
) -> LookupResult {
  { query, matched, count }
}
