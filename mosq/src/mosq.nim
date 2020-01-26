# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import mosqpkg/updateutils

const mocode_url = "http://momoirocode.web.fc2.com/"

when isMainModule:
  if hasUpdated(mocode_url):
    update4komaData()
    download4komaImage()
    updateFeedAtom()    
  else:
    echo "No updates. " & mocode_url

