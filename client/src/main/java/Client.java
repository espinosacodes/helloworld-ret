import Demo.Response;
import java.util.Scanner;
import java.io.IOException;
import com.zeroc.Ice.Communicator;
import com.zeroc.Ice.Util;

public class Client
{
    public static void main(String[] args)
    {
        java.util.List<String> extraArgs = new java.util.ArrayList<>();

        try(Communicator communicator = Util.initialize(args,"config.client",extraArgs))
        {
            Response response = null;
            Demo.PrinterPrx service = Demo.PrinterPrx
                    .checkedCast(communicator.propertyToProxy("Printer.Proxy"));
            
            if(service == null)
            {
                throw new Error("Invalid proxy");
            }

            // Get username and hostname
            String username = System.getProperty("user.name"); //whoami
            String hostname = "unknown";
            try {
                hostname = java.net.InetAddress.getLocalHost().getHostName();
            } catch (IOException e) {
                System.err.println("Could not get hostname: " + e.getMessage());
            }

            Scanner scanner = new Scanner(System.in);
            String message;
            
            System.out.println("Client started. Enter messages (type 'exit' to quit):");
            System.out.println("Username: " + username + ", Hostname: " + hostname);
            
            while (true) {
                System.out.print("Enter message: ");
                message = scanner.nextLine().trim();
                
                if (message.equalsIgnoreCase("exit")) {
                    System.out.println("Exiting...");
                    break;
                }
                
                if (!message.isEmpty()) {
                    // Prefix message with username:hostname
                    String prefixedMessage = username + ":" + hostname + ":" + message;
                    
                    try {
                        response = service.printString(prefixedMessage);
                        System.out.println("Server response: " + response.value);
                        System.out.println("Response time: " + response.responseTime + " ms");
                    } catch (Exception e) {
                        System.err.println("Error communicating with server: " + e.getMessage());
                    }
                }
            }
            
            scanner.close();
        }
    }
}