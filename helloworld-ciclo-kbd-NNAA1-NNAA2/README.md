# Hellworld-Ciclo-KBD Lab Exercise

## Overview
This is a modified version of the helloworld Ice application that implements a client-server communication system with enhanced functionality.

## Features
- **Interactive Client**: The client now requests messages through console input in a loop
- **Message Prefixing**: All messages are prefixed with username:hostname format
- **Multiple Message Types**:
  - **Positive Integer**: Calculates Fibonacci series and prime factors
  - **listifs**: Lists network interfaces
  - **listports <ip>**: Scans common ports on the specified IP address
  - **!<command>**: Executes system commands
- **Exit Command**: Type "exit" to quit the client

## Configuration
- **Server Port**: 9100 (modified from original 9099)
- **Client Configuration**: Updated to connect to port 9100

## Usage Instructions

### 1. Compilation
```bash
# Compile the project
./gradlew build
```

### 2. Running the Server
```bash
# Start the server on one machine
cd server
./gradlew run
```

### 3. Running the Client
```bash
# Start the client on other machines
cd client
./gradlew run
```

### 4. Example Commands
- `5` - Calculate Fibonacci series for 5 and prime factors
- `listifs` - List network interfaces
- `listports 192.168.1.1` - Scan ports on IP address
- `!ls -la` - Execute system command
- `exit` - Quit the client

## Lab Requirements
1. Each pair should use different ports to avoid conflicts
2. Students must create subdirectories with their names
3. Test with multiple clients sending messages simultaneously
4. Measure performance quality attributes

## File Structure
```
helloworld-ciclo-kbd-NNAA1-NNAA2/
├── Printer.ice          # Ice interface definition
├── client/              # Client implementation
├── server/              # Server implementation
├── build.gradle         # Build configuration
└── README.md           # This file
```

## Performance Measurement
The server returns response times for each request, which can be used to measure performance quality attributes.

## Notes
- Make sure to update the hostname in config files for your specific lab environment
- Each pair should use unique ports to avoid conflicts
- The server handles multiple concurrent clients
