#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>

void handle_client(int client_socket) {
    char buffer[1024];
    ssize_t bytes_received;

    while (1) {
        bytes_received = recv(client_socket, buffer, sizeof(buffer), 0);

        if (bytes_received <= 0) {
            break;
        }

        // Process data here if needed.

        // Send ACK (acknowledgment) back to the client.
        struct tcphdr ack_packet;
        ack_packet.th_seq = htonl(0); // You may set the sequence number accordingly.
        ack_packet.th_ack = htonl(1); // You may set the acknowledgment number accordingly.
        ack_packet.th_off = 5;
        ack_packet.th_flags = TH_ACK;
        ack_packet.th_win = htons(65535);
        ack_packet.th_sum = 0;
        ack_packet.th_urp = 0;

        // Send the ACK packet.
        send(client_socket, &ack_packet, sizeof(ack_packet), 0);
    }

    // Send FIN/ACK (finish/acknowledgment) to gracefully terminate the connection.
    struct tcphdr fin_ack_packet;
    fin_ack_packet.th_seq = htonl(1); // You may set the sequence number accordingly.
    fin_ack_packet.th_ack = htonl(1); // You may set the acknowledgment number accordingly.
    fin_ack_packet.th_off = 5;
    fin_ack_packet.th_flags = TH_FIN | TH_ACK;
    fin_ack_packet.th_win = htons(65535);
    fin_ack_packet.th_sum = 0;
    fin_ack_packet.th_urp = 0;

    // Send the FIN/ACK packet.
    send(client_socket, &fin_ack_packet, sizeof(fin_ack_packet), 0);

    close(client_socket);
}

int main() {
    int server_socket, client_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);

    // Create a socket
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket < 0) {
        perror("Socket creation error");
        exit(1);
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(1234); // Choose the port you want to listen on.
    server_addr.sin_addr.s_addr = INADDR_ANY;

    // Bind the socket
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Socket bind error");
        exit(1);
    }

    // Listen for incoming connections
    if (listen(server_socket, 5) < 0) {
        perror("Listen error");
        exit(1);
    }

    printf("Server is listening...\n");

    while (1) {
        // Accept a connection
        client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &addr_len);
        if (client_socket < 0) {
            perror("Accept error");
            continue;
        }

        printf("Connection accepted from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));

        // Handle the client
        handle_client(client_socket);
    }

    close(server_socket);
    return 0;
}