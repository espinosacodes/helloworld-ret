#!/bin/bash

# Performance Test Script for Hellworld-Ciclo-KBD
# This script measures response times for different types of requests

echo "Performance Test for Hellworld-Ciclo-KBD"
echo "========================================"

# Test different message types
echo "Testing Fibonacci calculation..."
time java -cp "client/build/classes/java/main:client/build/libs/*" Client << EOF
5
exit
EOF

echo -e "\nTesting listifs command..."
time java -cp "client/build/classes/java/main:client/build/libs/*" Client << EOF
listifs
exit
EOF

echo -e "\nTesting port scanning..."
time java -cp "client/build/classes/java/main:client/build/libs/*" Client << EOF
listports 127.0.0.1
exit
EOF

echo -e "\nTesting command execution..."
time java -cp "client/build/classes/java/main:client/build/libs/*" Client << EOF
!echo "Hello World"
exit
EOF

echo -e "\nPerformance test completed!"
