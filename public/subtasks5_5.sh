#!/bin/bash

day_of_month=$(date +%e);
day_of_week=$(date +%u);

#Написать скрипт резервного копирования по расписанию следующим образом:
#В первый день месяца помещать копию в backdir/montlhy.
#Бэкап по пятницам хранить в каталоге backdir/weekley.
#В остальные дни сохранять копии в backdir/daily.
#Настроить ротацию следующим образом.
#Ежемесячные копии хранить 180 дней, ежедневные — неделю, еженедельные — 30 дней.
#Подсказка: для ротации используйте find.

#файл со списком директорий для архивации
backlist=~/tasks5/backup/backlist

#директория для архивов                                   
backdir=~/tasks5/backup/backdir

cd $backdir
#ротация.
for dir in daily weekly monthly
do
	case $dir in
	daily)
		days=7
		;;
	weekly)
		days=30
		;;
	monthly)
		days=180
		;;
	esac

	cd $backdir/$dir
	find . -mtime +$days -type f -name "*.backup.tar.gz" -exec rm -f {} \;
done

cd $backdir
#Backup
if [[ $day_of_month = 1 ]]
then
	cd monthly
fi

if [[ $day_of_week = 5 ]]
then
	cd weekly
else
	cd daily
fi

echo "$backlist"
cat  "$backlist"  | xargs find | xargs tar -oc |  gzip -9c > $(date +"%Y%m%d")backup.tar.gz
