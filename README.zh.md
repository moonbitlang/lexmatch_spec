这个 repo 被看做是 MoonBit 语言中 lexmatch 特性的 spec test suite。

## 介绍 lexmatch 特性

MoonBit 致力于成为数据处理任务的完美语言。目前，`match` 表达式是解构和分析数据的主要方式。然而，在字符串处理方面，它不如正则表达式强大。`lexmatch` 特性结合了 `match` 和正则表达式的能力，提供了一种更灵活、更强大的方式来分析和解构字符串。

lexmatch 特性在 MoonBit 中分为 `lexmatch` 表达式和 `lexmatch?` 表达式两种形式。

- **`lexmatch` 表达式**：类似已有的 `match` 表达式，区别在于 `lexmatch` 表达式中的 pattern 是不同于普通的 pattern 的"词法模式（lex pattern）"，这种 pattern 可以用于匹配 `StringView` 和 `BytesView` 类型，并且在匹配时可以捕获子串。

- **`lexmatch?` 表达式**：类似于已有的 `is` 表达式，区别在于右侧的 pattern 是"词法模式"，用于检查 `StringView` 和 `BytesView` 类型的值是否符合某种词法结构，并且可以捕获子串。表达式的整体结果是布尔值，表示是否匹配成功。

### 示例

#### 单词计数

```moonbit
///|
pub fn wordcount(
  input : BytesView,
  lines : Int,
  words : Int,
  chars : Int,
) -> (Int, Int, Int) {
  lexmatch input with longest {
    ("\n", rest) => wordcount(rest, lines + 1, words, chars)
    ("[^ \t\r\n]+" as word, rest) =>
      wordcount(rest, lines, words + 1, chars + word.length())
    (".", rest) => wordcount(rest, lines, words, chars + 1)
    "" => (lines, words, chars)
    _ => panic()
  }
}
```

上面的例子展示了如何使用 `lexmatch` 表达式对 `input` 进行词法分析，统计其中的行数、单词数和字符数。这里的 pattern 包含了捕获子串的能力，比如 `("[^ \t\r\n]+" as word, rest)` 这个 pattern 可以匹配一个非空白字符序列，并将其捕获为 `word`。

#### 可下载协议提取器

```moonbit
///|
pub fn downloadable_protocol(url: StringView) -> StringView? {
  if url lexmatch? (("(?i:ftp|http(s)?)" as protocol) "://", _) with longest {
    Some(protocol)
  } else {
    None
  }
}
```

这个例子展示了如何使用 `lexmatch?` 表达式检查 `url` 是否以可下载的协议（ftp、http、https）开头，并捕获该协议。这里还演示了不区分大小写修饰符 `(?i:...)` 的使用。

### 核心概念

#### 术语解释

- **目标（Target）**：被 `lexmatch` 匹配的 `StringView` 或 `BytesView`。

- **匹配策略（Match Strategy）**：用于匹配模式的策略，可以是 `longest`（最长匹配）或 `first`（首次匹配，默认，当前尚不可用）。本提案专注于 `longest` 匹配策略。

- **兜底分支（Catch-all case）**：左侧为变量或通配符 `_` 的分支，可以匹配任何目标。必须放在 `lexmatch` 分支的末尾，用于处理未匹配的情况。

- **词法模式（Lex Pattern）**：`lexmatch` 分支左侧（`=>` 之前）的模式部分（不同于守卫部分，目前 `lexmatch` 尚不支持守卫）。

  词法模式可以是以下形式之一：
  - **裸正则模式**：正则模式将匹配整个目标。例如：`""`
  - **正则模式 + 剩余变量**：正则模式匹配目标的前缀，剩余变量绑定到剩余的后缀。剩余变量可以是变量或通配符 `_`。这种形式需要使用括号以提高可读性。例如：`("\n", rest)`

- **正则模式（Regex Pattern）**：正则模式有三种形式：
  - **正则字面量**：表示正则模式的字符串字面量。例如：`"[^ \t\r\n]+"`。注意，正则字面量必须使用双引号括起来，并且不需要双重转义，比如要匹配反斜杠字符，应使用 `"\\"` 而不是 `"\\\\"`。
  - **捕获（Capture）**：正则模式后跟 `as` 和变量名来捕获匹配的子串。例如：`"[^ \t\r\n]+" as word`。如果词法模式是此形式的裸正则模式，则需要括号。
  - **序列（Sequence）**：由空格分隔的正则模式序列。例如：`"//" ("[^\r\n]*" as comment)`。如果词法模式是此形式的裸正则模式，则需要括号。

  正则模式可以嵌套形成更复杂的模式。

#### 正则字面量语法速记表

- 普通字符（Literal Characters），除特殊字符（`\`、`[`、`]`、`(`、`)`、`{`、`}`、`.`、`*`、`+`、`?`、`|`、`^`、`$`）之外的字符，匹配其字面量值，例如：`a`、`Z`、`0`、`@` 等
- `.`：匹配任何单个字符，包括换行符
- 转义字符（Escape Characters）
  - `\n`：换行符
  - `\r`：回车符
  - `\t`：制表符
  - `\\`：反斜杠字符
  - `\[`、`\]`、`\(`、`\)`、`\{`、`\}`、`\.`、`\*`、`\+`、`\?`、`\|`、`\^`、`\$`：匹配相应的字面量字符
  - `\xhh`：匹配十六进制值为 `hh` 的字符（`hh` 是两个十六进制数字）
  - `\uhhhh`：匹配 Unicode 码点为 `hhhh` 的字符（`hhhh` 是四个十六进制数字）。注意在目标为 `BytesView` 时，此转义序列无效。
  - `\u{h...}`：匹配 Unicode 码点为 `h...` 的字符（`h...` 是一个或多个十六进制数字）。注意在目标为 `BytesView` 时，此转义序列无效。
- 字符类（Character Classes）
  - `\s`：匹配 ASCII 范围内的任何空白字符，等价于 `[ \t\r\n\f\v]`
  - `\S`：匹配 ASCII 范围内的任何非空白字符，等价于 `[^ \t\r\n\f\v]`
  - `\d`：匹配 ASCII 范围内的任何数字字符，等价于 `[0-9]`
  - `\D`：匹配 ASCII 范围内的任何非数字字符，等价于 `[^0-9]`
  - `\w`：匹配 ASCII 范围内的任何单词字符，等价于 `[a-zA-Z0-9_]`
  - `\W`：匹配 ASCII 范围内的任何非单词字符，等价于 `[^a-zA-Z0-9_]`
- 字符集合（Character Sets）
  - `[abc]`：匹配字符 `a`、`b` 或 `c`
  - `[a-z]`：匹配从 `a` 到 `z` 范围内的任何字符
  - `[^abc]`：匹配除字符 `a`、`b` 和 `c` 之外的任何字符
  - `[^a-z]`：匹配不在 `a` 到 `z` 范围内的任何字符
  - `[\d\s]`：匹配任何数字字符或空白字符
- 量词（Quantifiers）
  - `*`：匹配前面的子表达式零次或多次
  - `+`：匹配前面的子表达式一次或多次
  - `?`：匹配前面的子表达式零次或一次
  - `{n}`：匹配前面的子表达式恰好 n 次
  - `{n,}`：匹配前面的子表达式至少 n 次
  - `{n,m}`：匹配前面的子表达式至少 n 次，但不超过 m 次
- 位置锚点（Anchors）
  - `$`：匹配输入字符串的结束位置
- 作用域修饰符（Scoped Modifiers）
  - `(?i:...)`：不区分大小写匹配括号内的子表达式

#### 语义说明

`lexmatch` 表达式的工作方式类似于 `match` 表达式，但有以下区别：

1. `lexmatch` 表达式的目标必须是 `StringView` 或 `BytesView`。
2. 除兜底分支外，每个 `lexmatch` 分支的左侧必须是词法模式。
3. 匹配策略可以在 `with` 关键字后指定。如果未指定，默认策略是 `first`（目前不可用）。
4. 词法模式中的正则模式使用指定的匹配策略对目标进行匹配。
5. 如果正则模式匹配目标，模式中的任何捕获变量都将绑定到相应的匹配子串。
6. 如果正则模式后跟逗号和剩余变量匹配目标，正则模式将匹配目标的前缀，剩余变量绑定到剩余的后缀。
7. 如果没有词法模式匹配目标，将执行兜底分支。

#### 特殊之处

- 捕获单个字符时，匹配的子串是 `Char` 或 `Byte`，而不是 `StringView` 或 `BytesView`。例如：`"[+\-]" as sign`

- 正则字面量基本等同于JavaScript正则表达式在开启v flag下的语法，但有以下区别：
  - `"(abc)"` 正则模式不会引入捕获组。要捕获匹配的子串，需要使用 `as` 语法。例如：`"abc" as group` 而不是 `"(abc)"`。
  - 默认非多行模式（目前不支持多行模式），`$` 匹配字符串的结尾。`.` 匹配所有字符，包括换行符。
  - 作用域修饰符语法（如 `(?i:...)`）每个组只能启用一个修饰符。例如，目前不支持 `(?im:...)`。也不支持否定修饰符，如 `(?-i:...)`。目前，唯一支持的修饰符是 `i`（不区分大小写）。
  - 出于未来增加插值支持的考虑，正则字面量不支持使用"\{"来匹配左大括号字符。同理，右大括号字符也不支持使用"\}"来匹配。如果你需要匹配大括号字符，请使用字面量字符 `[{]` 和 `[}]`。

### 使用技巧

#### 在字符串中搜索标记

```moonbit
pub fn search_marker(str: StringView) -> StringView? {
  for curr = str {
    lexmatch curr with longest {
      "" => return None
      ("MARKER", right) => return Some(right)
      (".", rest) => continue rest
      _ => panic()
    }
  }
}
```

### 常见问题

**Q: 为什么不直接在 `match` 表达式中使用正则模式？**

A: `match` 表达式是为结构模式匹配而设计的，而 `lexmatch` 表达式是为词法分析而设计的。混合这两个概念可能会导致混淆和复杂性。通过为词法分析引入单独的表达式，我们可以保持语义清晰和专注。
