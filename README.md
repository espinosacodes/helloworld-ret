# HelloWorld ICE Application

A distributed computing application built with ZeroC ICE (Internet Communications Engine) for academic purposes. This project demonstrates client-server communication using ICE middleware.

## Features

- Client-server communication using ZeroC ICE
- Fibonacci series calculation
- Network interface listing
- Port scanning capabilities
- Command execution
- Performance testing framework

## Prerequisites

- Java (JDK 8 or higher)
- Gradle
- ZeroC ICE

## Building the Project

```bash
cd /helloworld-ret && ./gradlew build
```

## Running the Application

### Start the Server

```bash
cd server && java -cp "build/libs/server.jar:build/classes/java/main:build/generated-src" Server
```

### Run the Client

```bash
cd client && java -cp "build/libs/client.jar:build/classes/java/main:build/generated-src" Client
```

### Performance Testing

To run performance quality attributes:

```bash
./run.sh both
```

In another shell, run the performance tests:

```bash
./performance_test.sh
```

## Project Structure

- `client/` - Client application
- `server/` - Server application
- `Printer.ice` - ICE interface definition
- `performance_test.sh` - Performance testing script
- `run.sh` - Application runner script

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Academic Use

This project is developed for academic purposes and demonstrates distributed computing concepts using ZeroC ICE middleware. 