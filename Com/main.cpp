#include <stdio.h>
#include <stdlib.h> // exit()
#include <string.h> // memset()
#include <arpa/inet.h> // inet_pton()
#include <sys/socket.h>
#include <iostream>
#include <fstream>
#include <string>
#include "AS5600.h"
#include <wiringPi.h>
#include <unistd.h>
#include "uartSteval.h"
#include <ctype.h>


#define SERVER_PORT 6789
#define SERVER_IP "192.168.1.2" //PC IP

using namespace std;


string convertToString(char* a, int size)
{
    int i;
    string s = "";
    for (i = 0; i < size; i++) {
        s = s + a[i];
    }
    return s;
}

const int ScopeOutput= 25;

int main()
{

    // ENCODER
    int as5600;
    AS5600_Init(&as5600);
    //
    
    //GPIO
    wiringPiSetup();
    pinMode(25,OUTPUT);
    //

    // MOTOR
    UART uart;
    uart.baud = 38400;
    int speed=0;
    Frame f;
    //

    StartMotor(1,uart,&f);
    //
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
   
    const int socket_ = socket( AF_INET, SOCK_DGRAM, 0 );
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
   
    
    struct sockaddr_in client = { };
    string sUDPRetVal = "";
    int UDPRetVal = 0;
       
    memset( buffer, 0, sizeof( buffer ) );
       
    printf( "Waiting for connection...\n" );
    if( recvfrom( socket_, buffer, sizeof( buffer ), 0,( struct sockaddr * ) & client, & len ) < 0 )
    {
             perror( "recvfrom() ERROR" );
             exit( 4 );
    
    }
    else {
        //printf( "|Message from client|: %s \n", buffer );
        while( 1 )
        {   
            char buffer_ip[ 128 ] = { };
            printf( "|Client ip: %s port: %d|\n", inet_ntop( AF_INET, & client.sin_addr, buffer_ip, sizeof( buffer_ip ) ), ntohs( client.sin_port ) );
        //////////////
            // ENKODER
            float degrees = convertRawAngleToDegrees(getRawAngle());
            //
            string s = to_string(degrees);
            const char * liniaChar = s.c_str(); 
            strncpy( buffer, liniaChar, sizeof( buffer ) );   
            if( sendto( socket_, buffer, strlen( buffer ), 0,( struct sockaddr * ) & client, len ) < 0 )
            {
                perror( "sendto() ERROR" );
                exit( 5 );
            }
            //SCOPE
            digitalWrite(ScopeOutput,HIGH);
            //
            if( recvfrom( socket_, buffer, sizeof( buffer ), 0,( struct sockaddr * ) & client, & len ) < 0 )
            {
                perror( "recvfrom() ERROR" );
                exit( 4 );
    
            }
            //SCOPE
            digitalWrite(ScopeOutput,LOW);
            //
            sUDPRetVal = convertToString(buffer,2); //TODO !
            speed = stoi(sUDPRetVal);

            printf("%d",speed);
            SetMotorRefSpeed(speed,1,uart,&f);

            usleep(50);

        //////////////
            
        }
    }
    shutdown( socket_, SHUT_RDWR );
}

//g++ main.cpp uartSteval.cpp uartSteval.h registers.h AS5600.cpp AS5600.h -lstdc++ -lwiringPi -o a