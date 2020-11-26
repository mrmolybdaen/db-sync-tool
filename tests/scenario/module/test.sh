#!/bin/sh

#
# Sync mode: PROXY
#

echo "\033[94m[INFO]\033[m Testing module"
echo "\033[94m[INFO]\033[m \033[90mSync: WWW1 -> WWW2, Initiator: WWW2\033[m"
docker-compose exec www2 pip3 install -e . > /dev/null
docker-compose exec www2 python3 /var/www/html/tests/scenario/module/test.py
# Expecting 3 results in the database
count=$(docker-compose exec db2 mysql -udb -pdb db -e 'SELECT COUNT(*) FROM person' | grep 3 | tr -d '[:space:]')
if [[ $count == '|3|' ]]; then
    echo "\033[92m[SUCCESS]\033[m Synchronisation succeeded"
else
    echo "\033[91m[FAILURE]\033[m Synchronisation was not successful"
    echo "\033[90m#############################################\033[m"
    exit 1
fi
sh helper/cleanup.sh
echo "\033[90m#############################################\033[m"