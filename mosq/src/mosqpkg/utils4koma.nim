import parseopt
import httpclient
import marshal
import htmlparser
import streams
import xmltree
import strutils, pegs, unicode
import os, times
import uri
import nimquery

# use get4komaUrl
type 
  PageData = object
    Title: string
    ImagesUrl: seq[string]

#const sqAgent = "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36"

proc writeJson4komaData*[T](stream: T, url: string) =
  var domain = parseUri(url)
  block uriPathClear:    
    domain.path = ""
    domain.query = ""
    domain.anchor = ""
  var client = newHttpClient()
  var res = client.get($(domain / "mocode.html"))
  let doc = res.body.newStringStream().parseHtml()
  let nodes = doc.querySelectorAll("li > a")
  var isFirstItem = true

  stream.write "pageData = [\n"
  for a in nodes:
    #li.child
    var titleName: string = $a.innerText
    var imagesUrl: seq[string]
    
    debugEcho $a.attr("href")
    res = client.get($(domain / a.attr("href")))
    let doc = res.body.newStringStream().parseHtml()
    let nodes = doc.querySelectorAll("img")

    for img in nodes:
      if (".jpg" in img.attr("src")) or (".png" in img.attr("src")):
        let image_url = $(domain / "4koma" / img.attr("src").replace("./", ""))
        imagesUrl.add(image_url)
        debugEcho $image_url
    if isFirstItem:
      stream.write $$PageData(Title: titleName, ImagesUrl: imagesUrl) & "\n"
      isFirstItem = false
    else:
      stream.write "," & $$PageData(Title: titleName, ImagesUrl: imagesUrl) & "\n"
  stream.write "]"

proc update4komaData*() =
  var fp: File = open("4komaData.js", FileMode.fmWrite)
  defer:
    close(fp)

  writeJson4komaData(fp, url="http://momoirocode.web.fc2.com")