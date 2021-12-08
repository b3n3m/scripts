#!/bin/bash

echo "START renmaing: $(date +%Y-%m-%d_%H:%M:%S)" > rename.log
for f in *.HEIC; do 
name=`exiftool -s -s -s -P -'DateTimeOriginal' -d %Y%m%d_%H%M%S $f`

# if files already in place
i=1;while [[ -f "$name.HEIC" ]]; do
	name="${name}_${i}"
done

# rename
mv ${f} ${name}.HEIC
echo "rename $f to ${name}.HEIC" >> rename.log
if [[ -f ${f%.*}.MOV ]];then
	mv ${f%.*}.MOV ${name}.MOV
	echo "rename: ${f%.*}.MOV to ${name}.MOV" >> rename.log
else
	echo "${f%.*}.MOV - Not found" >> rename.log
fi

done
