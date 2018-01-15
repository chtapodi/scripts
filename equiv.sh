#!/bin/bash
#CONFIGS atrium is on the device, vault is external
atrium=~/atrium/
vault=~/movies/

atriumPercent=$(df $atrium | awk '{$2=$2};1' | grep  "/" |cut -d ' ' -f 5 | cut -d % -f 1)
vaultPercent=$(df $vault | awk '{$2=$2};1' | grep  "/" |cut -d ' ' -f 5 | cut -d % -f 1)

diff=$(echo $(($atriumPercent-$vaultPercent)) | cut -d '-' -f 2)

echo $atriumPercent
echo $vaultPercent
echo $diff

while (($diff > 5))
do
	if (($atriumPercent > $vaultPercent))
	then
		echo "oldest"
		select=$(find $atrium -maxdepth 1 -printf '%T+ %p\n' | sort | tail -q |head -n 1 | cut -d ' ' -f 2-) #finds the oldest file in atrium
		destination=$vault
	else
		echo "newest"
		select=$(find $vault -maxdepth 1 -printf '%T+ %p\n' | sort -r | tail -q |head -n 1 | cut -d ' ' -f 2-) #find the newest file in vault
		destination=$atrium
	fi
	echo $select
	mv "$select" $destination
	echo "moved"
	atriumPercent=$(df $atrium | awk '{$2=$2};1' | grep  "/" |cut -d ' ' -f 5 | cut -d % -f 1)
	vaultPercent=$(df $vault | awk '{$2=$2};1' | grep  "/" |cut -d ' ' -f 5 | cut -d % -f 1)
	diff=$(echo $(($atriumPercent-$vaultPercent)) | cut -d '-' -f 2)
	echo $atriumPercent
	echo $vaultPercent
	echo $diff

done
