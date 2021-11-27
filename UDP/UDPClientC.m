clear all
clc

u = udp('192.168.56.102',8888);
fopen(u);
fwrite(u,'Hello SERVER')
A = fread(u,10);
B = A';
native2unicode(B)
fclose(u)