$URL = "https://album-api.wittysand-a096dd60.westeurope.azurecontainerapps.io/albums"
1..100 | ForEach-Object { Invoke-RestMethod -Uri $URL -Method Get;}
