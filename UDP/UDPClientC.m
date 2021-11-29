clear all
clc

y = [];
n = 100; % nr of samples to take from server

u = udp('192.168.56.102',8888);
fopen(u);
fwrite(u,'Connection Succeed')
for i = 1:n
A = fread(u,10); 
y(i) = decodeStringData(A);

end
fclose(u)

plot(y)
