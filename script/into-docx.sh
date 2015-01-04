#!/bin/bash

languageDir=$1
userdocPath=$2

merge_files () {
	echo $3
	
}

userFiles=(
	'user/misc/resume.md'
	'user/misc/description.md'
	'user/misc/revision.md'
	'user/getting_started/introduction.md'
	'user/getting_started/clone.md'
	'user/core/module.md'
	'user/core/trigger.md'
	'user/core/javascript.md'
	'user/core/local.md'
	'user/core/error.md'
	'user/core/repository.md'
	'user/core/log.md'
	'user/core/form.md'
	'user/module/account.md'
	'user/module/faq.md'
	'user/module/fileupload.md'
	'user/module/mail.md'
	'user/module/market.md'
	'user/module/news.md'
	'user/module/notification.md'
	'user/module/survey.md'
	'user/module/wallet.md'
)

if [ ${languageDir: -1} != '/' ]; then
	languageDir=$languageDir'/'
fi

# Merge all file in one
for i in "${userFiles[@]}"
do
	fullpath=$languageDir$i
	if [ -f $fullpath ] && [ -r $fullpath ]; then
		cat $fullpath >> $userdocPath".md"
		echo -e "\n" >> $userdocPath".md"
	fi
done

pandoc --from markdown_github --to docx -o $userdocPath".docx" $userdocPath".md"