$zip_folder = mkdir ("build" + " " +($(get-date -f MM-dd-yyyy-HH-mm-ss)))
Move-Item -Path "dist/**" -Destination $zip_folder
Compress-Archive -Path $zip_folder -DestinationPath $zip_folder
jf rt u "build*.zip" generic-local
