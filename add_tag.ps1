#tagの処理
sed "s@pageData = @@" 4komaData.js > 4komaData.json
$DATE=(date +%Y%m%d%H%M)
$TITLE=(Get-Content -Raw ./4komaData.json | ConvertFrom-Json).Title[-1]
git tag -a "$($DATE)" -m "$($TITLE)"
git push --tags

