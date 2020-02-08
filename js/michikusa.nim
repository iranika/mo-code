include karax / prelude

var lines: seq[kstring] = @[]

proc modal(): VNode =
  result = buildHtml(tdiv):
    text "return modal block"

proc rightSidebar(): VNode =
  result = buildHtml(tdiv):
    text "return Right var"

proc view(): VNode =
  result = buildHtml(tdiv):
    for x in lines:
      tdiv:
        text x
    button:
      text "続きを表示"
      proc onclick(ev: Event; n:VNode) =
        lines.add "Add image"

proc tfooter(): VNode =
  result = buildHtml(tdiv):
    text "return footer"

proc createDom(): VNode =
  result = buildHtml(tdiv):
    modal()
    rightSidebar()
    view()
    tfooter()


setRenderer createDom
