#import "@preview/octique:0.1.1": *
#import "@preview/metalogo:1.2.0"
#import "@preview/touying:0.6.1": themes.university.focus-slide

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