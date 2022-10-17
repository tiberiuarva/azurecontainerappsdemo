$URL = "album-ui.politehill-a6f8d04d.westeurope.azurecontainerapps.io"
1..50 | ForEach-Object { Invoke-RestMethod -Uri $URL -Method Get;}
