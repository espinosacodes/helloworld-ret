#!/bin/bash
# Run script for HelloWorld ICE Application

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}HelloWorld ICE Application${NC}"
echo "=================================="

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo -e "${RED}Error: Java is not installed or not in PATH${NC}"
    exit 1
fi

# Check if Ice JAR exists
ICE_JAR="/usr/share/java/ice-3.7.10.jar"
if [ ! -f "$ICE_JAR" ]; then
    echo -e "${RED}Error: Ice JAR not found at $ICE_JAR${NC}"
    echo "Please install ZeroC ICE or update the path in this script"
    exit 1
fi

# Function to start server
start_server() {
    echo -e "\n${YELLOW}Starting server...${NC}"
    cd server
    java -cp "build/libs/server.jar:$ICE_JAR:build/classes/java/main:build/generated-src" Server &
    SERVER_PID=$!
    echo "Server started with PID: $SERVER_PID"
    sleep 2
    cd ..
}

# Function to start client
start_client() {
    echo -e "\n${YELLOW}Starting client...${NC}"
    cd client
    java -cp "build/libs/client.jar:$ICE_JAR:build/classes/java/main:build/generated-src" Client
    cd ..
}

# Function to stop server
stop_server() {
    if [ ! -z "$SERVER_PID" ]; then
        echo -e "\n${YELLOW}Stopping server (PID: $SERVER_PID)...${NC}"
        kill $SERVER_PID 2>/dev/null
        echo "Server stopped"
    fi
}

# Check command line arguments
case "$1" in
    "server")
        start_server
        echo -e "${GREEN}Server is running. Press Ctrl+C to stop.${NC}"
        trap stop_server INT
        wait
        ;;
    "client")
        start_client
        ;;
    "both")
        start_server
        echo -e "${GREEN}Server started. Starting client in 3 seconds...${NC}"
        sleep 3
        start_client
        stop_server
        ;;
    *)
        echo "Usage: $0 {server|client|both}"
        echo ""
        echo "Options:"
        echo "  server  - Start only the server"
        echo "  client  - Start only the client (server must be running)"
        echo "  both    - Start server and then client"
        echo ""
        echo "Examples:"
        echo "  $0 server    # Start server in background"
        echo "  $0 client    # Start client (interactive)"
        echo "  $0 both      # Start both server and client"
        exit 1
        ;;
esac
