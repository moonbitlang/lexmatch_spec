// Character class tests - comprehensive coverage of character classes and their combinations

///|
test "\\s+ multiple whitespace" {
  lexmatch "   " {
    "\s+" => ()
    _ => fail("Should match multiple spaces")
  }
  lexmatch " \t\n" {
    "\s+" => ()
    _ => fail("Should match mixed whitespace")
  }
}

///|
test "\\d+ multiple digits" {
  lexmatch "12345" {
    "\d+" => ()
    _ => fail("Should match multiple digits")
  }
  lexmatch "0" {
    "\d+" => ()
    _ => fail("Should match single digit")
  }
}

///|
test "\\w+ word sequence" {
  lexmatch "abc123_XYZ" {
    "\w+" => ()
    _ => fail("Should match word characters")
  }
}

///|
test "[\\d\\w] - digit or word character" {
  lexmatch "5" {
    "[\d\w]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "a" {
    "[\d\w]" => ()
    _ => fail("Should match letter")
  }
  lexmatch "_" {
    "[\d\w]" => ()
    _ => fail("Should match underscore")
  }
}

///|
test "[\\s\\d] - whitespace or digit" {
  lexmatch " " {
    "[\s\d]" => ()
    _ => fail("Should match space")
  }
  lexmatch "5" {
    "[\s\d]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "\t" {
    "[\s\d]" => ()
    _ => fail("Should match tab")
  }
  lexmatch "a" {
    "[\s\d]" => fail("Should not match letter")
    _ => ()
  }
}

///|
test "[\\w\\s]+ - word or whitespace sequence" {
  lexmatch "hello world" {
    "[\w\s]+" => ()
    _ => fail("Should match words with spaces")
  }
  lexmatch "test_123 \t value" {
    "[\w\s]+" => ()
    _ => fail("Should match complex sequence")
  }
}

///|
test "[^\\d] - not a digit" {
  lexmatch "a" {
    "[^\d]" => ()
    _ => fail("Should match non-digit")
  }
  lexmatch " " {
    "[^\d]" => ()
    _ => fail("Should match space")
  }
  lexmatch "5" {
    "[^\d]" => fail("Should not match digit")
    _ => ()
  }
}

///|
test "[^\\s\\d] - not whitespace or digit" {
  lexmatch "a" {
    "[^\s\d]" => ()
    _ => fail("Should match letter")
  }
  lexmatch "_" {
    "[^\s\d]" => ()
    _ => fail("Should match underscore")
  }
  lexmatch "5" {
    "[^\s\d]" => fail("Should not match digit")
    _ => ()
  }
  lexmatch " " {
    "[^\s\d]" => fail("Should not match space")
    _ => ()
  }
}

///|
test "[a-z\\d] - lowercase letter or digit" {
  lexmatch "a" {
    "[a-z\d]" => ()
    _ => fail("Should match lowercase")
  }
  lexmatch "5" {
    "[a-z\d]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "A" {
    "[a-z\d]" => fail("Should not match uppercase")
    _ => ()
  }
}

///|
test "[A-Z\\s] - uppercase or whitespace" {
  lexmatch "A" {
    "[A-Z\s]" => ()
    _ => fail("Should match uppercase")
  }
  lexmatch " " {
    "[A-Z\s]" => ()
    _ => fail("Should match space")
  }
  lexmatch "a" {
    "[A-Z\s]" => fail("Should not match lowercase")
    _ => ()
  }
}

///|
test "[0-9a-fA-F] - hexadecimal digit" {
  lexmatch "0" {
    "[0-9a-fA-F]" => ()
    _ => fail("Should match hex digit 0")
  }
  lexmatch "9" {
    "[0-9a-fA-F]" => ()
    _ => fail("Should match hex digit 9")
  }
  lexmatch "a" {
    "[0-9a-fA-F]" => ()
    _ => fail("Should match hex digit a")
  }
  lexmatch "F" {
    "[0-9a-fA-F]" => ()
    _ => fail("Should match hex digit F")
  }
  lexmatch "g" {
    "[0-9a-fA-F]" => fail("Should not match g")
    _ => ()
  }
}

///|
test "[0-9a-fA-F]+ - hex number sequence" {
  lexmatch "1a2B3c" {
    "[0-9a-fA-F]+" => ()
    _ => fail("Should match hex sequence")
  }
  lexmatch "DEADBEEF" {
    "[0-9a-fA-F]+" => ()
    _ => fail("Should match hex constant")
  }
}

///|
test "[^a-zA-Z] - not a letter" {
  lexmatch "5" {
    "[^a-zA-Z]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "_" {
    "[^a-zA-Z]" => ()
    _ => fail("Should match underscore")
  }
  lexmatch "a" {
    "[^a-zA-Z]" => fail("Should not match letter")
    _ => ()
  }
}

///|
test "\\d\\d\\d - exactly three digits" {
  lexmatch "123" {
    "\d\d\d" => ()
    _ => fail("Should match three digits")
  }
  lexmatch "12" {
    "\d\d\d" => fail("Should not match two digits")
    _ => ()
  }
}

///|
test "\\w\\d\\w - word-digit-word pattern" {
  lexmatch "a5b" {
    "\w\d\w" => ()
    _ => fail("Should match pattern")
  }
  lexmatch "_9Z" {
    "\w\d\w" => ()
    _ => fail("Should match with underscore and uppercase")
  }
}

///|
test "[\\da-f]+ - hex lowercase with digits" {
  lexmatch "12ab" {
    "[\da-f]+" => ()
    _ => fail("Should match hex lowercase")
  }
  lexmatch "ff00" {
    "[\da-f]+" => ()
    _ => fail("Should match hex number")
  }
  lexmatch "12AB" {
    "[\da-f]+" => fail("Should not match uppercase hex")
    _ => ()
  }
}

///|
test "[\\s\\S] - any character (whitespace or non-whitespace)" {
  lexmatch "a" {
    "[\s\S]" => ()
    _ => fail("Should match letter")
  }
  lexmatch " " {
    "[\s\S]" => ()
    _ => fail("Should match space")
  }
  lexmatch "\n" {
    "[\s\S]" => ()
    _ => fail("Should match newline")
  }
}

///|
test "[\\d\\D] - any character (digit or non-digit)" {
  lexmatch "5" {
    "[\d\D]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "x" {
    "[\d\D]" => ()
    _ => fail("Should match non-digit")
  }
}

///|
test "[\\w\\W] - any character (word or non-word)" {
  lexmatch "a" {
    "[\w\W]" => ()
    _ => fail("Should match word char")
  }
  lexmatch "!" {
    "[\w\W]" => ()
    _ => fail("Should match non-word char")
  }
}

///|
test "\\S+ - non-whitespace sequence" {
  lexmatch "hello" {
    "\S+" => ()
    _ => fail("Should match word without spaces")
  }
  lexmatch "a1b2c3" {
    "\S+" => ()
    _ => fail("Should match alphanumeric")
  }
}

///|
test "\\D+ - non-digit sequence" {
  lexmatch "abc" {
    "\D+" => ()
    _ => fail("Should match letters")
  }
  lexmatch "   " {
    "\D+" => ()
    _ => fail("Should match spaces")
  }
}

///|
test "\\W+ - non-word character sequence" {
  lexmatch "   " {
    "\W+" => ()
    _ => fail("Should match spaces")
  }
  lexmatch "!@#" {
    "\W+" => ()
    _ => fail("Should match punctuation")
  }
}

///|
test "[a-zA-Z0-9_] - equivalent to \\w" {
  lexmatch "a" {
    "[a-zA-Z0-9_]" => ()
    _ => fail("Should match lowercase")
  }
  lexmatch "Z" {
    "[a-zA-Z0-9_]" => ()
    _ => fail("Should match uppercase")
  }
  lexmatch "5" {
    "[a-zA-Z0-9_]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "_" {
    "[a-zA-Z0-9_]" => ()
    _ => fail("Should match underscore")
  }
}

///|
test "[ \\t\\r\\n] - equivalent to \\s" {
  lexmatch " " {
    "[ \t\r\n]" => ()
    _ => fail("Should match space")
  }
  lexmatch "\t" {
    "[ \t\r\n]" => ()
    _ => fail("Should match tab")
  }
  lexmatch "\r" {
    "[ \t\r\n]" => ()
    _ => fail("Should match carriage return")
  }
  lexmatch "\n" {
    "[ \t\r\n]" => ()
    _ => fail("Should match newline")
  }
}

///|
test "[0-9] - equivalent to \\d" {
  lexmatch "0" {
    "[0-9]" => ()
    _ => fail("Should match 0")
  }
  lexmatch "5" {
    "[0-9]" => ()
    _ => fail("Should match 5")
  }
  lexmatch "9" {
    "[0-9]" => ()
    _ => fail("Should match 9")
  }
}

///|
test "\\s*\\w+\\s* - word with optional surrounding whitespace" {
  lexmatch "hello" {
    "\s*\w+\s*" => ()
    _ => fail("Should match word without spaces")
  }
  lexmatch " hello " {
    "\s*\w+\s*" => ()
    _ => fail("Should match word with spaces")
  }
  lexmatch "test" {
    "\s*\w+\s*" => ()
    _ => fail("Should match word")
  }
}

///|
test "\\d+\\.\\d+ - decimal number pattern" {
  lexmatch "3.14" {
    "\d+\.\d+" => ()
    _ => fail("Should match decimal")
  }
  lexmatch "123.456" {
    "\d+\.\d+" => ()
    _ => fail("Should match multi-digit decimal")
  }
}

///|
test "[+\\-]?\\d+ - optional sign with digits" {
  lexmatch "123" {
    "[+\-]?\d+" => ()
    _ => fail("Should match unsigned number")
  }
  lexmatch "+123" {
    "[+\-]?\d+" => ()
    _ => fail("Should match positive number")
  }
  lexmatch "-456" {
    "[+\-]?\d+" => ()
    _ => fail("Should match negative number")
  }
}

///|
test "\\s+[a-zA-Z]+\\s+ - word surrounded by whitespace" {
  lexmatch " hello " {
    "\s+[a-zA-Z]+\s+" => ()
    _ => fail("Should match word with spaces")
  }
  lexmatch "\tworld\n" {
    "\s+[a-zA-Z]+\s+" => ()
    _ => fail("Should match word with tab and newline")
  }
}

///|
test "[a-z][a-z0-9]* - identifier starting with lowercase" {
  lexmatch "var" {
    "[a-z][a-z0-9]*" => ()
    _ => fail("Should match lowercase identifier")
  }
  lexmatch "test123" {
    "[a-z][a-z0-9]*" => ()
    _ => fail("Should match identifier with numbers")
  }
}

///|
test "[A-Z][a-zA-Z0-9]* - identifier starting with uppercase" {
  lexmatch "MyClass" {
    "[A-Z][a-zA-Z0-9]*" => ()
    _ => fail("Should match class name")
  }
  lexmatch "Test123Value" {
    "[A-Z][a-zA-Z0-9]*" => ()
    _ => fail("Should match mixed case identifier")
  }
}

///|
test "[a-zA-Z_][a-zA-Z0-9_]* - full identifier pattern" {
  lexmatch "variable" {
    "[a-zA-Z_][a-zA-Z0-9_]*" => ()
    _ => fail("Should match variable name")
  }
  lexmatch "_private" {
    "[a-zA-Z_][a-zA-Z0-9_]*" => ()
    _ => fail("Should match identifier starting with underscore")
  }
  lexmatch "my_var_123" {
    "[a-zA-Z_][a-zA-Z0-9_]*" => ()
    _ => fail("Should match snake_case identifier")
  }
}

///|
test "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3} - IP address pattern" {
  lexmatch "192.168.1.1" {
    "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" => ()
    _ => fail("Should match IP address")
  }
  lexmatch "0.0.0.0" {
    "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" => ()
    _ => fail("Should match zero IP")
  }
}

///|
test "[\\da-fA-F]{2}:[\\da-fA-F]{2} - hex byte pair pattern" {
  lexmatch "FF:00" {
    "[\da-fA-F]{2}:[\da-fA-F]{2}" => ()
    _ => fail("Should match hex byte pair")
  }
  lexmatch "12:ab" {
    "[\da-fA-F]{2}:[\da-fA-F]{2}" => ()
    _ => fail("Should match lowercase hex pair")
  }
}

///|
test "\\w+@\\w+\\.\\w+ - simple email pattern" {
  lexmatch "user@example.com" {
    "\w+@\w+\.\w+" => ()
    _ => fail("Should match simple email")
  }
  lexmatch "test123@domain.org" {
    "\w+@\w+\.\w+" => ()
    _ => fail("Should match email with numbers")
  }
}

///|
test "[a-z]+[0-9]+ - letters followed by numbers" {
  lexmatch "abc123" {
    "[a-z]+[0-9]+" => ()
    _ => fail("Should match pattern")
  }
  lexmatch "test99" {
    "[a-z]+[0-9]+" => ()
    _ => fail("Should match variable with number suffix")
  }
}

///|
test "[0-9]+[a-z]+ - numbers followed by letters" {
  lexmatch "123abc" {
    "[0-9]+[a-z]+" => ()
    _ => fail("Should match pattern")
  }
  lexmatch "42test" {
    "[0-9]+[a-z]+" => ()
    _ => fail("Should match number prefix")
  }
}

///|
test "\\d+[eE][+\\-]?\\d+ - scientific notation exponent" {
  lexmatch "123e10" {
    "\d+[eE][+\-]?\d+" => ()
    _ => fail("Should match exponent")
  }
  lexmatch "5E+3" {
    "\d+[eE][+\-]?\d+" => ()
    _ => fail("Should match positive exponent")
  }
  lexmatch "2e-5" {
    "\d+[eE][+\-]?\d+" => ()
    _ => fail("Should match negative exponent")
  }
}

///|
test "[\\w\\-]+ - word characters and hyphens" {
  lexmatch "hello-world" {
    "[\w\-]+" => ()
    _ => fail("Should match hyphenated word")
  }
  lexmatch "test_value-123" {
    "[\w\-]+" => ()
    _ => fail("Should match complex identifier")
  }
}

///|
test "[\\w\\.]+ - word characters and dots" {
  lexmatch "file.txt" {
    "[\w\.]+" => ()
    _ => fail("Should match filename")
  }
  lexmatch "my.package.name" {
    "[\w\.]+" => ()
    _ => fail("Should match package name")
  }
}

///|
test "[\\d,]+ - digits and commas" {
  lexmatch "1,234,567" {
    "[\d,]+" => ()
    _ => fail("Should match formatted number")
  }
  lexmatch "1000" {
    "[\d,]+" => ()
    _ => fail("Should match plain number")
  }
}

///|
test "\\s*[+\\-*/]\\s* - operator with optional spaces" {
  lexmatch "+" {
    "\s*[+\-*/]\s*" => ()
    _ => fail("Should match plus")
  }
  lexmatch " - " {
    "\s*[+\-*/]\s*" => ()
    _ => fail("Should match minus with spaces")
  }
  lexmatch "*" {
    "\s*[+\-*/]\s*" => ()
    _ => fail("Should match multiply")
  }
  lexmatch "  /  " {
    "\s*[+\-*/]\s*" => ()
    _ => fail("Should match divide with spaces")
  }
}
