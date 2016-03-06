if [ -d epub ]; then
	rmdir epub
fi
mkdir epub
for d in ~/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books/*.epub ; do
	folder_path=$(echo $d | rev | cut -f 2- -d '.' | rev)
	folder_name=$(basename $folder_path)
	new_path="./epub/$folder_name"
	cp -r $d $new_path
	cd $new_path
	zip -r "$folder_name.epub" *
	mv "$folder_name.epub" ../
	cd ..
	rm -r $folder_name
	cd .. 
done
echo "\n\nDone\n\n"