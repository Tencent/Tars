#!/bin/sh

if [ $# -lt 3 ]
then
	echo "<Usage:  $0  App  Server  Servant>"
	exit 0
fi

APP=$1
SERVER=$2
SERVANT=$3

if [ "$SERVER" = "$SERVANT" ]
then
	echo "Error!(ServerName == ServantName)"
	exit -1
fi

if [ ! -d $APP/$SERVER ]
then
	echo "[mkdir: $APP/$SERVER]"
	mkdir -p $APP/$SERVER
fi

echo "[create server: $APP.$SERVER ...]"

DEMO_PATH=/usr/local/tars/cpp/script/demo

cp $DEMO_PATH/* $APP/$SERVER/

cd $APP/$SERVER/

SRC_FILE="DemoServer.h DemoServer.cpp DemoServantImp.h DemoServantImp.cpp DemoServant.tars makefile"

for FILE in $SRC_FILE
do
	cat $FILE | sed "s/DemoServer/$SERVER/g" > $FILE.tmp
	mv $FILE.tmp $FILE

	cat $FILE | sed "s/DemoApp/$APP/g" > $FILE.tmp
	mv $FILE.tmp $FILE
	
	cat $FILE | sed "s/DemoServant/$SERVANT/g" > $FILE.tmp
	mv $FILE.tmp $FILE
done

OS_NAME=$(cat /etc/os-release | grep '^NAME=' | sed 's/NAME="//' | sed 's/ .*$//')

if [ "$OS_NAME" != "CentOS" ];
then
        rename "s/DemoServer/$SERVER/" $SRC_FILE
        rename "s/DemoServant/$SERVANT/" $SRC_FILE
else
        rename "DemoServer" "$SERVER" $SRC_FILE
        rename "DemoServant" "$SERVANT" $SRC_FILE
fi

cd ../../

echo "[done.]"
