%% Chapter 1, 1.4

4 + 3

%% Chapter 1, 1.5

4/10^2

%% Chapter 1, 1.6

sin(2*pi)

cos(2*pi + 1/10)

exp(-2)

atan(2*pi)

%% Chapter 1, 1.7

[1 2 3 4]

%% Chapter 1, 1.8

[1 2 3 4] * 3

%% Chapter 1, 1.9

[1 2 3 4] .* [1 2 3 4]

[1 2 3 4] .* [1 2 3 4 5]

%% Chapter 1, 1.10

a = 2
b = [1 2 3 4]

c = a*b
d = b.*b

%% Chapter 1, 1.11

who

size(c)

%% Chapter 1, 1.12

c

sum(c)

%% Chapter 1, 1.13

clear

%% Chapter 1, 1.14

p = [1 2 3; 4 5 6]

p + 2

%% Chapter 1, 1.15

a = [1 2 3 4 5]
b = [6 7 8 9 10]

a(2)
b(2)

c = [a; b]

size(c)

c(1,4)

c(1,:)

c(1,2:4)

%% Chapter 1, 1.16

b = [1,2,3,4,5,6,7,8,9,10]*2

a = (1:1:10)*2

indices = find(a > 10)

a(indices)

a(indices) = 0

%% Chapter 1, 1.17

x = (0:1:10)

y = sin(x)

plot(x,y)

x = (0:0.1:10);

y = sin(x);

plot(x,y)

%% Chapter 1, 1.18

z = cos(x);

plot(x,z)

figure

plot(x,z)

hold on

plot(x,y, 'r')

hold off

xlabel('X axis is Time')
ylabel('Y axis is Voltage')
title('My plot of y and z')

%% Chapter 1, 1.19

randn(1)

r = randn(10,1)

r = randn(1000,1);

plot(r)

%% Chapter 1, 1.20

a = [0,0,0, 1,1,1,1, 3,3];

hist(a, (0:1:5))

xlabel('Observed values')
ylabel('Counts, or Number of times observed')
title('Histogram of a')

hist(r, (-5:0.5:5))

%% Chapter 1, 1.21

x = (0:0.1:10);       %Define x from 0 to 10 with step 0.1.
k=1;                  %Fix k=1,
y = sin(x + k*pi/4);  %... and define y at this k.

figure                %Now, make a new figure window,
plot(x,y)             %... and plot y versus x.

k=2;                  %Let's repeat this, for k=2,
y = sin(x + k*pi/4);  %... and redefine y at this k,
hold on               %... and plot it.
plot(x,y)
hold off

k=3;                  %Let's repeat this, for k=3,
y = sin(x + k*pi/4);  %... and redefine y at this k,
hold on               %... and plot it.
plot(x,y)
hold off

k=4;                  %Let's repeat this, for k=4,
y = sin(x + k*pi/4);  %... and redefine y at this k,
hold on               %... and plot it.
plot(x,y)
hold off

k=5;                  %Let's repeat this, for k=5,
y = sin(x + k*pi/4);  %... and redefine y at this k,
hold on               %... and plot it.
plot(x,y)
hold off

x = (0:0.1:10);           %First, define the vector x,
figure                    %... and open a new figure.
for k=1:1:5               %For k from 1 to 5 in steps of 1,
    y = sin(x + k*pi/4);  %... define y (note 'k' in sin),
    hold on               %... hold the figure,
    plot(x,y)             %... plot x versus y,
    hold off              %... and release the figure.
end

%% Chapter 1, 1.22

v = (0:1:10);			%Define a vector.
b = 2.5			        %... and a scalar,
v2 = my_square_function(v,b);	%... as inputs to our function.

%Define a new M-file with the following code.
function output = my_square_function(input1, input2)
  output = input1.^2 + input2;
end

%% Chapter 1, 1.24

clear			        %First clear the workspace,
load Ch1-example-data.mat	%... then load the data.
