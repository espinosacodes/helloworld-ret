#!/bin/bash
# Performance Test Script for HelloWorld ICE Application

echo "=========================================="
echo "HelloWorld ICE Application Performance Test"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to run a test
run_test() {
    local test_name="$1"
    local message="$2"
    local expected_pattern="$3"
    
    echo -e "\n${YELLOW}Testing: $test_name${NC}"
    echo "Message: $message"
    
    # Start time
    start_time=$(date +%s%N)
    
    # Run the test
    result=$(echo -e "$message\nexit" | java -cp "client/build/libs/client.jar:/usr/share/java/ice-3.7.10.jar:client/build/classes/java/main:client/build/generated-src" Client 2>/dev/null)
    
    # End time
    end_time=$(date +%s%N)
    
    # Calculate duration in milliseconds
    duration=$(( (end_time - start_time) / 1000000 ))
    
    # Check if result contains expected pattern
    if echo "$result" | grep -q "$expected_pattern"; then
        echo -e "${GREEN}✓ Test passed${NC}"
        echo "Duration: ${duration}ms"
    else
        echo -e "${RED}✗ Test failed${NC}"
        echo "Result: $result"
    fi
    
    # Extract response time from result if available
    response_time=$(echo "$result" | grep "Response time:" | awk '{print $3}')
    if [ ! -z "$response_time" ]; then
        echo "Server response time: ${response_time}ms"
    fi
}

# Check if server is running
echo "Checking if server is running..."
if ! netstat -tlnp | grep -q ":9099"; then
    echo -e "${RED}Server is not running on port 9099${NC}"
    echo "Please start the server first:"
    echo "cd server && java -cp \"build/libs/server.jar:/usr/share/java/ice-3.7.10.jar:build/classes/java/main:build/generated-src\" Server"
    exit 1
fi

echo -e "${GREEN}Server is running${NC}"

# Test 1: Fibonacci calculation
run_test "Fibonacci and Prime Factors" "10" "Fibonacci series"

# Test 2: Network interfaces
run_test "Network Interfaces" "listifs" "Interface:"

# Test 3: Port scanning
run_test "Port Scanning" "listports 127.0.0.1" "Open ports for 127.0.0.1"

# Test 4: Command execution
run_test "Command Execution" "!whoami" "santiago"

# Test 5: Large Fibonacci number (stress test)
run_test "Large Fibonacci (Stress Test)" "20" "Fibonacci series"

# Test 6: Invalid input handling
run_test "Invalid Input" "invalid_message" "Error:"

echo -e "\n=========================================="
echo "Performance Test Summary"
echo "=========================================="
echo -e "${GREEN}All tests completed${NC}"
echo "Check the output above for individual test results and timing information."
echo ""
echo "Performance metrics to consider:"
echo "- Response time for each operation type"
echo "- Server processing time vs total round-trip time"
echo "- Error handling performance"
echo "- Resource usage during stress tests"
