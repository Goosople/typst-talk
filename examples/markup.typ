// page and font settings
#set page(height: auto, width: auto, margin: 1em)
#set text(font: ("IBM Plex Serif", "Source Han Serif", "Noto Serif CJK SC"), lang: "zh", region: "cn")
// a workaround for CJK italics
#show emph: set text(font: ("IBM Plex Serif", "LXGW WenKai", "AR PL UKai", "Source Han Serif", "Noto Serif CJK SC"))
#let skew(angle, vscale: 1, body) = {
  let (a, b, c, d) = (1, vscale * calc.tan(angle), 0, vscale)
  let E = (a + d) / 2
  let F = (a - d) / 2
  let G = (b + c) / 2
  let H = (c - b) / 2
  let Q = calc.sqrt(E * E + H * H)
  let R = calc.sqrt(F * F + G * G)
  let sx = Q + R
  let sy = Q - R
  let a1 = calc.atan2(F, G)
  let a2 = calc.atan2(E, H)
  let theta = (a2 - a1) / 2
  let phi = (a2 + a1) / 2
  
  set rotate(origin: bottom + center)
  set scale(origin: bottom + center)
  
  rotate(phi, scale(x: sx * 100%, y: sy * 100%, rotate(theta, body)))
}
#let fake-italic(body) = skew(-10deg, body)
#show emph: it => box(fake-italic(it))


= 一级标题

== 二级标题

简单的段落，可以*加粗*和_强调_。 // CJK has no italics


- 无序列表
+ 有序列表
/ 术语: 术语列表

```py
print('Hello Typst!')
```
