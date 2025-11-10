# Simulate GitHub Actions build process

Write-Host "Cleaning previous build..."
Remove-Item -Path "./publish" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "*.zip" -Force -ErrorAction SilentlyContinue

Write-Host "Restoring dependencies..."
dotnet restore --runtime win-x64

Write-Host "Building..."
dotnet build --configuration Release --no-restore

Write-Host "Publishing..."
dotnet publish --configuration Release --runtime win-x64 --no-build --output ./publish

Write-Host ""
Write-Host "Listing publish output:"
Get-ChildItem -Path ./publish

Write-Host ""
Write-Host "Creating zip..."
$version = Select-String -Path "DragonDen.ModManager.csproj" -Pattern '<Version>(.*?)</Version>' | ForEach-Object { $_.Matches.Groups[1].Value }
$artifactName = "DragonDen-ModManager-v$version-win-x64"
Compress-Archive -Path "./publish/*" -DestinationPath "./$artifactName.zip" -Force

Write-Host ""
Write-Host "Done! Check ./publish directory and $artifactName.zip"
Write-Host "Native DLLs should be present in ./publish/"
