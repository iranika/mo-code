import httpclient
import htmlparser
import streams
import xmltree
import pegs, unicode
import os, times
import uri
import nimquery
import json, marshal
import nre,options,strutils
import threadpool
{.experimental: "parallel".}

# use get4komaUrl
type 
  PageData = object
    Title: string
    ImagesUrl: seq[string]

const file4komaData = "4komaData.js"
#const sqAgent = "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36"

proc writeJson4komaData*[T](stream: T, url: string) =
  var domain = parseUri(url)
  block uriPathClear:    
    domain.path = ""
    domain.query = ""
    domain.anchor = ""
  var client = newHttpClient()
  var res = client.get($(domain / "mocode.html"))
  let nodes = res.body.newStringStream().parseHtml().querySelectorAll("li > a")
  var isFirstItem = true

  stream.write "pageData = [\n"
  for a in nodes:
    #li.child
    var titleName: string = $a.innerText
    var imagesUrl: seq[string]
    
    debugEcho $a.attr("href")
    res = client.get($(domain / a.attr("href")))
    let nodes = res.body.newStringStream().parseHtml().querySelectorAll("img")

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
  var fp: File = open(file4komaData, FileMode.fmWrite)
  defer:
    close(fp)
  writeJson4komaData(fp, url="http://momoirocode.web.fc2.com")
  
proc download4komaImage*() =
  if not existsDir("4koma"):
    createDir("4koma")
  let jsonNode4koma = readFile(file4komaData).replace("pageData = ", "").parseJson
  let list4koma: seq[PageData] = to(jsonNode4koma, seq[PageData])
  for index,item in list4koma:
    parallel:
      for imgUrl in item.ImagesUrl:
        let saveFilename = imgUrl.replace(re".*4koma","4koma") # save 4koma/filename
        if existsFile(saveFilename) and index + 1 < list4koma.len : #skip other than last index.
          debugEcho "skiped save: " & saveFilename
          continue #skip download
        var hc = newHttpClient()
        spawn hc.downloadFile(imgUrl, saveFilename)
        debugEcho "saved file: " & saveFilename

proc updateFeedAtom*() =
  return