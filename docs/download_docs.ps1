$sitemapFile = "c:\laragon\www\selbsthilfegruppen-deutschland.de\.docs\sitemap.xml"
$docsDir = "c:\laragon\www\selbsthilfegruppen-deutschland.de\docs"
$xml = [xml](Get-Content -Path $sitemapFile -Raw)
$urls = @($xml.urlset.url.loc)

Write-Host "Starte Download von $($urls.Count) Seiten..."

foreach ($url in $urls) {
    try {
        $fileName = $url -replace 'https://redaxo.org/doku/main/?', ''
        if ([string]::IsNullOrEmpty($fileName)) {
            $fileName = 'index'
        }
        $fileName = $fileName -replace '/', '_'
        $filePath = Join-Path $docsDir "$fileName.md"
        
        Write-Host "Lade: $url -> $fileName.md"
        
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        $html = $response.Content
        
        # Extrahiere article.docs Inhalt
        if ($html -match '(?s)<article[^>]*class="[^"]*docs[^"]*"[^>]*>(.*?)</article>') {
            $articleContent = $matches[1]
            
            # Einfache HTML zu Markdown Konvertierung
            $markdown = $articleContent `
                -replace '(?s)<script[^>]*>.*?</script>', '' `
                -replace '(?s)<style[^>]*>.*?</style>', '' `
                -replace '<h1[^>]*>', "`n# " `
                -replace '<h2[^>]*>', "`n## " `
                -replace '<h3[^>]*>', "`n### " `
                -replace '<h4[^>]*>', "`n#### " `
                -replace '<h5[^>]*>', "`n##### " `
                -replace '<h6[^>]*>', "`n###### " `
                -replace '</h[1-6]>', "`n" `
                -replace '<p[^>]*>', "`n" `
                -replace '</p>', "`n" `
                -replace '<br\s*/?>', "`n" `
                -replace '<strong[^>]*>|</strong>', '**' `
                -replace '<b[^>]*>|</b>', '**' `
                -replace '<em[^>]*>|</em>', '*' `
                -replace '<i[^>]*>|</i>', '*' `
                -replace '<code[^>]*>|</code>', '`' `
                -replace '<pre[^>]*>', "`n````n" `
                -replace '</pre>', "`n````n" `
                -replace '<ul[^>]*>', "`n" `
                -replace '</ul>', "`n" `
                -replace '<ol[^>]*>', "`n" `
                -replace '</ol>', "`n" `
                -replace '<li[^>]*>', "- " `
                -replace '</li>', "`n" `
                -replace '<a\s+[^>]*href="([^"]*)"[^>]*>(.*?)</a>', '[$2]($1)' `
                -replace '<img[^>]*src="([^"]*)"[^>]*alt="([^"]*)"[^>]*>', '![$2]($1)' `
                -replace '<img[^>]*src="([^"]*)"[^>]*>', '![]($1)' `
                -replace '(?s)<[^>]+>', '' `
                -replace '&nbsp;', ' ' `
                -replace '&amp;', '&' `
                -replace '&lt;', '<' `
                -replace '&gt;', '>' `
                -replace '&quot;', '"' `
                -replace '\n\s*\n\s*\n+', "`n`n"
            
            $markdown = "# $fileName`n`nQuelle: $url`n`n" + $markdown.Trim()
            
            $markdown | Out-File -FilePath $filePath -Encoding UTF8
            Write-Host "Gespeichert: $filePath" -ForegroundColor Green
        } else {
            Write-Host "Warnung: Kein article.docs gefunden in $url" -ForegroundColor Yellow
        }
        
        Start-Sleep -Milliseconds 500
    }
    catch {
        Write-Host "Fehler bei $url : $_" -ForegroundColor Red
    }
}

Write-Host "`nFertig! Alle Seiten wurden heruntergeladen."
