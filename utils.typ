#import "@preview/octique:0.1.1": *
#import "@preview/metalogo:1.2.0"
#import "@preview/touying:0.6.1": *
#import "@preview/tiaoma:0.3.0"
#import "@preview/pinit:0.2.2"
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

#let button(key, stroke-color: none) = {
  set text(font: ("IBM Plex Sans", "Adwaita Sans", "Linux Biolinum O"), size: .9em)
  box(stroke: 1.5pt + stroke-color, inset: (x: .25em, y: .05em), outset: (x: 0em, y: .25em), radius: .2em, key)
}

#let small = text.with(size: .75em)

#let link-with-icon(link) = {
  if type(link.dest) == location { return link }
  if link.body not in (
    box(baseline: 30%, move(dy: -.15em, octique-inline("link"))),
    box(baseline: 30%, move(dy: -.15em, octique-inline("mark-github"))),
  ) [#link #linkto(link.dest)]
  else { link }
}

/** buggy as for now
#let link-with-qrcode(link) = context {
  if type(link.dest) == location { return link }
  let x = here().position().x
  let y = here().position().y
  let p = here().page()
  let starting-pin = link.dest + repr((p, x, y))
  let ending-pin = link.dest + repr((x, y, p))
  if link.body not in (
    box(baseline: 30%, move(dy: -.15em, octique-inline("link"))),
    box(baseline: 30%, move(dy: -.15em, octique-inline("mark-github"))),
  ) [
    #pinit.pin(starting-pin)
    #link
    #pinit.pin(ending-pin)
    #pinit.pinit-point-from((starting-pin, ending-pin))[#tiaoma.qrcode(link.dest, width: 4em)]
  ]
  else { link }
}
**/

#let github-repo(repo) = link("https://github.com/" + repo, repo)

/*
#let chapter-slide(body) = focus-slide[
  #align(center + horizon, body)
]
*/
#let chapter-slide = _ => none

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

#let title-slide(
  config: (:),
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
  )
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }
  let body = {
    if info.logo != none {
      place(right, text(fill: self.colors.primary, info.logo))
    }
    std.align(
      center + horizon,
      {
        block(
          inset: 0em,
          breakable: false,
          {
            text(size: 2em, fill: self.colors.primary, strong(info.title))
            if info.subtitle != none {
              parbreak()
              text(size: 1.2em, fill: self.colors.primary, info.subtitle)
            }
          },
        )
        set text(size: .8em)
        grid(
          columns: (1fr,) * calc.min(info.authors.len(), 3),
          column-gutter: 1em,
          row-gutter: 1em,
          ..info.authors.map(author => text(fill: self.colors.neutral-darkest, author))
        )
        v(1em)
        if info.institution != none {
          parbreak()
          text(size: .9em, info.institution)
        }
        if info.date != none {
          parbreak()
          text(size: .8em, utils.display-info-date(self))
        }
      },
    )
    extra
  }
  touying-slide(self: self, body)
})