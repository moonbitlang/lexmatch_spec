// Quantifier tests - comprehensive coverage of *, +, ?, {n}, {n,}, {n,m} with various patterns

///|
test "a* - zero or more a's" {
  lexmatch "" {
    "a*" => ()
    _ => fail("Should match empty")
  }
  lexmatch "a" {
    "a*" => ()
    _ => fail("Should match one a")
  }
  lexmatch "aaaa" {
    "a*" => ()
    _ => fail("Should match multiple a's")
  }
}

///|
test "a+ - one or more a's" {
  lexmatch "" {
    "a+" => fail("Should not match empty")
    _ => ()
  }
  lexmatch "a" {
    "a+" => ()
    _ => fail("Should match one a")
  }
  lexmatch "aaaaa" {
    "a+" => ()
    _ => fail("Should match multiple a's")
  }
}

///|
test "a? - zero or one a" {
  lexmatch "" {
    "a?" => ()
    _ => fail("Should match empty")
  }
  lexmatch "a" {
    "a?" => ()
    _ => fail("Should match one a")
  }
}

///|
test "a{3} - exactly 3 a's" {
  lexmatch "aaa" {
    "a{3}" => ()
    _ => fail("Should match exactly 3")
  }
  lexmatch "aa" {
    "a{3}" => fail("Should not match 2")
    _ => ()
  }
  lexmatch "aaaa" {
    "a{3}" => fail("Should not match 4")
    _ => ()
  }
}

///|
test "a{2,} - at least 2 a's" {
  lexmatch "aa" {
    "a{2,}" => ()
    _ => fail("Should match exactly 2")
  }
  lexmatch "aaa" {
    "a{2,}" => ()
    _ => fail("Should match 3")
  }
  lexmatch "aaaaaaa" {
    "a{2,}" => ()
    _ => fail("Should match many")
  }
  lexmatch "a" {
    "a{2,}" => fail("Should not match 1")
    _ => ()
  }
}

///|
test "a{2,5} - between 2 and 5 a's" {
  lexmatch "aa" {
    "a{2,5}" => ()
    _ => fail("Should match 2")
  }
  lexmatch "aaa" {
    "a{2,5}" => ()
    _ => fail("Should match 3")
  }
  lexmatch "aaaa" {
    "a{2,5}" => ()
    _ => fail("Should match 4")
  }
  lexmatch "aaaaa" {
    "a{2,5}" => ()
    _ => fail("Should match 5")
  }
  lexmatch "a" {
    "a{2,5}" => fail("Should not match 1")
    _ => ()
  }
  lexmatch "aaaaaa" {
    "a{2,5}" => fail("Should not match 6")
    _ => ()
  }
}

///|
test "\\d{4} - exactly 4 digits" {
  lexmatch "1234" {
    "\d{4}" => ()
    _ => fail("Should match 4 digits")
  }
  lexmatch "2024" {
    "\d{4}" => ()
    _ => fail("Should match year")
  }
  lexmatch "123" {
    "\d{4}" => fail("Should not match 3 digits")
    _ => ()
  }
}

///|
test "\\d{2,4} - 2 to 4 digits" {
  lexmatch "12" {
    "\d{2,4}" => ()
    _ => fail("Should match 2 digits")
  }
  lexmatch "123" {
    "\d{2,4}" => ()
    _ => fail("Should match 3 digits")
  }
  lexmatch "1234" {
    "\d{2,4}" => ()
    _ => fail("Should match 4 digits")
  }
  lexmatch "1" {
    "\d{2,4}" => fail("Should not match 1 digit")
    _ => ()
  }
}

///|
test "\\w{1,10} - 1 to 10 word characters" {
  lexmatch "a" {
    "\w{1,10}" => ()
    _ => fail("Should match 1 char")
  }
  lexmatch "hello" {
    "\w{1,10}" => ()
    _ => fail("Should match 5 chars")
  }
  lexmatch "hello_world" {
    "\w{1,10}" => fail("Should not match 11 chars")
    _ => ()
  }
}

///|
test "[abc]* - zero or more a, b, or c" {
  lexmatch "" {
    "[abc]*" => ()
    _ => fail("Should match empty")
  }
  lexmatch "abc" {
    "[abc]*" => ()
    _ => fail("Should match abc")
  }
  lexmatch "cbacab" {
    "[abc]*" => ()
    _ => fail("Should match multiple")
  }
}

///|
test "[abc]+ - one or more a, b, or c" {
  lexmatch "" {
    "[abc]+" => fail("Should not match empty")
    _ => ()
  }
  lexmatch "aaa" {
    "[abc]+" => ()
    _ => fail("Should match repeated")
  }
  lexmatch "abcabc" {
    "[abc]+" => ()
    _ => fail("Should match sequence")
  }
}

///|
test "[0-9]* - zero or more digits" {
  lexmatch "" {
    "[0-9]*" => ()
    _ => fail("Should match empty")
  }
  lexmatch "123456" {
    "[0-9]*" => ()
    _ => fail("Should match number")
  }
}

///|
test "[a-z]+ - one or more lowercase letters" {
  lexmatch "hello" {
    "[a-z]+" => ()
    _ => fail("Should match word")
  }
  lexmatch "test" {
    "[a-z]+" => ()
    _ => fail("Should match lowercase")
  }
  lexmatch "" {
    "[a-z]+" => fail("Should not match empty")
    _ => ()
  }
}

///|
test "[A-Z]* - zero or more uppercase letters" {
  lexmatch "" {
    "[A-Z]*" => ()
    _ => fail("Should match empty")
  }
  lexmatch "HELLO" {
    "[A-Z]*" => ()
    _ => fail("Should match uppercase word")
  }
}

///|
test "\\s* - zero or more whitespace" {
  lexmatch "" {
    "\s*" => ()
    _ => fail("Should match empty")
  }
  lexmatch "   " {
    "\s*" => ()
    _ => fail("Should match spaces")
  }
  lexmatch " \t\n " {
    "\s*" => ()
    _ => fail("Should match mixed whitespace")
  }
}

///|
test "\\s+ - one or more whitespace" {
  lexmatch " " {
    "\s+" => ()
    _ => fail("Should match single space")
  }
  lexmatch "    " {
    "\s+" => ()
    _ => fail("Should match multiple spaces")
  }
  lexmatch "" {
    "\s+" => fail("Should not match empty")
    _ => ()
  }
}

///|
test "\\d+ - one or more digits" {
  lexmatch "0" {
    "\d+" => ()
    _ => fail("Should match single digit")
  }
  lexmatch "123456789" {
    "\d+" => ()
    _ => fail("Should match long number")
  }
}

///|
test "\\w* - zero or more word characters" {
  lexmatch "" {
    "\w*" => ()
    _ => fail("Should match empty")
  }
  lexmatch "test123" {
    "\w*" => ()
    _ => fail("Should match identifier")
  }
}

///|
test ".* - zero or more any character" {
  lexmatch "" {
    ".*" => ()
    _ => fail("Should match empty")
  }
  lexmatch "anything goes!" {
    ".*" => ()
    _ => fail("Should match any text")
  }
  lexmatch "with\nnewlines" {
    ".*" => ()
    _ => fail("Should match text with newlines")
  }
}

///|
test ".+ - one or more any character" {
  lexmatch "x" {
    ".+" => ()
    _ => fail("Should match single char")
  }
  lexmatch "multiple characters" {
    ".+" => ()
    _ => fail("Should match text")
  }
  lexmatch "" {
    ".+" => fail("Should not match empty")
    _ => ()
  }
}

///|
test ".? - zero or one any character" {
  lexmatch "" {
    ".?" => ()
    _ => fail("Should match empty")
  }
  lexmatch "x" {
    ".?" => ()
    _ => fail("Should match single char")
  }
}

///|
test "[^\\s]+ - one or more non-whitespace" {
  lexmatch "word" {
    "[^\s]+" => ()
    _ => fail("Should match word")
  }
  lexmatch "test123!@#" {
    "[^\s]+" => ()
    _ => fail("Should match non-space sequence")
  }
}

///|
test "[^\\d]+ - one or more non-digits" {
  lexmatch "abc" {
    "[^\d]+" => ()
    _ => fail("Should match letters")
  }
  lexmatch "   " {
    "[^\d]+" => ()
    _ => fail("Should match spaces")
  }
}

///|
test "a*b+ - zero or more a's, one or more b's" {
  lexmatch "b" {
    "a*b+" => ()
    _ => fail("Should match single b")
  }
  lexmatch "ab" {
    "a*b+" => ()
    _ => fail("Should match ab")
  }
  lexmatch "aabbb" {
    "a*b+" => ()
    _ => fail("Should match multiple")
  }
  lexmatch "bbb" {
    "a*b+" => ()
    _ => fail("Should match just b's")
  }
}

///|
test "a+b* - one or more a's, zero or more b's" {
  lexmatch "a" {
    "a+b*" => ()
    _ => fail("Should match single a")
  }
  lexmatch "ab" {
    "a+b*" => ()
    _ => fail("Should match ab")
  }
  lexmatch "aaabbb" {
    "a+b*" => ()
    _ => fail("Should match multiple")
  }
  lexmatch "aaa" {
    "a+b*" => ()
    _ => fail("Should match just a's")
  }
}

///|
test "a?b? - optional a and optional b" {
  lexmatch "" {
    "a?b?" => ()
    _ => fail("Should match empty")
  }
  lexmatch "a" {
    "a?b?" => ()
    _ => fail("Should match a")
  }
  lexmatch "b" {
    "a?b?" => ()
    _ => fail("Should match b")
  }
  lexmatch "ab" {
    "a?b?" => ()
    _ => fail("Should match ab")
  }
}

///|
test "\\d{2}:\\d{2} - time pattern HH:MM" {
  lexmatch "12:34" {
    "\d{2}:\d{2}" => ()
    _ => fail("Should match time")
  }
  lexmatch "00:00" {
    "\d{2}:\d{2}" => ()
    _ => fail("Should match midnight")
  }
  lexmatch "23:59" {
    "\d{2}:\d{2}" => ()
    _ => fail("Should match time")
  }
}

///|
test "\\d{4}-\\d{2}-\\d{2} - date pattern YYYY-MM-DD" {
  lexmatch "2024-01-15" {
    "\d{4}-\d{2}-\d{2}" => ()
    _ => fail("Should match date")
  }
  lexmatch "2000-12-31" {
    "\d{4}-\d{2}-\d{2}" => ()
    _ => fail("Should match date")
  }
}

///|
test "[a-z]{3,6} - 3 to 6 lowercase letters" {
  lexmatch "abc" {
    "[a-z]{3,6}" => ()
    _ => fail("Should match 3 letters")
  }
  lexmatch "hello" {
    "[a-z]{3,6}" => ()
    _ => fail("Should match 5 letters")
  }
  lexmatch "ab" {
    "[a-z]{3,6}" => fail("Should not match 2 letters")
    _ => ()
  }
  lexmatch "toolong" {
    "[a-z]{3,6}" => fail("Should not match 7 letters")
    _ => ()
  }
}

///|
test "\\w{5,} - at least 5 word characters" {
  lexmatch "hello" {
    "\w{5,}" => ()
    _ => fail("Should match 5 chars")
  }
  lexmatch "hello_world" {
    "\w{5,}" => ()
    _ => fail("Should match more than 5")
  }
  lexmatch "test" {
    "\w{5,}" => fail("Should not match 4 chars")
    _ => ()
  }
}

///|
test "[0-9]{1,} - equivalent to [0-9]+" {
  lexmatch "1" {
    "[0-9]{1,}" => ()
    _ => fail("Should match single digit")
  }
  lexmatch "123456" {
    "[0-9]{1,}" => ()
    _ => fail("Should match multiple digits")
  }
  lexmatch "" {
    "[0-9]{1,}" => fail("Should not match empty")
    _ => ()
  }
}

///|
test "a{0,} - equivalent to a*" {
  lexmatch "" {
    "a{0,}" => ()
    _ => fail("Should match empty")
  }
  lexmatch "aaaa" {
    "a{0,}" => ()
    _ => fail("Should match multiple")
  }
}

///|
test "a{1} - exactly one a" {
  lexmatch "a" {
    "a{1}" => ()
    _ => fail("Should match one a")
  }
  lexmatch "" {
    "a{1}" => fail("Should not match empty")
    _ => ()
  }
  lexmatch "aa" {
    "a{1}" => fail("Should not match two a's")
    _ => ()
  }
}

///|
test "\\d{0,3} - zero to 3 digits" {
  lexmatch "" {
    "\d{0,3}" => ()
    _ => fail("Should match empty")
  }
  lexmatch "1" {
    "\d{0,3}" => ()
    _ => fail("Should match 1 digit")
  }
  lexmatch "12" {
    "\d{0,3}" => ()
    _ => fail("Should match 2 digits")
  }
  lexmatch "123" {
    "\d{0,3}" => ()
    _ => fail("Should match 3 digits")
  }
  lexmatch "1234" {
    "\d{0,3}" => fail("Should not match 4 digits")
    _ => ()
  }
}

///|
test "[abc]{2,4} - 2 to 4 characters from set" {
  lexmatch "ab" {
    "[abc]{2,4}" => ()
    _ => fail("Should match 2 chars")
  }
  lexmatch "abc" {
    "[abc]{2,4}" => ()
    _ => fail("Should match 3 chars")
  }
  lexmatch "abca" {
    "[abc]{2,4}" => ()
    _ => fail("Should match 4 chars")
  }
  lexmatch "a" {
    "[abc]{2,4}" => fail("Should not match 1 char")
    _ => ()
  }
}

///|
test "\\s{2,} - at least 2 whitespace characters" {
  lexmatch "  " {
    "\s{2,}" => ()
    _ => fail("Should match 2 spaces")
  }
  lexmatch "     " {
    "\s{2,}" => ()
    _ => fail("Should match many spaces")
  }
  lexmatch " " {
    "\s{2,}" => fail("Should not match 1 space")
    _ => ()
  }
}

///|
test ".*\\d+ - any chars followed by digits" {
  lexmatch "test123" {
    ".*\d+" => ()
    _ => fail("Should match text with number")
  }
  lexmatch "123" {
    ".*\d+" => ()
    _ => fail("Should match just number")
  }
  lexmatch "abc def 456" {
    ".*\d+" => ()
    _ => fail("Should match complex pattern")
  }
}

///|
test "\\d+.* - digits followed by any chars" {
  lexmatch "123abc" {
    "\d+.*" => ()
    _ => fail("Should match number with text")
  }
  lexmatch "123" {
    "\d+.*" => ()
    _ => fail("Should match just number")
  }
  lexmatch "456 test string" {
    "\d+.*" => ()
    _ => fail("Should match complex pattern")
  }
}

///|
test "\\w+\\d* - word chars with optional digits" {
  lexmatch "test" {
    "\w+\d*" => ()
    _ => fail("Should match word without digits")
  }
  lexmatch "test123" {
    "\w+\d*" => ()
    _ => fail("Should match word with digits")
  }
  lexmatch "var1" {
    "\w+\d*" => ()
    _ => fail("Should match identifier")
  }
}

///|
test "\\d*\\w+ - optional digits with word chars" {
  lexmatch "test" {
    "\d*\w+" => ()
    _ => fail("Should match word")
  }
  lexmatch "123test" {
    "\d*\w+" => ()
    _ => fail("Should match number prefix")
  }
  lexmatch "var" {
    "\d*\w+" => ()
    _ => fail("Should match identifier")
  }
}

///|
test "[a-z]+[0-9]* - letters with optional numbers" {
  lexmatch "abc" {
    "[a-z]+[0-9]*" => ()
    _ => fail("Should match letters only")
  }
  lexmatch "abc123" {
    "[a-z]+[0-9]*" => ()
    _ => fail("Should match letters with numbers")
  }
}

///|
test "[0-9]*[a-z]+ - optional numbers with letters" {
  lexmatch "abc" {
    "[0-9]*[a-z]+" => ()
    _ => fail("Should match letters only")
  }
  lexmatch "123abc" {
    "[0-9]*[a-z]+" => ()
    _ => fail("Should match numbers with letters")
  }
}

///|
test "\\w{2,}@\\w{2,} - simple username@domain pattern" {
  lexmatch "ab@cd" {
    "\w{2,}@\w{2,}" => ()
    _ => fail("Should match minimal email")
  }
  lexmatch "user@domain" {
    "\w{2,}@\w{2,}" => ()
    _ => fail("Should match email pattern")
  }
  lexmatch "a@b" {
    "\w{2,}@\w{2,}" => fail("Should not match single char parts")
    _ => ()
  }
}

///|
test "[a-zA-Z]{2,} - at least 2 letters" {
  lexmatch "ab" {
    "[a-zA-Z]{2,}" => ()
    _ => fail("Should match 2 letters")
  }
  lexmatch "Hello" {
    "[a-zA-Z]{2,}" => ()
    _ => fail("Should match word")
  }
  lexmatch "a" {
    "[a-zA-Z]{2,}" => fail("Should not match 1 letter")
    _ => ()
  }
}

///|
test ".{5} - exactly 5 any characters" {
  lexmatch "hello" {
    ".{5}" => ()
    _ => fail("Should match 5 chars")
  }
  lexmatch "12345" {
    ".{5}" => ()
    _ => fail("Should match 5 digits")
  }
  lexmatch "test" {
    ".{5}" => fail("Should not match 4 chars")
    _ => ()
  }
}

///|
test ".{3,7} - 3 to 7 any characters" {
  lexmatch "abc" {
    ".{3,7}" => ()
    _ => fail("Should match 3 chars")
  }
  lexmatch "hello" {
    ".{3,7}" => ()
    _ => fail("Should match 5 chars")
  }
  lexmatch "testing" {
    ".{3,7}" => ()
    _ => fail("Should match 7 chars")
  }
  lexmatch "ab" {
    ".{3,7}" => fail("Should not match 2 chars")
    _ => ()
  }
}
