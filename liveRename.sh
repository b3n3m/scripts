#!/bin/bash

runDate=$(date +%Y-%m-%d_%H:%M:%S)
logFile=rename_$(date +%Y%m%d_%H%M%S).log
echo $PWD
ls -l | wc -l
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

echo "START renaming: $runDate" > $logFile
countAll=`ls -l *.HEIC | wc -l 2>/dev/null`
count=1
for f in *.HEIC; do 

		
	name=`exiftool -s -s -s -P -'DateTimeOriginal' -d %Y%m%d_%H%M%S $f`

# if files already in place
	i=1; while [[ -f "$name.HEIC" ]]; do
		name="${name}_${i}"
	done

# rename
	mv ${f} ${name}.HEIC
	echo "rename $f to ${name}.HEIC" >> $logFile
	if [[ -f ${f%.*}.MOV ]];then
		mv ${f%.*}.MOV ${name}.MOV 2>/dev/null
		echo "rename: ${f%.*}.MOV to ${name}.MOV" >> $logFile
	else
		echo "${f%.*}.MOV - Not found" >> $logFile
	fi

echo -ne "HEIC: $count / $countAll \r"
(( count++ ))
done

# rename JPG
countAll=`ls -l *.JPG | wc -l 2>/dev/null`
count=1
for f in *.JPG; do
	name=`exiftool -s -s -s -P -'DateTimeOriginal' -d %Y%m%d_%H%M%S $f`

# if files already in place
	i=1; while [[ -f "$name.JPG" ]]; do
		name="${name}_${i}"
	done

	mv $f $name.JPG
	echo "rename $f to ${name}.JPG" >> $logFile

echo -ne "MOV: $count / $countAll \r"
(( count++ ))
done

# rename MOV
countAll=`ls -l *.MOV | wc -l 2>/dev/null`
count=1
for f in *.MOV; do
	name=`exiftool -s -s -s -P -'CreationDate' -d %Y%m%d_%H%M%S $f`

	mv $f $name.MOV
	echo "rename: ${f%.*}.MOV to ${name}.MOV" >> $logFile

echo -ne "MOV: $count / $countAll \r"
(( count++ ))
done


# rename MP4
countAll=`ls -l *.MP4 | wc -l 2>/dev/null`
count=1
for f in *.MP4; do
	name=`exiftool -s -s -s -P -'CreationDate' -d %Y%m%d_%H%M%S $f`

	mv $f $name.MP4
	echo "rename: ${f%.*}.MP4 to ${name}.MP4" >> $logFile

echo -ne "MP4: $count / $countAll \r"
(( count++ ))
done

echo "END renaming: $(date +%Y-%m-%d_%H:%M:%S)" >> $logFile
