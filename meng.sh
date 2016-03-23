#!/bin/bash

if [ $# -lt 1 ];then
    echo 'need arg'
fi

date=$1
y=`echo $date|cut -d '-' -f 1`
m=`echo $date|cut -d '-' -f 2`
d=`echo $date|cut -d '-' -f 3`
d1=`expr $d + 1`
echo $d1

rm -rf access.log.total.${date}
rm -rf access.log.baidu.${date}

for line in `cat ips`
do
    echo $line
    scp $line:/var/log/nginx/access.log ./access.log.origin.${date}.${line}
    sed -n '/'$d'\/'$m'\/'$y'/,/'${d1}'\/'${m}'\/'$y'/ p' access.log.origin.${date}.${line} >> access.log.total.${date}
done

grep 'm.baidu.com' access.log.total.${date} > access.log.baidu.${date}

goaccess -f access.log.total.${date} -a > report.total.${date}.html

goaccess -f access.log.baidu.${date} -a > report.baidu.${date}.html
