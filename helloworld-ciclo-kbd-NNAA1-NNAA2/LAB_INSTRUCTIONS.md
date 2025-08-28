# Lab Instructions - Hellworld-Ciclo-KBD

## Prerequisites
- Java 8 or higher installed
- Gradle installed
- Ice framework installed
- Network access between lab machines

## Step-by-Step Instructions

### 1. Environment Setup
1. Each student creates a subdirectory with their name
2. Copy the helloworld-ciclo-kbd-NNAA1-NNAA2 folder to your subdirectory
3. Update configuration files with unique ports (avoid conflicts with other pairs)

### 2. Configuration
1. **Server Configuration** (`server/src/main/resources/config.server`):
   - Update `Printer.Endpoints=tcp -p <YOUR_PORT>`
   - Update `Ice.Default.Host=<YOUR_MACHINE_HOSTNAME>`

2. **Client Configuration** (`client/src/main/resources/config.client`):
   - Update `Printer.Proxy=SimplePrinter:tcp -p <YOUR_PORT>`
   - Update `Ice.Default.Host=<SERVER_MACHINE_HOSTNAME>`

### 3. Compilation
```bash
cd helloworld-ciclo-kbd-NNAA1-NNAA2
./gradlew build
```

### 4. Testing Procedure

#### Phase 1: Single Client Test
1. Start the server on Machine 1:
   ```bash
   cd server
   ./gradlew run
   ```

2. Start the client on Machine 2:
   ```bash
   cd client
   ./gradlew run
   ```

3. Test all message types:
   - Enter a positive integer (e.g., `5`)
   - Enter `listifs`
   - Enter `listports 127.0.0.1`
   - Enter `!ls -la`
   - Enter `exit`

#### Phase 2: Multiple Clients Test
1. Keep the server running on Machine 1
2. Start client on Machine 2
3. Start client on Machine 3
4. Send messages simultaneously from both clients
5. Observe server behavior and response times

### 5. Performance Measurement
1. Run the performance test script:
   ```bash
   ./performance_test.sh
   ```

2. Record response times for different operations
3. Test with multiple concurrent clients
4. Document any performance degradation

### 6. Expected Results

#### Server Output Example:
```
[student1@machine2] 5
Calculating Fibonacci series for n = 5
Fibonacci series: 0 1 1 2 3
Prime factors of 5: 5

[student2@machine3] listifs
Listing network interfaces
Interface: eth0
  Address: 192.168.1.100
```

#### Client Output Example:
```
Client started. Enter messages (type 'exit' to quit):
Username: student1, Hostname: machine2
Enter message: 5
Server response: Fibonacci series: 0 1 1 2 3
Prime factors of 5: 5
Response time: 15 ms
```

### 7. Troubleshooting

#### Common Issues:
1. **Connection Refused**: Check if server is running and port is correct
2. **Hostname Resolution**: Update config files with correct hostnames
3. **Port Conflicts**: Use different ports for each pair
4. **Permission Denied**: Ensure proper file permissions

#### Debug Steps:
1. Check server logs for errors
2. Verify network connectivity between machines
3. Test with `telnet <hostname> <port>`
4. Check firewall settings

### 8. Submission Requirements
1. Create zip file: `helloworld-ciclo-kbd-NNAA1-NNAA2.zip`
2. Include all source code and configuration files
3. Include performance measurement results
4. Include lab report with observations

### 9. Lab Report Template
```
Lab Report - Hellworld-Ciclo-KBD
================================

Students: NNAA1, NNAA2
Date: [Date]

1. Environment Setup
   - Machines used: [List machines]
   - Ports used: [List ports]
   - Configuration changes: [Describe changes]

2. Testing Results
   - Single client performance: [Results]
   - Multiple clients performance: [Results]
   - Response times: [Data]

3. Observations
   - Server behavior with multiple clients: [Observations]
   - Performance characteristics: [Analysis]
   - Any issues encountered: [Issues and solutions]

4. Conclusions
   - [Summary of findings]
   - [Performance insights]
   - [Recommendations]
```

## Safety Notes
- Be careful with command execution (`!` commands)
- Don't execute dangerous commands
- Respect network policies
- Don't scan unauthorized systems
