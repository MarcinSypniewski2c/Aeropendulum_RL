clear all
clc

y = [];
n = 16; % nr of samples to take from server

u = udp('192.168.56.102',8888);
fopen(u);
fwrite(u,'Connection Succeed')
for i = 1:n
A = fread(u,100); 
y(i) = decodeStringData(A);
Processed = y(i) + 1
fwrite(u,num2str(Processed))
end
fclose(u)

%plot(y)
