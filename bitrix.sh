#!/bin/bash

FILE=./phones_pikabu.txt

lc=$(wc -l "$FILE" | grep -Eo '[0-9]+')


while true 
do
	# get a random number between 1 and $lc
	rnd=$RANDOM
	let "rnd %= $lc"
	((rnd++))

	# traverse file and find line number $rnd
	i=0
	while read -r line; do
 	((i++))
 	[ $i -eq $rnd ] && break
	done < $FILE

	PHONE="$line"
	NAME=$(sort -R names.txt | head -n 1)

	

	if [ "$1" == "test" ]; then
		echo "$NAME - $PHONE"
		curl -i -XPOST --data "values={\"LEAD_NAME\":[\"vvp\"],\"LEAD_PHONE\":[\"+7 (800) 533-48-26\"]}&consents={\"AGREEMENT_2\":\"Y\"}&recaptcha=undefined&timeZoneOffset=-120&id=60&trace={}&sec=gczezk" https://profav.bitrix24.ru/bitrix/services/main/ajax.php?action=crm.site.form.fill
		exit 0;
	fi

	curl -s -XPOST --data "values={\"LEAD_NAME\":[\"$NAME\"],\"LEAD_PHONE\":[\"$PHONE\"]}&consents={\"AGREEMENT_2\":\"Y\"}&recaptcha=undefined&timeZoneOffset=-120&id=60&trace={}&sec=gczezk" https://profav.bitrix24.ru/bitrix/services/main/ajax.php?action=crm.site.form.fill > /dev/null
	
	sleep 1
done

