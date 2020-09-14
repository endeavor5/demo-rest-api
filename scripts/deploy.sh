#!/bin/bash

REPOSITORY=/home/ec2-user/apps
DEPLOY_ZIP_DIR=/home/ec2-user/s3/zip/rest-api
PROJECT_NAME=rest-api

echo "> Build 파일 복사"

cp $DEPLOY_ZIP_DIR/*.jar $REPOSITORY

echo "> 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -fl $PROJECT_NAME | grep jar | awk '{print $1}')

echo "> 현재 구동 중인 애플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
   echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
   echo "> kill -15 $CURRENT_PID"
   kill -15 $CURRENT_PID
   sleep 5
fi

echo "> 새 애플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

rm $REPOSITORY/"$PROJECT_NAME_"nohup.out

nohup java -jar -Dspring.profiles.active=alpha -Dfile.encoding=UTF-8  $REPOSITORY/$JAR_NAME > $REPOSITORY/"$PROJECT_NAME_"nohup.out 2>&1 &
