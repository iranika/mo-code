# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest
import mosqpkg/[updateutils, utils4koma]

test "hasUpdated":
  let testUpdateInfoFile = "update-info.test.dat"
  writeFile(testUpdateInfoFile, "")
  doAssert updateutils.hasUpdated("http://momoirocode.web.fc2.com/mocode.html", testUpdateInfoFile) # "" != newHash, return true.
  doAssert not updateutils.hasUpdated("http://momoirocode.web.fc2.com/mocode.html", testUpdateInfoFile) # newHash = newHash, return false.

test "update4komaData":
  utils4koma.update4komaData()

test "download4komaImage":
  utils4koma.download4komaImage()
#]#
test "updateFeedAtom":
  utils4koma.updateFeedAtom()

test "replaceUrl4komaJs":
  utils4koma.replaceUrl4komaJs()
#]#