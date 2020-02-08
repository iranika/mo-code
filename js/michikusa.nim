include karax / prelude
import strutils

var lines: seq[kstring] = @[]
var x = 0

proc modal(): VNode =
  result = buildHtml(tdiv):
    text "return modal block"

proc rightSidebar(): VNode =
  result = buildHtml(tdiv):
    text "return Right var"

proc view(): VNode =
  result = buildHtml(tdiv):
    tdiv:
      text x.intToStr
    button:
      text "続きを表示"
      proc onclick(ev: Event; n:VNode) =
        x += 1
        #lines.add "Add image"

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
