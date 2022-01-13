#!/bin/bash

runDate=$(date +%Y-%m-%d_%H:%M:%S)
logFile=rename_$(date +%Y%m%d_%H%M%S).log
echo $PWD

while getopts lfcde opt; do
    case $opt in
        l) log="true"
        ;;
        f) fileType="SET"
        ;;
        c) optflag1="SET"
        ;;
        d) optflag2="SET"
        ;;
        e) optflag3="SET"
        ;;
    esac
done

arrFT=(HEIC JPG MOV PNG MP4)
echo "START renaming: $runDate" > $logFile

for i in "${arrFT[@]}"; do
	echo "Start ${i,,}" >> $logFile	

# convert extensions
	small=$(ls -l *.${i,,} 2>/dev/null | wc -l)
	if [[ $small -gt 0 ]]; then
		for f in *.${i,,}; do
			mv ${f} ${f%.*}.${i}
			echo "extension $f to ${f%.*}.${i}" >> $logFile
		done
	fi
countAll=$(ls -l *.${i} 2>/dev/null | wc -l)
count=0
if [[ countAll -gt 0 ]];then

	for f in *.${i}; do
# check for correct exif data
		if [[ ${i} == "MOV" ]];then
			name=`exiftool -s -s -s -P -'CreationDate' -d %Y%m%d_%H%M%S $f`		
		elif [[ ${i} == "MP4" ]]; then
			name=`exiftool -s -s -s -P -'CreateDate' -d %Y%m%d_%H%M%S $f`
		else
			name=`exiftool -s -s -s -P -'DateTimeOriginal' -d %Y%m%d_%H%M%S $f`
		fi
# if exif data not found	
		if [[ -z $name ]]; then 
			name="failure_${f%.*}" 
		fi
		
# if files already in place
		j=1; while [[ -f "$name.${j}" ]]; do
			name="${name}_${j}"
		done

# rename Picture
		mv ${f} ${name}.${i} 2>/dev/null
		echo "rename $f to ${name}.${i}" >> $logFile
	
# rename Live Picture
		if [[ $i -eq "HEIC" && -f ${f%.*}.MOV ]];then
			mv ${f%.*}.MOV ${name}.MOV 2>/dev/null
			echo "rename: ${f%.*}.MOV to ${name}.MOV" >> $logFile
		else
			echo "${f%.*}.MOV - Not found" >> $logFile
		fi
		(( count++ ))
		echo -ne "${i}: $count / $countAll \r"
	done
fi
echo "${i}: $count / $countAll"
done

echo "END renaming: $(date +%Y-%m-%d_%H:%M:%S)" >> $logFile
