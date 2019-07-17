
#feed.atomの読み込み
sed "s@pageData = @@" 4komaData.js > 4komaData.json

$feed = Get-Content -Raw ./feed.atom
$title = (date +%Y%m%d%H%M)
$update = (date +%Y-%m-%dT%T%:z)
$content = (Get-Content -Raw ./4komaData.json | ConvertFrom-Json).Title[-1]
$auther = "iranika"
$entry_url = "https://iranika.github.io/mo-code/#latest"

$new_entry = @"
<!--insertEntry-->
<entry>
  <id>tag:iranika.github.io,2019:Repository/194400309/$($title)</id>
  <updated>$($update)</updated>
  <link rel="alternate" type="text/html" href="$($entry_url)"/>
  <title>$($title)</title>
  <content type="html">$($content)</content>
  <author>
    <name>$($auther)</name>
  </author>
</entry>
"@

[xml]$xml = ($feed -replace "<!--insertEntry-->", $new_entry)
$xml.feed.updated = $xml.feed.entry[0].updated
$xml.Save("feed.atom")
#$feed_xml | Out-File ./feed.atom