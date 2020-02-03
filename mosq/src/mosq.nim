# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import mosqpkg/[updateutils,utils4koma]

const mocode_url = "http://momoirocode.web.fc2.com/mocode.html"

when isMainModule:
  if hasUpdated(mocode_url):
    update4komaData()
    download4komaImage()
    updateFeedAtom()
    replaceUrl4komaJs()
  else:
    echo "No updates. " & mocode_url

