# This is just an example to get you started. Users of your hybrid library will
# import this file by writing ``import mosqpkg/submodule``. Feel free to rename or
# remove this file altogether. You may create additional modules alongside
# this file as required.
import os
import httpClient
import md5

proc getSiteHash*(url: string): string =
  var client = newHttpClient()
  return client.getContent(url).getMD5()

proc hasUpdated*(url: string, updateInfoFileName: string = "update-info.dat"): bool =
  if not fileExists(updateInfoFileName):
    writeFile(updateInfoFileName, "")
  
  let oldHash = readFile(updateInfoFileName)
  let newHash = getSiteHash(url)
  if oldHash != newHash:
    # site has updated newer.
    writeFile(updateInfoFileName, newHash)    #NOTE: newHashは終了時に書き込まれるべき
    return true
  else:
    return false


