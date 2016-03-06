if [ -d epub ]; then
	rm -r epub
fi
mkdir epub
for d in ~/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books/*.epub ; do
	#get the originl epub folder
	folder_path=$(echo $d | rev | cut -f 2- -d '.' | rev)
	folder_name=$(basename $folder_path)
	new_path="./epub/$folder_name"
	cp -r $d $new_path
	cd $new_path
	
	#find the opf file path
	opf_path=$(grep "rootfile " META-INF/container.xml | sed -nE 's/.* full-path="(.*)" .*/\1/p')
	
	#if not found, find the another way, without space for full-path
	if [ "$opf_path" == "" ]; then
		opf_path=$(grep "rootfile " META-INF/container.xml | sed -nE 's/.*full-path="(.*)".*/\1/p')	
	fi
	
	#if not found, put folder name only
	if [ "$opf_path" == "" ]; then
		trimmed=$folder_name
	else
		#find the title
		dc_title=$(grep "dc:title" $opf_path | sed -nE 's/\<dc:title\>(.*)\<\/dc:title\>/\1/p')
	
		#trim the tilte
		trimmed=`echo $dc_title`
	fi
	
	#make a zip file
	zip -r "$trimmed.epub" *
	mv "$trimmed.epub" ../
	
	#time for clean
	cd ..
	rm -r $folder_name
	cd .. 

done
echo "\n\nDone\n\n"