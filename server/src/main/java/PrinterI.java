import Demo.Response;
import java.io.*;
import java.net.*;
import java.util.*;
import com.zeroc.Ice.Current;

public class PrinterI implements Demo.Printer
{
    public Response printString(String s, Current current)
    {
        long startTime = System.currentTimeMillis();
        String result = "";
        
        try {
            // Parse the message format: username:hostname:message
            String[] parts = s.split(":", 3);
            if (parts.length < 3) {
                result = "Error: Invalid message format. Expected username:hostname:message";
                System.out.println("Error: Invalid message format received: " + s);
            } else {
                String username = parts[0];
                String hostname = parts[1];
                String message = parts[2];
                
                System.out.println("[" + username + "@" + hostname + "] " + message);
                
                // Handle different message types
                if (message.startsWith("listifs")) {
                    result = handleListIfs();
                } else if (message.startsWith("listports")) {
                    String[] listportsParts = message.split("\\s+", 2);
                    if (listportsParts.length < 2) {
                        result = "Error: listports requires an IPv4 address";
                    } else {
                        result = handleListPorts(listportsParts[1]);
                    }
                } else if (message.startsWith("!")) {
                    String command = message.substring(1).trim();
                    result = handleCommandExecution(command);
                } else {
                    // Try to parse as positive integer for Fibonacci
                    try {
                        int n = Integer.parseInt(message.trim());
                        if (n > 0) {
                            result = handleFibonacci(n);
                        } else {
                            result = "Error: Number must be positive";
                        }
                    } catch (NumberFormatException e) {
                        result = "Error: Message must be a positive integer, listifs, listports <ip>, or !<command>";
                    }
                }
            }
        } catch (Exception e) {
            result = "Error processing message: " + e.getMessage();
            System.err.println("Error processing message: " + e.getMessage());
        }
        
        long endTime = System.currentTimeMillis();
        long responseTime = endTime - startTime;
        
        return new Response(responseTime, result);
    }
    
    private String handleFibonacci(int n) {
        System.out.println("Calculating Fibonacci series for n = " + n);
        StringBuilder series = new StringBuilder();
        StringBuilder factors = new StringBuilder();
        
        // Calculate Fibonacci series
        int a = 0, b = 1;
        series.append("Fibonacci series: ");
        for (int i = 0; i < n; i++) {
            series.append(a).append(" ");
            int temp = a + b;
            a = b;
            b = temp;
        }
        
        // Calculate prime factors of n
        factors.append("Prime factors of ").append(n).append(": ");
        List<Integer> primeFactors = getPrimeFactors(n);
        for (int i = 0; i < primeFactors.size(); i++) {
            factors.append(primeFactors.get(i));
            if (i < primeFactors.size() - 1) {
                factors.append(", ");
            }
        }
        
        System.out.println(series.toString());
        System.out.println(factors.toString());
        
        return series.toString() + "\n" + factors.toString();
    }
    
    private String handleListIfs() {
        System.out.println("Listing network interfaces");
        StringBuilder result = new StringBuilder();
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface ni = interfaces.nextElement();
                if (ni.isUp() && !ni.isLoopback()) {
                    result.append("Interface: ").append(ni.getDisplayName()).append("\n");
                    Enumeration<InetAddress> addresses = ni.getInetAddresses();
                    while (addresses.hasMoreElements()) {
                        InetAddress addr = addresses.nextElement();
                        result.append("  Address: ").append(addr.getHostAddress()).append("\n");
                    }
                }
            }
        } catch (Exception e) {
            result.append("Error listing interfaces: ").append(e.getMessage());
        }
        
        String resultStr = result.toString();
        System.out.println(resultStr);
        return resultStr;
    }
    
    private String handleListPorts(String ipAddress) {
        System.out.println("Scanning ports for IP: " + ipAddress);
        StringBuilder result = new StringBuilder();
        result.append("Open ports for ").append(ipAddress).append(":\n");
        
        // Common ports to scan
        int[] commonPorts = {21, 22, 23, 25, 53, 80, 110, 143, 443, 993, 995, 3306, 5432, 8080};
        
        for (int port : commonPorts) {
            try {
                Socket socket = new Socket();
                socket.connect(new InetSocketAddress(ipAddress, port), 1000);
                socket.close();
                result.append("Port ").append(port).append(" is open\n");
            } catch (Exception e) {
                // Port is closed or unreachable
            }
        }
        
        String resultStr = result.toString();
        System.out.println(resultStr);
        return resultStr;
    }
    
    private String handleCommandExecution(String command) {
        System.out.println("Executing command: " + command);
        StringBuilder result = new StringBuilder();
        
        try {
            Process process = Runtime.getRuntime().exec(command);
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            
            String line;
            while ((line = reader.readLine()) != null) {
                result.append(line).append("\n");
            }
            
            while ((line = errorReader.readLine()) != null) {
                result.append("ERROR: ").append(line).append("\n");
            }
            
            process.waitFor();
            result.append("Command completed with exit code: ").append(process.exitValue());
            
        } catch (Exception e) {
            result.append("Error executing command: ").append(e.getMessage());
        }
        
        String resultStr = result.toString();
        System.out.println(resultStr);
        return resultStr;
    }
    
    private List<Integer> getPrimeFactors(int n) {
        List<Integer> factors = new ArrayList<>();
        int d = 2;
        while (n > 1) {
            while (n % d == 0) {
                factors.add(d);
                n /= d;
            }
            d++;
            if (d * d > n) {
                if (n > 1) {
                    factors.add(n);
                }
                break;
            }
        }
        return factors;
    }
}