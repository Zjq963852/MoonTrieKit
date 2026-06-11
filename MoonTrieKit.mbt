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
pub fn starts_with(value : String, prefix : String) -> Bool {
  if prefix.length() > value.length() {
    return false
  }
  for i = 0; i < prefix.length(); i = i + 1 {
    if value.get_char(i) != prefix.get_char(i) {
      return false
    }
  }
  true
}

///|
fn min_int(a : Int, b : Int) -> Int {
  if a < b {
    a
  } else {
    b
  }
}

///|
pub fn common_prefix_length(a : String, b : String) -> Int {
  let limit = min_int(a.length(), b.length())
  let mut count = 0
  while count < limit && a.get_char(count) == b.get_char(count) {
    count = count + 1
  }
  count
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
pub fn Trie::to_json(self : Trie) -> String {
  let buf = StringBuilder()
  buf.write_string("{\"words\":[")
  for i = 0; i < self.words.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_string("\"" + self.words[i] + "\"")
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
pub fn Trie::has_prefix(self : Trie, prefix : String) -> Bool {
  for word in self.words {
    if starts_with(word, prefix) {
      return true
    }
  }
  false
}

///|
pub fn Trie::count_prefix(self : Trie, prefix : String) -> Int {
  let mut count = 0
  for word in self.words {
    if starts_with(word, prefix) {
      count = count + 1
    }
  }
  count
}

///|
pub fn Trie::complete(
  self : Trie,
  prefix : String,
  limit? : Int = 10,
) -> Array[String] {
  let result : Array[String] = []
  let safe_limit = if limit < 0 { 0 } else { limit }
  for word in self.words {
    if result.length() >= safe_limit {
      return result
    }
    if starts_with(word, prefix) {
      result.push(word)
    }
  }
  result
}

///|
fn max_word_length(words : Array[String]) -> Int {
  let mut length = 0
  for word in words {
    if word.length() > length {
      length = word.length()
    }
  }
  length
}

///|
pub fn Trie::complete_short_first(
  self : Trie,
  prefix : String,
  limit? : Int = 10,
) -> Array[String] {
  let result : Array[String] = []
  let safe_limit = if limit < 0 { 0 } else { limit }
  let max_length = max_word_length(self.words)
  for size = prefix.length(); size <= max_length; size = size + 1 {
    for word in self.words {
      if result.length() >= safe_limit {
        return result
      }
      if word.length() == size && starts_with(word, prefix) {
        result.push(word)
      }
    }
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

///|
pub fn LookupResult::to_json(self : LookupResult) -> String {
  "{\"query\":\"\{self.query}\",\"matched\":\{self.matched},\"count\":\{self.count}}"
}

///|
pub fn Trie::lookup(self : Trie, query : String) -> LookupResult {
  LookupResult::new(query, self.contains(query), self.count_prefix(query))
}

///|
pub fn Trie::longest_common_prefix_length(self : Trie) -> Int {
  if self.words.length() == 0 {
    return 0
  }
  let mut length = self.words[0].length()
  for word in self.words {
    length = min_int(length, common_prefix_length(self.words[0], word))
  }
  length
}
