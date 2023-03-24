#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <iostream>
#include <string.h>

#define MAX_CONNECTIONS 10

int main()
{
    int server_fd, new_socket, max_sd, activity;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    fd_set readfds;
    char buffer[1025];
    int client_socket[MAX_CONNECTIONS] = {0};

    // Create a TCP socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
    {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    // Set the socket to be non-blocking
    if (fcntl(server_fd, F_SETFL, O_NONBLOCK) < 0)
    {
        perror("fcntl failed");
        exit(EXIT_FAILURE);
    }

    // Set up the address structure for the socket
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(8080);

    // Bind the socket to the specified address and port
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0)
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    // Set the socket to listen for incoming connections
    if (listen(server_fd, MAX_CONNECTIONS) < 0)
    {
        perror("listen failed");
        exit(EXIT_FAILURE);
    }

    while (true)
    {
        // Clear the file descriptor set
        FD_ZERO(&readfds);

        // Add the server socket to the file descriptor set
        FD_SET(server_fd, &readfds);
        max_sd = server_fd;

        // Add the active sockets to the file descriptor set
        for (int i = 0; i < MAX_CONNECTIONS; i++)
        {
            if (client_socket[i] > 0)
            {
                FD_SET(client_socket[i], &readfds);
            }

            if (client_socket[i] > max_sd)
            {
                max_sd = client_socket[i];
            }
        }

        // Wait for activity on any of the sockets
        activity = select(max_sd + 1, &readfds, NULL, NULL, NULL);

        if (activity < 0)
        {
            perror("select error");
            exit(EXIT_FAILURE);
        }

        // If there is activity on the server socket, it means a new connection is being made
        if (FD_ISSET(server_fd, &readfds))
        {
            if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t *)&addrlen)) < 0)
            {
                if (errno != EWOULDBLOCK && errno != EAGAIN)
                {
                    perror("accept failed");
                    exit(EXIT_FAILURE);
                }
            }
            else
            {
                // Add the new socket to the active socket list
                for (int i = 0; i < MAX_CONNECTIONS; i++)
                {
                    if (client_socket[i] == 0)
                    {
                        client_socket[i] = new_socket;
                        break;
                    }
                }
            }
        }
    }

    return 0;
}
