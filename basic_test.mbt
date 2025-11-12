///|
test "[abc]" {
  lexmatch "b" {
    "[abc]" => ()
    _ => fail("Should match [abc]")
  }
  lexmatch "d" {
    "[abc]" => fail("Should not match [abc]")
    _ => ()
  }
}

///|
test "[^abc]" {
  lexmatch "d" {
    "[^abc]" => ()
    _ => fail("Should match [^abc]")
  }
  lexmatch "b" {
    "[^abc]" => fail("Should not match [^abc]")
    _ => ()
  }
}

///|
test "[a-zA-Z]" {
  lexmatch "G" {
    "[a-zA-Z]" => ()
    _ => fail("Should match [a-zA-Z]")
  }
  lexmatch "5" {
    "[a-zA-Z]" => fail("Should not match [a-zA-Z]")
    _ => ()
  }
}
