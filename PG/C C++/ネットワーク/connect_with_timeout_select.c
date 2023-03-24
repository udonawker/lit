#include <iostream>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <sys/select.h>

int connect_with_timeout(int sockfd, struct sockaddr *addr, socklen_t addrlen, int timeout_secs) {
    // Set the socket to non-blocking mode
    int flags = fcntl(sockfd, F_GETFL, 0);
    if (flags == -1) {
        perror("fcntl");
        return -1;
    }
    if (fcntl(sockfd, F_SETFL, flags | O_NONBLOCK) == -1) {
        perror("fcntl");
        return -1;
    }

    // Attempt to connect to the server
    int connect_result = connect(sockfd, addr, addrlen);
    if (connect_result == 0) {
        // Connection was established immediately
        if (fcntl(sockfd, F_SETFL, flags) == -1) {
            perror("fcntl");
            return -1;
        }
        return 0;
    } else if (errno != EINPROGRESS) {
        // Error occurred while attempting to connect
        perror("connect");
        return -1;
    }

    // Wait for the connection to be established or timeout
    struct timeval tv;
    tv.tv_sec = timeout_secs;
    tv.tv_usec = 0;
    fd_set fdset;
    FD_ZERO(&fdset);
    FD_SET(sockfd, &fdset);
    int select_result = select(sockfd + 1, NULL, &fdset, NULL, &tv);
    if (select_result == -1) {
        perror("select");
        return -1;
    } else if (select_result == 0) {
        // Timeout occurred
        errno = ETIMEDOUT;
        return -1;
    }

    // Check if the connection was successful or not
    int connect_error;
    socklen_t error_len = sizeof(connect_error);
    if (getsockopt(sockfd, SOL_SOCKET, SO_ERROR, &connect_error, &error_len) == -1) {
        perror("getsockopt");
        return -1;
    }
    if (connect_error != 0) {
        errno = connect_error;
        return -1;
    }

    // Connection was established successfully
    if (fcntl(sockfd, F_SETFL, flags) == -1) {
        perror("fcntl");
        return -1;
    }
    return 0;
}
