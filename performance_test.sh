#!/bin/bash
# Performance Test Script for HelloWorld ICE Application
# 
# Configuration:
# - ICE_JAR can be set to override auto-discovery of ZeroC ICE jar
# - Script auto-discovers ICE jar from Gradle cache first, then system paths
# - All tests use case-insensitive pattern matching for robustness

set -euo pipefail

echo "=========================================="
echo "HelloWorld ICE Application Performance Test"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Global exit code tracker
test_exit_code=0

# Function to find ICE jar with robust fallback
find_ice_jar() {
    # Check if ICE_JAR is explicitly set
    if [ -n "${ICE_JAR:-}" ] && [ -f "$ICE_JAR" ]; then
        echo "$ICE_JAR"
        return 0
    fi

    # Search in common locations
    local jar=""
    local gradle_base="${GRADLE_USER_HOME:-$HOME/.gradle}/caches/modules-2/files-2.1/com.zeroc/ice"
    
    # Check Gradle cache first
    for candidate in "$gradle_base"/*/*/ice-*.jar; do
        if [ -f "$candidate" ]; then
            jar="$candidate"
            break
        fi
    done
    
    # Fallback to system paths
    if [ -z "$jar" ]; then
        for candidate in /usr/share/java/ice-*.jar /usr/local/share/java/ice-*.jar; do
            if [ -f "$candidate" ]; then
                jar="$candidate"
                break
            fi
        done
    fi

    if [ -n "$jar" ]; then
        echo "$jar"
    else
        echo "ERROR: ZeroC ICE jar not found. Set ICE_JAR environment variable to the jar location." >&2
        exit 1
    fi
}

# Discover ICE jar
ICE_JAR="$(find_ice_jar)"
echo "Using ICE JAR: $ICE_JAR"

# Set up classpath
CLIENT_CP="client/build/libs/client.jar:$ICE_JAR:client/build/classes/java/main:client/build/generated-src"

# Function to run client with a message
run_client() {
    local msg="$1"
    printf "%s\nexit\n" "$msg" | java -cp "$CLIENT_CP" Client 2>/dev/null
}

# Function to assert output matches expected pattern
assert_output() {
    local output="$1"
    local expected="$2"
    
    # Use case-insensitive extended regex matching
    echo "$output" | grep -qiE "$expected"
}

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
    result=$(run_client "$message")
    
    # End time
    end_time=$(date +%s%N)
    
    # Calculate duration in milliseconds
    duration=$(( (end_time - start_time) / 1000000 ))
    
    # Check if result matches expected pattern
    if assert_output "$result" "$expected_pattern"; then
        echo -e "${GREEN}✓ Test passed${NC}"
        echo "Duration: ${duration}ms"
    else
        echo -e "${RED}✗ Test failed${NC}"
        echo "Result: $result"
        test_exit_code=1
    fi
    
    # Extract response time from result if available
    response_time=$(echo "$result" | grep "Response time:" | awk '{print $3}' || true)
    if [ -n "$response_time" ]; then
        echo "Server response time: ${response_time}ms"
    fi
}

# Check if server is running
echo "Checking if server is running..."
if ! netstat -tlnp 2>/dev/null | grep -q ":9099"; then
    echo -e "${RED}Server is not running on port 9099${NC}"
    echo "Please start the server first:"
    echo "cd server && java -cp \"build/libs/server.jar:$ICE_JAR:build/classes/java/main:build/generated-src\" Server"
    exit 1
fi

echo -e "${GREEN}Server is running${NC}"

# Test 1: Fibonacci calculation
run_test "Fibonacci and Prime Factors" "10" "Fibonacci series"

# Test 2: Network interfaces
run_test "Network Interfaces" "listifs" "Interface:"

# Test 3: Port scanning
run_test "Port Scanning" "listports 127.0.0.1" "Open ports.*127\.0\.0\.1"

# Test 4: Command execution
run_test "Command Execution" "!whoami" "swarch"

# Test 5: Large Fibonacci number (stress test)
run_test "Large Fibonacci (Stress Test)" "20" "Fibonacci series"

# Test 6: Invalid input handling
run_test "Invalid Input" "invalid_message" "Error:"

echo -e "\n=========================================="
echo "Performance Test Summary"
echo "=========================================="
if [ $test_exit_code -eq 0 ]; then
    echo -e "${GREEN}All tests passed${NC}"
else
    echo -e "${RED}Some tests failed${NC}"
fi
echo "Check the output above for individual test results and timing information."
echo ""
echo "Performance metrics to consider:"
echo "- Response time for each operation type"
echo "- Server processing time vs total round-trip time"
echo "- Error handling performance"
echo "- Resource usage during stress tests"

exit $test_exit_code