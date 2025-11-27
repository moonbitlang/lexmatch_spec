// Anchor tests - testing ^ (start of input) and $ (end of string) anchors

///|
test "^ anchor - start of input basic" {
  lexmatch "abc" {
    "^abc" => ()
    _ => fail("Should match at start of input")
  }
  lexmatch "abc" {
    "^bc" => fail("Should not match - pattern not at start")
    _ => ()
  }
}
