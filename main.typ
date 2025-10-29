#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "@preview/a2c-nums:0.0.1": int-to-cn-ancient-num
#import "utils.typ": *

#let is-handout = sys.inputs.at("handout", default: "false") == "true" // it's risky to use eval
#let show-notes = sys.inputs.at("show-notes", default: "false") == "true" // it's risky to use eval

#let alternative-note = if is-handout { it => it } else { speaker-note }

// global styles
#set text(font: ("IBM Plex Serif", "Source Han Serif", "Noto Serif CJK SC"), lang: "zh", region: "cn")
// #show heading.where(level: 1): set heading(numbering: "1.")
#set text(weight: "medium")
#set par(justify: true)
#set raw(lang: "typ")
#set underline(stroke: .05em, offset: .25em)
#show raw: set text(font: ("IBM Plex Mono", "Cascadia Code", "Source Han Sans", "Noto Sans CJK SC"))
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: .3em, y: 0em),
  outset: (x: 0em, y: .3em),
  radius: .2em,
)
#show raw.where(block: true): set par(justify: false)
#show link: link-with-icon

#show: university-theme.with(
  aspect-ratio: "16-9",
  footer-a: self => self.info.subtitle,
  footer-c: self => (
    h(1fr) + utils.display-info-date(self) + h(1fr) + context utils.slide-counter.display(int-to-cn-ancient-num) + h(1fr)
  ),
  config-common(
    handout: is-handout,
    datetime-format: "[year]年[month]月[day]日",
    new-section-slide-fn: new-section-slide,
    enable-pdfpc: true,
    show-notes-on-second-screen: if show-notes { right },
  ),
  config-info(
    title: [并不复杂的Typst讲座],
    subtitle: [Typst is Simple],
    author: [宋泊萱],
    date: datetime(year: 2024, month: 3, day: 17), // TODO: change this to the date of Talk
    institution: [GTIIT],
    logo: box(move(dy: -.15em, image("images/GTIIT.png", width: 1em)), baseline: 30%) + box(move(dy: -.15em, image("images/GTIC.jpg", width: 1em)), baseline: 30%),
  ),
  // hack for hiding list markers
  // config-methods(cover: (self: none, body) => box(scale(x: 0%, body))),
  config-page(margin: (top: 2.4em))
)

#set document(description: [
  本场分享将带你快速了解现代排版系统 Typst 的特性与使用方法。Typst 融合了 LaTeX 强大的排版能力与 Markdown 的简洁语法，还内置了现代化的脚本语言，支持变量、函数、内容块嵌套等丰富功能。讲座将介绍 Typst 的基本语法、样式设置、实际应用、包管理等内容，并通过丰富案例和对比，展示 Typst 在语法简洁性、编译速度、易用性和可编程性方面的显著优势。无论是编写论文、简历、幻灯片，还是日常笔记或作业，Typst 都能为你带来更流畅、愉悦的编写体验。希望本场分享能帮你快速上手这一轻量又强大的现代排版工具，让文档写作变得既高效又有趣！
])

#title-slide(extra: [
  #set text(size: .5em)
  #place(bottom + right)[Adapted from #github-repo("OrangeX4/typst-talk")]
])

== 目录 <touying:hidden>

#slide(self => context [
  #set text(fill: self.colors.primary, weight: "regular")
  #let entries = query(heading).filter(h => h.level == 1).map(
    h => link(h.location(), stack(
      dir: ltr,
      spacing: .1em,
      text(h.body, weight: "bold"),
      std.h(1fr),
      str(utils.slide-counter.at(h.location()).at(0))
    ))
  )
  #align(horizon, pad(stack(..entries, spacing: .75em), x: 20%))
])

#if not is-handout { chapter-slide[What is Typst] }

= 介绍

== 什么是Typst？

- #Typst 是一个#pause;使用简单、效果优异、功能强大的#meanwhile;排版工具。#pause#pause

/*
- *简单来说：*
  - #Typst = #LaTeX 的排版能力 + #Markdown 的简洁语法 + 强大且现代的脚本语言 #pause

- *运行环境：*Web Wasm / CLI / LSP Language Server
*/

- *编辑器：*
  - *在线：*#link("https://typst.app/")[Web App on #text(fill: blue)[typst.app]]
  - *本地：*#link("https://code.visualstudio.com/")[VS Code] + #link("https://myriad-dreamin.github.io/tinymist/frontend/vscode.html")[Tinymist] / ...


/*
#slide[
  #set align(center + horizon)
  #set text(size: .5em)
  #image("images/typst-introduction.png")
  #place(right + bottom)[#link("https://github.com/Wallbreaker5th/typst-introduction-in-one-page")[一页介绍Typst]]
]


== Typst速览

#slide[
  #set text(.5em)

  #raw(read("examples/fibonacci.typ"), block: true, lang: "typ")

  来源：#link("https://github.com/typst/typst#example")[Typst官方Repo]
][
  #set align(center + horizon)

  #image("examples/fibonacci.svg")
]

#if not is-handout { chapter-slide[Why Typst] }
*/

== Typst优势

- *语法简洁：*上手难度跟Markdown相当，文本源码可阅读性高。#pause

- *编译速度快：*
  // - Typst本身使用Rust语言编写，即 `typ(esetting+ru)st`。
  - 文档增量编译时间一般维持在*数毫秒*到*数十毫秒*。
  - OI Wiki项目文档 #LaTeX 编译用时近1.5小时，而Typst文档用时仅数分钟。#linkto("https://github.com/OI-wiki/OI-Wiki-export/actions")#pause

- *环境搭建简单：*不像 #LaTeX 安装起来困难重重，Typst原生支持中日韩等非拉丁语言，官方Web App和本地VS Code均能*开箱即用*。#pause

- *现代脚本语言：*
  - 变量、函数、闭包与错误检查 + 函数式编程的纯函数理念
  // - 可嵌套的 `[标记模式]`、`#{脚本模式}` 与 `$数学模式$` //#strike[不就是JSX嘛]
  - 统一的包管理，支持按需*自动*安装第三方包

/**
== Typst对比其他排版系统

#slide[
  #set text(.7em)
  #let 难 = text(fill: rgb("#aa0000"), weight: "bold", "难")
  #let 易 = text(fill: rgb("#007700"), weight: "bold", "易")
  #let 多 = text(fill: rgb("#aa0000"), weight: "bold", "多")
  #let 少 = text(fill: rgb("#007700"), weight: "bold", "少")
  #let 慢 = text(fill: rgb("#aa0000"), weight: "bold", "慢")
  #let 快 = text(fill: rgb("#007700"), weight: "bold", "快")
  #let 弱 = text(fill: rgb("#aa0000"), weight: "bold", "弱")
  #let 强 = text(fill: rgb("#007700"), weight: "bold", "强")
  #let 较强 = text(fill: rgb("#007700"), weight: "bold", "较强")
  #let 中 = text(fill: blue, weight: "bold", "中等")
  #let cell(top, bottom) = stack(spacing: .2em, top, block(height: 2em, text(size: .7em, bottom)))

  #v(1em)
  #figure(
    table(
      columns: 8,
      stroke: none,
      align: center + horizon,
      inset: .5em,
      table.hline(stroke: 2pt),
      [排版系统], [安装难度], [语法难度], [编译速度], [排版能力], [模板能力], [编程能力], [方言数量],
      table.hline(stroke: 1pt),
      LaTeX, cell[#难][选项多 + 体积大 + 流程复杂], cell[#难][语法繁琐 + 嵌套多 + 难调试], cell[#慢][宏语言编译\ 速度极慢], cell[#强][拥有最多的\ 历史积累], cell[#强][拥有众多的\ 模板和开发者], cell[#中][图灵完备\ 但只是宏语言], cell[#中][众多格式、\ 引擎和发行版],
      octique("markdown"), cell[#易][大多编辑器\ 默认支持], cell[#易][入门语法十分简单], cell[#快][语法简单\ 编译速度较快], cell[#弱][基于HTML\ 排版能力弱], cell[#中][语法简单\ 易于更换模板], cell[#弱][图灵不完备 \ 需要外部脚本], cell[#多][方言众多\ 且难以统一],
      MS-Word, cell[#易][多数电脑\ 默认安装], cell[#易][所见即所得], cell[#中][能实时编辑\ 大文件会卡顿], cell[#强][大公司开发\ 通用排版软件], cell[#弱][二进制格式\ 难以自动化], cell[#弱][编程能力极弱], cell[#少][统一的标准和文件格式],
      typst-logo, cell[#易][安装简单\ 开箱即用], cell[#中][入门语法简单\ 进阶使用略难], cell[#快][增量编译渲染\ 速度最快], cell[#较强][已满足日常\ 排版需求], cell[#强][制作和使用\ 模板都较简单], cell[#强][图灵完备\ 现代编程语言], cell[#少][统一的语法\ 统一的编译器],
      table.hline(stroke: 2pt),
    ),
  )
]

/**
#slide[
  #set align(center + horizon)
  #v(-1.5em)
  #image("images/meme.png")
  #v(-1.5em)
  From Reddit #link("https://www.reddit.com/r/LaTeX/comments/z2ifki/latex_vs_word_vs_pandoc_markdown/")[r/LaTeX] and modified by OrangeX4
]
**/

== Typst vs #LaTeX
#[
  #set text(size: 0.8em)
  #align(horizon, grid(align: horizon, columns: (1fr, 1fr, 1fr), column-gutter: 1em, row-gutter: 2em)[
    ```typ
    + 项目 1
    + 项目 2
    ```
  ][
    ```tex
    \begin{enumerate}
      \item 项目 1
      \item 项目 2
    \end{enumerate}
    ```
  ][
    + 项目 1
    + 项目 2
  ][
    ```typ
    - Point 1
    - Point 2
    ```
  ][
    ```tex
    \begin{itemize}
      \item Point 1
      \item Point 2
    \end{itemize}
    ```
  ][
    - Point 1
    - Point 2
  ][
    ```typ
    $ lim_(x->oo) 1/x = 0 $
    ```
  ][
    ```tex
    \[
      \lim_{x \to \infty} \frac{1}{x} = 0
    \]
    ```
  ][
    $ lim_(x->oo) 1/x = 0 $
  ])

  ---

  #align(
    horizon,
    grid(
      align: horizon,
      columns: (1fr, 1fr),
      column-gutter: 1em,
      row-gutter: 2em,
      [
        ```typ
        $ det mat(a, b; c, d) = mat(delim: "|", a, b; c, d) = a d - b c $
        ```
      ],
      [
        ```tex
        \[ \det \begin{pmatrix} a & b \\ c & d \end{pmatrix} = \begin{vmatrix} a & b \\ c & d \end{vmatrix} = ad - bc \]
        ```
      ],
      grid.cell(colspan: 2)[
        $ det mat(a, b; c, d) = mat(delim: "|", a, b; c, d) = a d - b c $
      ]
    )
  )
]
**/

/*
== Typst当前局限
Typst还是一个#link("https://typst.app/about/#new-foundation")[很年轻的项目]，因此相比于 #LaTeX 还有一些不足：

- *API尚未完全稳定：*
  - 当前版本号为#sys.version，语法和函数在后续版本中可能发生变动。

- *排版细节仍在打磨：*
  - Justify（「两端对齐」）、数学公式等部分排版细节尚不如 #LaTeX。

- *生态系统处于早期：*
  - 虽然社区非常活跃，但可用包和模板的数量与CTAN的宏包海洋相比还有明显差距。
  - 此外，许多专业场景要求使用 #LaTeX，Typst在这些领域的接受度仍有待提高。
*/

/*

#if not is-handout { chapter-slide[How to use Typst] }

= 安装

== 云端使用

- 官方提供了#link("https://typst.app/")[Web App]，可以直接在浏览器中使用 #pause

- *优点：*
  - 即开即用，无需安装。
  - 类似于 #LaTeX 的Overleaf，可以直接编辑、编译、分享文档。
  - 拥有*「多人协作」*支持，可以实时共同编辑。#pause

- *缺点：*
  - 中文字体较少，经常需要手动上传字体文件，但有上传大小限制。
  - 缺少版本控制，目前无法与GitHub等代码托管平台对接。


== 本地使用（推荐）

- *#link("https://github.com/Myriad-Dreamin/tinymist")[Tinymist] + *
  - *#link("https://myriad-dreamin.github.io/tinymist/frontend/vscode.html")[VS Cod(e,ium)]*（推荐）：安装「Tinymist Typst」插件。
  - *#link("https://myriad-dreamin.github.io/tinymist/frontend/main.html")[其他编辑器]*：安装Tinymist后端，并配置LSP客户端。
  // - 新建一个 `.typ` 文件，然后按下 #keydown[Ctrl] + #keydown[K] #keydown[V] 即可实时预览。
  - *不再需要其他配置*，例如我们并不需要命令行安装Typst CLI。#pause

- *#link("https://github.com/typst/typst#installation")[官方CLI]：* `typst compile --root <DIR> <INPUT_FILE>`
  - Windows: `winget install --id Typst.Typst`
  - macOS: `brew install typst`
  - Linux：在#link("https://repology.org/project/typst/versions")[Repology]上查看Typst，或使用#link("https://snapcraft.io/typst")[Snap]安装。
  - Rust工具链：`cargo install --locked typst-cli`
*/

= 快速入门

== Hello World

#slide[
  #set text(.5em)
  #raw(read("examples/poster.typ").split("\n\n\n").at(1, default: ""), lang: "typ", block: true)
][
  #set align(center + horizon)
  #v(-1em)
  #image("examples/poster.svg")
]


== 标记只是语法糖

#slide[
  ````typ
  = 一级标题

  == 二级标题

  简单的段落，可以*加粗*和_强调_。


  - 无序列表
  + 有序列表
  / 术语: 术语列表

  ```py
  print('Hello Typst!')
  ```
  ````
][
  ````typ
  #heading(level: 1, [一级标题])

  #heading(level: 2, [二级标题])

  简单的段落，可以#strong[加粗]和#emph[强调]。

  #list.item[无序列表]
  #enum.item[有序列表]
  #terms.item[术语][术语列表]

  #raw("print('Hello Typst!')", lang: "py", block: true)
  ````
]


== 核心概念

- *Simplicity through Consistency*
  - 类似Markdown的特殊标记语法，实现*「内容与格式分离」*。
  - `= 一级标题` 只是 `#heading[一级标题]` 的*语法糖*。#pause
- *标记模式和脚本模式*
  - 标记模式下，使用井号 `#` 进入脚本模式，如 `#strong[加粗]`。
    - 脚本模式下不需要额外井号，例如 `#heading(strong([加粗]))`
    - 大段脚本代码可以使用花括号 `{}`，例如 `#{1 + 1}`。#pause
  - 脚本模式下，使用方括号 `[]` 进入标记模式，称为*内容块*。
    - Typst是强类型语言，有常见的数据类型，如 `int` 和 `str`。
    - 内容块 `[]` 类型 `content` 是Typst的核心类型，可嵌套使用。
    - `#fn(..)[XXX][YYY]` 是 `#fn(.., [XXX], [YYY])` 的*语法糖*。


== Set/Show Rules

- *Set规则可以设置样式，即「为函数设置参数默认值」的能力。*
  - 例如 `#set heading(numbering: "1.")` 用于设置标题的编号。
  - 使得 `#heading[标题]` 变为 `#heading(numbering: "1.", [标题])`。#pause

- *Show规则用于全局替换，即在语法树上进行「宏编程」的能力。*
  - 例如 `#show "LaTeX": "Typst"` 将单词 `LaTeX` 替换为 `Typst`。
  - 例如让一级标题居中，可以用*「箭头函数」*：
    - #block(
        width: 100%,
        fill: luma(240),
        inset: (x: .3em, y: 0em),
        outset: (x: 0em, y: .3em),
        radius: .2em,
        ```typ
        #show heading.where(level: 1): body => {
          set align(center)
          body
        }
        ```,
      )
    - 化简为 `#show heading.where(level: 1): set align(center)`


== 数学公式

- `$x$` 是行内公式，`$ x^2 + y^2 = 1 $ <circle>` 是行间公式。#pause

- 与 #LaTeX 的差异：
  - ```typm (x + 1) / x >= 1 => 1/x >= 0```
  - ```tex \frac{x + 1}{x} \ge 1 \Rightarrow \frac{1}{x} \ge 0``` #pause

- *报告，我想用#link("https://github.com/mitex-rs/mitex")[LaTeX语法]：*

```typ
#import "@preview/mitex:0.2.5": *

Write inline equations like #mi("x") or #mi[y].
#mitex(`
  \frac{x + 1}{x} \ge 1 \Rightarrow \frac{1}{x} \ge 0
`)
```

= 制作模板

== 制作论文模板

现在，我们想要为一个会议制作一个模板，以下是*需求规范*：

+ *字体*应为11pt的衬线字体；
+ *标题*应为17pt的粗体，居中对齐；
+ 论文包含*单栏摘要*和*两栏正文*；
+ *摘要*应居中；
+ *正文*应两端对齐；
+ *一级章节标题*应为13pt，居中并以小写字母呈现；
+ *二级标题*是短标题，斜体，与正文文本具有相同的大小；
+ 最后，*页面尺寸*应为US letter，编号在页脚的中心，每页的左上角应包含论文的标题。


#slide[
  #set text(.65em)
  #show: columns.with(2)
  #show raw.where(block: true): block.with(width: 100%, fill: luma(240), outset: .7em, radius: .2em)
  #raw(read("examples/conference.typ").split("\n\n\n\n").at(0), block: true, lang: "typ")

  来源：#link("https://typst.app/docs/tutorial/making-a-template/")[Typst官方文档]
]

#slide[
  #set text(.5em)
  #v(-1em)
  #show raw.where(block: true): set block(breakable: false)
  #raw(read("examples/conference.typ").split("\n\n\n\n").at(1, default: ""), block: true, lang: "typ")
][
  #set align(right + horizon)
  #show: rect.with(stroke: .5pt)
  #image("examples/conference.svg")
]


== 制作简历模板

#slide(composer: (1fr, auto))[
  - Word / HTML简历模板？
    - *不够美观* #pause

  - #LaTeX 简历模板？
    - *环境配置复杂*
    - *自主定制困难* #pause

  - #Typst 简历模板？
    - *绝对优势领域*
    - #link("https://github.com/OrangeX4/Chinese-Resume-in-Typst")[*Chinese-Resume-in-Typst*]

  #meanwhile
][
  #set align(center + horizon)
  #show: rect.with(stroke: .5pt)
  #image("images/resume.png")
]

#slide(composer: (1fr, auto))[
  #set text(.5em)
  #show: columns.with(2)

  #raw(read("examples/chicv.typ"), lang: "typ", block: true)

  #set text(1.5em)
  来源：#link("https://github.com/skyzh/chicv")[chicv]
][
  #set align(center + horizon)
  #show: rect.with(stroke: .5pt)
  #image("examples/chicv.svg")
]

/**
== 案例：南京大学学位论文

#slide(composer: (1fr, auto))[
  - #link("https://github.com/nju-lug/modern-nju-thesis")[*modern-nju-thesis*]
    - 总共开发时间：*一周*
    - 语法简洁、编译迅速
    - 通过*「闭包」*封装保存全局配置
    - *本科生模板 + 研究生模板*

  #set text(.65em)
  #show: columns.with(3)
  #show raw.where(block: true): block.with(width: 100%, fill: luma(240), outset: .5em, radius: .2em)

  ```typ
  // 文稿设置
  #show: doc
  // 封面页
  #cover()
  // 声明页
  #decl-page()
  // 前言
  #show: preface
  // 中文摘要
  #abstract(
    keywords: ("我", "就是", "测试用", "关键词")
  )[
    中文摘要
  ]
  // 目录
  #outline-page()
  // 插图目录
  #list-of-figures()
  // 表格目录
  #list-of-tables()
  // 正文
  #show: mainmatter

  = 基本功能

  == 脚注

  我们可以添加一个脚注。#footnote[脚注内容]
  ```
][
  #set align(center + horizon)
  #show: rect.with(stroke: .5pt)
  #image("images/nju-thesis.png")
]
**/

= 制作Slides

== Touying

- #Touying 是为Typst开发的Slides包，类似于 #LaTeX 的Beamer。
  - 取自中文「*投影*」，而Beamer是德语「*投影仪*」的意思。#linkto("https://touying-typ.github.io/zh/") #pause

- *基本框架：*
  - 使用 `= 节`、`== 小节` 和 `=== 标题` 划分Slides结构。
  - 使用 `#slide[..]` 块来实现更优雅且精细的控制。 #pause

- *使用主题：*`#show: xxx-theme.with()` #pause

- *动画：*
  - `#pause` 和 `#meanwhile` 标记。
  - `#only("2-")[]`、`#uncover("2-")[]` 和 `#alternatives[][]`。


#slide(composer: (0.4fr, 0.6fr))[
  #set text(.5em)
  #show: columns.with(2, gutter: 3em)

  ```typ
  #import "@preview/touying:0.6.1": *
  #import themes.aqua: *

  #show: aqua-theme.with(
    aspect-ratio: "16-9",
    config-info(
      title: [Title],
      subtitle: [Subtitle],
      author: [Authors],
      date: datetime.today(),
      institution: [Institution],
    ),
  )

  #title-slide()

  #outline-slide()

  = The Section

  == Slide Title

  #lorem(40)

  #focus-slide[
    Another variant with primary color in background...
  ]

  == Summary

  #slide(self => [
    #align(center + horizon)[
      #set text(size: 3em, weight: "bold", fill: self.colors.primary)
      THANKS FOR ALL
    ]
  ])

  ```

  来源：#link("https://touying-typ.github.io/zh/docs/themes/aqua")[Touying文档]
][
  #set align(center + horizon)
  #image("examples/touying.png")
]


== Pinit

- *Pinit*包提供基于*「图钉」（pin）*进行相对定位的能力。

- 可以方便地实现*「箭头指示」*与*「解释说明」*的效果。

- *一个简单示例：*

#grid(columns: 2, gutter: 1em)[
  #set text(.85em)
  #show raw.where(block: true): block.with(width: 100%, fill: luma(240), outset: .7em, radius: .2em)

  ```typ
  #import "@preview/pinit:0.2.2": *
  #set text(size: 24pt)

  A simple #pin(1)highlighted text#pin(2).

  #pinit-highlight(1, 2)

  #pinit-point-from(2)[It is simple.]
  ```
][
  #show: align.with(center + horizon)
  #show: block.with(breakable: false)
  #v(-2em)
  #image("images/pinit-1.png")
  #image("images/pinit-2.png")
]

#slide[
  #set align(center + horizon)
  #image(height: 115%, "images/pinit-3.png")
  #set text(.8em)
  #place(top + left, dy: -.5em)[使用 #Typst 和*Pinit*复刻算法课的Slides，样式来源于 #linkto("https://chaodong.me/")]
  #place(
    top + right,
    dx: 1.5em,
    dy: -.5em,
  )[#link("https://touying-typ.github.io/zh/docs/integration/pinit")[*示例代码*]]
]


/*
== Touying对比其他Slides方案

#slide[
  #set text(.7em)
  #let 难 = text(fill: rgb("#aa0000"), weight: "bold", "难")
  #let 易 = text(fill: rgb("#007700"), weight: "bold", "易")
  #let 慢 = text(fill: rgb("#aa0000"), weight: "bold", "慢")
  #let 快 = text(fill: rgb("#007700"), weight: "bold", "快")
  #let 弱 = text(fill: rgb("#aa0000"), weight: "bold", "弱")
  #let 强 = text(fill: rgb("#007700"), weight: "bold", "强")
  #let 中 = text(fill: blue, weight: "bold", "中等")
  #let cell(top, bottom) = stack(spacing: .2em, top, block(height: 2em, text(size: .7em, bottom)))

  #v(1em)
  #figure(
    table(
      columns: 8,
      stroke: none,
      align: center + horizon,
      inset: .5em,
      table.hline(stroke: 2pt),
      [方案], [语法难度], [编译速度], [排版能力], [模板能力], [编程能力], [动画效果], [代码公式],
      table.hline(stroke: 1pt),
      [PowerPoint], cell[#易][所见即所得], cell[#快][实时编辑], cell[#强][大公司开发\ 通用软件], cell[#强][模板数量最多\ 容易制作模板], cell[#弱][编程能力极弱\ 难以显示进度], cell[#强][动画效果多\ 但用起来复杂], cell[#难][难以保证代码和公式一致性],
      [Beamer], cell[#难][语法繁琐 + 嵌套多 + 难调试], cell[#慢][宏语言编译\ 速度极慢], cell[#弱][使用模板后\ 排版难以修改], cell[#中][拥有较多模板\ 开发模板较难], cell[#中][图灵完备\ 但只是宏语言], cell[#中][简单动画方便\ 无过渡动画], cell[#易][基本默认支持],
      [#Markdown], cell[#易][入门语法十分简单], cell[#快][语法简单\ 编译速度较快], cell[#弱][语法限制\ 排版能力弱], cell[#弱][难以制作模板\ 只有内置模板], cell[#弱][图灵不完备\ 需要外部脚本], cell[#中][动画效果全看提供了什么], cell[#易][基本默认支持],
      [#Touying], cell[#易][语法简单\ 使用方便], cell[#快][增量编译渲染\ 速度最快], cell[#中][满足日常学术\ Slides需求], cell[#强][制作和使用\ 模板都较简单], cell[#强][图灵完备\ 现代编程语言], cell[#中][简单动画方便\ 无过渡动画], cell[#易][默认支持\ MiTeX包],
      table.hline(stroke: 2pt),
    ),
  )
]
*/


== 一些常见的Slides问题

- *能不能插入LaTeX公式？*
  - 可以，只需要使用#link("https://github.com/mitex-rs/mitex")[MiTeX包]。 #pause

- *能不能加入GIF动图或者视频？*
  - GIF动图可以，但是要使用*Tinymist*插件的Slide模式。
    - 这是因为*Tinymist*插件是*基于SVG*的。 #pause

- *插入图片方便吗？*
  - 方便，比如本讲座的Slides就有一堆图片。
    - 你可以使用*grid布局*。
    - 也可以使用*Pinit*包的*「图钉」*功能。


/**
= 包管理

== Typst包管理

Typst有一个简单但强大的包管理方案。
- 包可以通过 `#import "@preview/pkg:1.0.0"` 的方式导入。
  - *按需自动下载和自动导入第三方包。*
    - 因此我们不需要像TeX Live一样全量安装吃满硬盘。
  - #link("https://typst.app/universe")[*Typst Universe*]（官方仓库）中的包使用 `@preview` 命名空间。
  - 需要写上版本号，以保证文档源代码可复现性。
- 包目前存放于统一的#link("https://github.com/typst/packages")[GitHub Repo] 中。
- 包可以是*Package*和*Template*。
- 包也可以存放在本地（`@local`），并且可以全局导入。
// - Typst有一个#link("https://typst.app/universe")[*Typst Universe*]，可以浏览已有包。


== WASM插件

- *WASM*是一种基于*Web*的*跨平台*汇编语言表示。

- Typst有*WASM Plugin*功能，也就是说：
  - Typst的包并不一定要是纯Typst代码。
  - Typst的包基本上可以用*任意语言*编写，例如*Rust*和*JS*。#pause

- 一些WASM包的例子：
  - *jogs：*封装*QuickJS*，在Typst中运行*JavaScript*代码。
  - *pyrunner：*在Typst中运行*Python*代码。
  - *tiaoma：*封装*Zint*，生成条码和二维码。
  - *diagraph：*在Typst中使用*Graphviz*。
**/



/**
= Typst生态开发体验

/**
== 我参与开发的项目

- *Touying：*#Touying 是为 Typst 开发的 Slides 包。#linkto("https://github.com/touying-typ/touying")
- *MiTeX：*一个 Rust 写的*转译器*，用于快速地渲染 *LaTeX 公式*。#linkto("https://github.com/mitex-rs/mitex")
- *Pinit：*提供基于*「图钉」（pin）*进行相对定位的能力。#linkto("https://github.com/OrangeX4/typst-pinit")
- *modern-nju-thesis：*基于 #Typst 的南京大学学位论文。#linkto("https://github.com/nju-lug/modern-nju-thesis")
- *Chinese-Resume-in-Typst：*美观的 #Typst 中文简历。#linkto("https://github.com/OrangeX4/Chinese-Resume-in-Typst")
- *Tablem：*在 #Typst 中支持 #Markdown 形式的表格。#linkto("https://github.com/OrangeX4/typst-tablem")
- *Typst Sympy Calculator：*在 *VS Code* 中做科学符号运算。#linkto("https://github.com/OrangeX4/vscode-typst-sympy-calculator")
- *Typst Sync：*云端同步本地包的 *VS Code* 插件。#linkto("https://github.com/OrangeX4/vscode-typst-sync")
**/


== 开发体验

- Typst生态现状：#strike[*勃勃生机，万物竞发*] #pause

- 语法简单，强类型语言，易于开发和调试。
  - 写起DSL也很方便，比如*MiTeX*、#Touying 和*Tablem*。#pause

- 还有很多功能可以开发，#strike[例如把 #LaTeX 的宏包全都复刻一遍]。#pause

- *一些例子：*
  - 国人开发的*Tinymist*插件。
  - *Pandoc*支持和*Quarto*支持。
  - 在网页上运行 #Typst：#link("https://myriad-dreamin.github.io/typst.ts/")[typst.ts] 和#link("https://myriad-dreamin.github.io/shiroa/")[shiroa]。
  - 在*VS Code*的编辑器里显示数学符号的*Typst Math*插件。
**/


= 最后

== 参考与鸣谢

#slide[
  #set enum(numbering: "[1]")

  + #link("https://typst.app/docs")[#Typst 官方文档]

  + #link("https://github.com/stone-zeng/latex-talk")[*现代 #LaTeX 入门讲座*]

  + #link("https://github.com/typst-doc-cn/tutorial")[*#Typst 中文教程*]

  + *#github-repo("OrangeX4/typst-talk")*

  + *Typst非官方中文交流群* #link("https://qm.qq.com/q/NdO2B2Bos4")[793548390]

  // + *南京大学Typst交流群* 943622984
]


== 关于

#slide[
  *本幻灯片：*#github-repo("Goosople/typst-talk")，修改自#github-repo("OrangeX4/typst-talk")

  *最后更新：*#datetime.today().display()

  *License：*CC BY-SA 4.0

  *作者：*#link("https://github.com/OrangeX4")[OrangeX4]，#link("https://github.com/Goosople")[Goosople]
]

#if not is-handout { chapter-slide[Hands-on experience!] }

#focus-slide[
  #set align(center + horizon)
  \#thanks
]
