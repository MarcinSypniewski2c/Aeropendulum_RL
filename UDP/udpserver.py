import socket
from time import sleep

localIP = "192.168.56.102"
localPort = 20001
bufferSize = 1024

#msgFromServer = "Hello UDP Client"
#bytesToSend = str.encode(msgFromServer)



# CREATE A DATAGRAM SOCKET

UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

# BIND TO ADRESS AND IP

UDPServerSocket.bind((localIP,localPort))

print("UDP server up and listening")

# Listen for incomin datagrams
while(True):
    bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)
    message = bytesAddressPair[0]
    address = bytesAddressPair[1]
    clientMsg = "Message from Client:{}".format(message)
    clientIp = "Client IP Address:{}".format(address)
    
    print(clientMsg)
    print(clientIp)
    
    # Sending a reply to client
    ########
    f= open("sine_wave.csv",'r')
    lines = f.readlines()

    for line in lines:
        if line == "\n":
            print("Empty Line")
        else:
            msgFromServer= line.strip()
            bytesToSend = str.encode(msgFromServer)
            UDPServerSocket.sendto(bytesToSend, address)
    f.close()
    

    ########

