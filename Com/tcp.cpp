#include <stdio.h>
#include <stdlib.h> // exit()
#include <string.h> // memset()
#include <arpa/inet.h> // inet_pton()
#include <sys/socket.h>
#include <iostream>
#include <fstream>
#include <string>

#define SERVER_PORT 8888
#define SERVER_IP "192.168.56.102"
#define MAX_CONNECTION 10
#define MAX_MSG_LEN 4096


using namespace std;

float var = 65.0;

string convertToString(char* a, int size)
{
    int i;
    string s = "";
    for (i = 0; i < size; i++) {
        s = s + a[i];
    }
    return s;
}

int main()
{
    struct sockaddr_in server =
    {
        .sin_family = AF_INET,
        .sin_port = htons( SERVER_PORT )
    };
    if( inet_pton( AF_INET, SERVER_IP, & server.sin_addr ) <= 0 )
    {
        perror( "inet_pton() ERROR" );
        exit( 1 );
    }
   
    const int socket_ = socket( AF_INET, SOCK_STREAM, 0 );
    if(( socket_ ) < 0 )
    {
        perror( "socket() ERROR" );
        exit( 2 );
    }
   
    char buffer[ 4096 ] = { };
   
    socklen_t len = sizeof( server );
    if( bind( socket_,( struct sockaddr * ) & server, len ) < 0 )
    {
        perror( "bind() ERROR" );
        exit( 3 );
    }
   
    if( listen( socket_, MAX_CONNECTION ) < 0 )
    {
        perror( "listen() ERROR" );
        exit( 4 );
    }

    struct sockaddr_in client = { };
    
    string sUDPRetVal = "0";
    int UDPRetVal = 0;
       
    memset( buffer, 0, sizeof( buffer ) );
       
   /* printf( "Waiting for connection...\n" );
    if( recv( clientSocket, buffer, sizeof( buffer ), 0 ) <= 0 )
    {
             perror( "recvfrom() ERROR" );
             exit( 4 );
    
    }*/
        //printf( "|Message from client|: %s \n", buffer );
        while( 1 )
        {   
            const int clientSocket = accept( socket_,( struct sockaddr * ) & client, & len );
            if( clientSocket < 0 )
                {
                    perror( "accept() ERROR" );
                }
            //char buffer_ip[ 128 ] = { };
            //printf( "|Client ip: %s port: %d|\n", inet_ntop( AF_INET, & client.sin_addr, buffer_ip, sizeof( buffer_ip ) ), ntohs( client.sin_port ) );
        //////////////
        
            string s = to_string(var);
            const char * liniaChar = s.c_str(); 
            strncpy( buffer, liniaChar, sizeof( buffer ) );   
            if( send( clientSocket, buffer, strlen( buffer ), 0 ) <= 0 )
            {
                perror( "sendto() ERROR" );
                exit( 5 );
            }
            
            if( recv( clientSocket, buffer, sizeof( buffer ), 0 ) <= 0  )
            {
                perror( "recvfrom() ERROR" );
                exit( 4 );
    
            }

            sUDPRetVal = convertToString(buffer,4); //TODO !
            UDPRetVal = stoi(sUDPRetVal);
            
            var = UDPRetVal;
            printf("%f",var);

        //////////////
            
        }
    
    shutdown( socket_, SHUT_RDWR );
}

//gcc server.cpp -lstdc++ -o f

