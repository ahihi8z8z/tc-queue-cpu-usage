#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <arpa/inet.h> // inet_addr



// Define the target IP address and port number
#define TARGET_IP "10.0.0.2"
#define TARGET_PORT 1234

// Function to calculate the TCP checksum
unsigned short calculate_checksum(unsigned short *buffer, int size) {
    unsigned long sum = 0;
    while (size > 1) {
        sum += *buffer++;
        size -= 2;
    }
    if (size == 1) {
        sum += *(unsigned char *)buffer;
    }
    sum = (sum >> 16) + (sum & 0xFFFF);
    sum += (sum >> 16);
    return (unsigned short)(~sum);
}

// Function to add IP option timestamp
void add_timestamp_option(struct ip *ip_header) {
    // Customize the timestamp option here
    // In this example, we add a timestamp of 0x12345678
    uint32_t timestamp_value = 0x12345678;

    ip_header->ip_hl = 6;  // Set the IP header length to include the timestamp option
    ip_header->ip_tos = IPOPT_TS;
    ip_header->ip_len = htons(sizeof(struct ip) + 12); // Length of IP header + timestamp option
    ip_header->ip_off = 0;
    ip_header->ip_ttl = 64;
    ip_header->ip_p = IPPROTO_TCP;
    ip_header->ip_sum = 0;
    ip_header->ip_src.s_addr = inet_addr("192.168.1.100"); // Set your source IP
    ip_header->ip_dst.s_addr = inet_addr(TARGET_IP);

    // Set the timestamp option
    uint32_t *ts_option = (uint32_t *)(ip_header + 1);
    ts_option[0] = htonl(timestamp_value);
    ts_option[1] = htonl(0x0);  // Placeholder
}

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    char packet[1024];

    // Create a socket
    sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
    if (sockfd == -1) {
        perror("Socket creation failed");
        exit(1);
    }

    // Initialize the server address structure
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(TARGET_PORT);
    server_addr.sin_addr.s_addr = inet_addr(TARGET_IP);

    // Prepare the TCP packet
    struct ip *ip_header = (struct ip *)packet;
    struct tcphdr *tcp_header = (struct tcphdr *)(packet + sizeof(struct ip));
    memset(packet, 0, sizeof(packet));

    add_timestamp_option(ip_header);

    // Set the destination port
    tcp_header->th_dport = htons(TARGET_PORT);

    // Send the packet
    if (sendto(sockfd, packet, ntohs(ip_header->ip_len), 0, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("Sendto failed");
        close(sockfd);
        exit(1);
    }

    printf("TCP packet with timestamp option sent to %s:%d\n", TARGET_IP, TARGET_PORT);

    close(sockfd);

    return 0;
}
