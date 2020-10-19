#!/bin/bash

mvn_docker() {
  mkdir -p _m2
  cp "${HOME}/.m2/settings.xml" _m2 || true
  docker run -ti \
    -v "$(pwd)/_m2:/root/.m2" \
    -v "$(pwd):/project" \
    amazoncorretto:11 \
    sh -c " cd /project; $1"
}
function run() {
  echo "run $1"
  #./mvnw clean compile -DskipTests=true
  mvn_docker "./mvnw clean compile -DskipTests=true"
  javap -c target/classes/com/example/Operation.class >target/classes/com/example/Operation.javap
  diff -r target/classes classes/
}

rm -rf classes
run 0
mv target/classes .
set -e

for ((i = 1; i < 150; i++)); do
  run $i
done
