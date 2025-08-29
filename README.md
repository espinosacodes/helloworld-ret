

cd /helloworld-ret && ./gradlew build

cd server && java -cp "build/libs/server.jar:build/classes/java/main:build/generated-src" Server

cd client && java -cp "build/libs/client.jar:build/classes/java/main:build/generated-src" Client


then to run performance quality attributes

./run.sh both

in other shell 

./performance_test.sh 