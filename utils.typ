#import "@preview/octique:0.1.1": *
#import "@preview/metalogo:1.2.0"
#import "@preview/touying:0.6.1": *
#import themes.university: *

// Logos
#let typst-color = rgb("#239DAD")

#let Typst = text(fill: typst-color, weight: "bold", "Typst")

#let typst-logo = image("images/typst.svg", height: 1em)

#let MS-Word = image("images/msword.svg")

#let Touying = text(fill: rgb("#425066"), weight: "bold", "Touying")

#let Markdown = [#octique-inline("markdown") Markdown]

#let TeX = {
  set text(font: "New Computer Modern", weight: "regular")
  metalogo.TeX
}

#let LaTeX = {
  set text(font: "New Computer Modern", weight: "regular")
  metalogo.LaTeX
}


// Functions

#let linkto(url) = link(url, box(baseline: 30%, move(dy: -.15em, octique-inline(if "github.com" in url {"mark-github"} else {"link"}))))

#let keydown(key) = box(stroke: 2pt, inset: .2em, radius: .2em, baseline: .2em, key)

#let link-with-icon(link) = {
  if type(link.dest) == location { return link }
  if link.body not in (
    box(baseline: 30%, move(dy: -.15em, octique-inline("link"))),
    box(baseline: 30%, move(dy: -.15em, octique-inline("mark-github"))),
  ) [#link #linkto(link.dest)]
  else { link }
}

#let github-repo(repo) = link("https://github.com/" + repo, repo)

#let chapter-slide(body) = focus-slide[
  #align(center + horizon, body)
]

#let new-section-slide(config: (:), level: 1, numbered: true, body) = touying-slide-wrapper(self => {
  let slide-body = context {
    set std.align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em, fill: self.colors.primary, weight: "bold")

    let hidden-title = hide[标题]
    let headings = query(heading)

    let heading-before = {
      let s = headings.filter(h => h.location().page() < here().page() and h.level == level).map(h => link(h.location(), h.body))
      s.at(s.len() - 1, default: hidden-title)
    }

    let headings-after = (..headings.filter(h => h.location().page() > here().page() and h.level == level).map(h => link(h.location(), h.body)), ..(hidden-title, ) * 3)

    stack(
      dir: ttb,
      spacing: .65em,
      text(heading-before, size: 0.6em, fill: gray),
      utils.display-current-heading(level: level, numbered: numbered),
      block(
        height: 2pt,
        width: 100%,
        spacing: 0pt,
        components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light),
      ),
      ..headings-after.enumerate(start: 1).filter(i => i.at(0) <= 2).map(h => text(h.at(1), size: 0.4em / h.at(0) + 0.2em, fill: gray)),
    )
    body
  }
  touying-slide(self: self, config: config, slide-body)
})
