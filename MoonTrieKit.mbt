///|
pub(all) struct Trie {
  words : Array[String]
  weights : Array[Int]
} derive(Debug)

///|
pub(all) struct LookupResult {
  query : String
  matched : Bool
  count : Int
} derive(Debug, Eq)

///|
pub(all) struct WeightedTerm {
  word : String
  weight : Int
} derive(Debug, Eq)

///|
pub(all) struct CompletionItem {
  word : String
  weight : Int
  score : Int
} derive(Debug, Eq)

///|
pub(all) struct RankingPolicy {
  weight_factor : Int
  prefix_bonus : Int
  length_penalty : Int
} derive(Debug, Eq)

///|
pub(all) struct QueryTrace {
  query : String
  exact : Bool
  prefix_hits : Int
  longest_prefix : String
  suggestions : Array[CompletionItem]
} derive(Debug)

///|
pub(all) struct RankedPage {
  prefix : String
  offset : Int
  limit : Int
  total_hits : Int
  has_more : Bool
  items : Array[CompletionItem]
} derive(Debug)

///|
pub(all) struct DictionaryStats {
  terms : Int
  total_weight : Int
  max_word_length : Int
  zero_weight_terms : Int
} derive(Debug, Eq)

///|
pub fn Trie::new() -> Trie {
  { words: [], weights: [] }
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
  self.insert_weighted(word, 1)
}

///|
fn safe_weight(weight : Int) -> Int {
  if weight < 0 {
    0
  } else {
    weight
  }
}

///|
pub fn Trie::insert_weighted(self : Trie, word : String, weight : Int) -> Bool {
  if word.length() == 0 || self.contains(word) {
    false
  } else {
    self.words.push(word)
    self.weights.push(safe_weight(weight))
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
pub fn WeightedTerm::new(word : String, weight : Int) -> WeightedTerm {
  { word, weight: safe_weight(weight) }
}

///|
pub fn Trie::from_weighted(entries : Array[WeightedTerm]) -> Trie {
  let trie = Trie::new()
  for entry in entries {
    ignore(trie.insert_weighted(entry.word, entry.weight))
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
pub fn Trie::weight_of(self : Trie, word : String) -> Int {
  for i = 0; i < self.words.length(); i = i + 1 {
    if same_text(self.words[i], word) {
      return self.weights[i]
    }
  }
  0
}

///|
pub fn Trie::remove(self : Trie, word : String) -> Bool {
  for i = 0; i < self.words.length(); i = i + 1 {
    if same_text(self.words[i], word) {
      ignore(self.words.remove(i))
      ignore(self.weights.remove(i))
      return true
    }
  }
  false
}

///|
pub fn Trie::set_weight(self : Trie, word : String, weight : Int) -> Bool {
  for i = 0; i < self.words.length(); i = i + 1 {
    if same_text(self.words[i], word) {
      self.weights[i] = safe_weight(weight)
      return true
    }
  }
  false
}

///|
pub fn Trie::increment_weight(self : Trie, word : String, delta : Int) -> Bool {
  for i = 0; i < self.words.length(); i = i + 1 {
    if same_text(self.words[i], word) {
      self.weights[i] = safe_weight(self.weights[i] + delta)
      return true
    }
  }
  false
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
pub fn Trie::to_weighted_json(self : Trie) -> String {
  let buf = StringBuilder()
  buf.write_string("{\"entries\":[")
  for i = 0; i < self.words.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_string(
      "{\"word\":\"" + self.words[i] + "\",\"weight\":\{self.weights[i]}}",
    )
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
pub fn CompletionItem::new(
  word : String,
  weight : Int,
  prefix_length : Int,
) -> CompletionItem {
  CompletionItem::with_policy(
    word,
    weight,
    prefix_length,
    RankingPolicy::default(),
  )
}

///|
pub fn RankingPolicy::new(
  weight_factor? : Int = 1000,
  prefix_bonus? : Int = 10,
  length_penalty? : Int = 1,
) -> RankingPolicy {
  {
    weight_factor: if weight_factor < 0 {
      0
    } else {
      weight_factor
    },
    prefix_bonus: if prefix_bonus < 0 {
      0
    } else {
      prefix_bonus
    },
    length_penalty: if length_penalty < 0 {
      0
    } else {
      length_penalty
    },
  }
}

///|
pub fn RankingPolicy::default() -> RankingPolicy {
  RankingPolicy::new()
}

///|
pub fn CompletionItem::with_policy(
  word : String,
  weight : Int,
  prefix_length : Int,
  policy : RankingPolicy,
) -> CompletionItem {
  let safe = safe_weight(weight)
  {
    word,
    weight: safe,
    score: safe * policy.weight_factor +
    prefix_length * policy.prefix_bonus -
    word.length() * policy.length_penalty,
  }
}

///|
fn contains_completion(items : Array[CompletionItem], word : String) -> Bool {
  for item in items {
    if same_text(item.word, word) {
      return true
    }
  }
  false
}

///|
fn better_completion(
  candidate : CompletionItem,
  current : CompletionItem,
) -> Bool {
  candidate.score > current.score ||
  (
    candidate.score == current.score &&
    candidate.word.length() < current.word.length()
  )
}

///|
pub fn Trie::complete_ranked(
  self : Trie,
  prefix : String,
  limit? : Int = 10,
) -> Array[CompletionItem] {
  self.complete_ranked_with(prefix, RankingPolicy::default(), limit~)
}

///|
pub fn Trie::complete_ranked_with(
  self : Trie,
  prefix : String,
  policy : RankingPolicy,
  limit? : Int = 10,
) -> Array[CompletionItem] {
  let result : Array[CompletionItem] = []
  let safe_limit = if limit < 0 { 0 } else { limit }
  while result.length() < safe_limit {
    let mut found = false
    let mut best = CompletionItem::new("", 0, 0)
    for i = 0; i < self.words.length(); i = i + 1 {
      if starts_with(self.words[i], prefix) &&
        !contains_completion(result, self.words[i]) {
        let item = CompletionItem::with_policy(
          self.words[i],
          self.weights[i],
          prefix.length(),
          policy,
        )
        if !found || better_completion(item, best) {
          best = item
          found = true
        }
      }
    }
    if !found {
      return result
    }
    result.push(best)
  }
  result
}

///|
pub fn Trie::top_ranked(
  self : Trie,
  limit? : Int = 10,
) -> Array[CompletionItem] {
  self.complete_ranked("", limit~)
}

///|
pub fn Trie::complete_ranked_page(
  self : Trie,
  prefix : String,
  offset? : Int = 0,
  limit? : Int = 10,
) -> Array[CompletionItem] {
  let safe_offset = if offset < 0 { 0 } else { offset }
  let safe_limit = if limit < 0 { 0 } else { limit }
  let ranked = self.complete_ranked(prefix, limit=safe_offset + safe_limit)
  let page : Array[CompletionItem] = []
  for i = safe_offset; i < ranked.length(); i = i + 1 {
    if page.length() >= safe_limit {
      return page
    }
    page.push(ranked[i])
  }
  page
}

///|
pub fn Trie::ranked_page(
  self : Trie,
  prefix : String,
  offset? : Int = 0,
  limit? : Int = 10,
) -> RankedPage {
  let safe_offset = if offset < 0 { 0 } else { offset }
  let safe_limit = if limit < 0 { 0 } else { limit }
  let total_hits = self.count_prefix(prefix)
  {
    prefix,
    offset: safe_offset,
    limit: safe_limit,
    total_hits,
    has_more: safe_offset + safe_limit < total_hits,
    items: self.complete_ranked_page(
      prefix,
      offset=safe_offset,
      limit=safe_limit,
    ),
  }
}

///|
pub fn RankedPage::to_json(self : RankedPage) -> String {
  let buf = StringBuilder()
  buf.write_string(
    "{\"prefix\":\"\{self.prefix}\",\"offset\":\{self.offset},\"limit\":\{self.limit},\"total_hits\":\{self.total_hits},\"has_more\":\{self.has_more},\"items\":[",
  )
  for i = 0; i < self.items.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    let item = self.items[i]
    buf.write_string(
      "{\"word\":\"\{item.word}\",\"weight\":\{item.weight},\"score\":\{item.score}}",
    )
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
pub fn Trie::stats(self : Trie) -> DictionaryStats {
  let mut total_weight = 0
  let mut zero_weight_terms = 0
  for weight in self.weights {
    total_weight = total_weight + weight
    if weight == 0 {
      zero_weight_terms = zero_weight_terms + 1
    }
  }
  {
    terms: self.words.length(),
    total_weight,
    max_word_length: max_word_length(self.words),
    zero_weight_terms,
  }
}

///|
pub fn DictionaryStats::to_json(self : DictionaryStats) -> String {
  "{\"terms\":\{self.terms},\"total_weight\":\{self.total_weight},\"max_word_length\":\{self.max_word_length},\"zero_weight_terms\":\{self.zero_weight_terms}}"
}

///|
pub fn Trie::validate(self : Trie) -> Array[String] {
  let issues : Array[String] = []
  if self.words.length() != self.weights.length() {
    issues.push("words and weights length mismatch")
  }
  for i = 0; i < self.words.length(); i = i + 1 {
    if self.words[i].length() == 0 {
      issues.push("empty word at index \{i}")
    }
    if i < self.weights.length() && self.weights[i] < 0 {
      issues.push("negative weight at index \{i}")
    }
    for j = i + 1; j < self.words.length(); j = j + 1 {
      if same_text(self.words[i], self.words[j]) {
        issues.push("duplicate word: \{self.words[i]}")
      }
    }
  }
  issues
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
pub fn Trie::longest_prefix_of(self : Trie, text : String) -> String {
  let mut best = ""
  for word in self.words {
    if starts_with(text, word) && word.length() > best.length() {
      best = word
    }
  }
  best
}

///|
pub fn QueryTrace::new(
  query : String,
  exact : Bool,
  prefix_hits : Int,
  longest_prefix : String,
  suggestions : Array[CompletionItem],
) -> QueryTrace {
  { query, exact, prefix_hits, longest_prefix, suggestions }
}

///|
pub fn QueryTrace::to_json(self : QueryTrace) -> String {
  let buf = StringBuilder()
  buf.write_string(
    "{\"query\":\"\{self.query}\",\"exact\":\{self.exact},\"prefix_hits\":\{self.prefix_hits},\"longest_prefix\":\"\{self.longest_prefix}\",\"suggestions\":[",
  )
  for i = 0; i < self.suggestions.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    let item = self.suggestions[i]
    buf.write_string(
      "{\"word\":\"\{item.word}\",\"weight\":\{item.weight},\"score\":\{item.score}}",
    )
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
pub fn Trie::explain(
  self : Trie,
  query : String,
  limit? : Int = 5,
) -> QueryTrace {
  QueryTrace::new(
    query,
    self.contains(query),
    self.count_prefix(query),
    self.longest_prefix_of(query),
    self.complete_ranked(query, limit~),
  )
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
