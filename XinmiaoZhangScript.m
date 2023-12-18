% XinmiaoZhangScript.m: CVS Homework 1 Assignment
% 9 - 1 - 2023

%%Question 1： matrix addressing and properties
%1a creat the matrix
mat1 = [41 36 18; 21 72 7; 2 12 95]
%1b element (2,1)
mat1(2,1)
%1c inverse of the matrix
Y = inv (mat1)
%1d sums of each column
sum(mat1(:,1))
sum(mat1(:,2))
sum(mat1(:,3))
%1e sunms of each row
 %method one
 sum(mat1(1,:))
 sum(mat1(2,:))
 sum(mat1(3,:))
 %method two
 mat1 = [41 36 18; 21 72 7; 2 12 95]
 %calculate the sums of each row
 row_sums = sum(mat1, 2);
 %display the sums
 disp('Sums of each row:');
 disp(row_sums);

%%Question 2:  variable creation and random numbers
%2a creat a variable named notMuch
notMuch = zeros(5, 12);
%2b creat a variable named Renny
row = 14;
column = 3;
Renny = randi([9, 15], row, column);
%2c creat a varible named Billy
mean_value = 50;
std_deviation = 10;
numbers = 300;
Billy = mean_value + std_deviation * randn(numbers, 1);
%2d check the Billy
mean_Billy = mean(Billy)
std_Billy = std(Billy)
%Billy = mean_value + std_deviation * randn(numbers, 1);
h = jbtest (Billy, 0.05)
[h, p, jbstat, cv] = jbtest (Billy,  0.05)
%2e creat a vector named Fiver
Fiver = 1:5;
%2f creat a new variable named manyFiver
manyFivers = repmat(Fiver, 5, 1);

%%Question 3: linear systems
%3a solve the linear system
mat1 = [41 36 18; 21 72 7; 2 12 95];
b = [20; 20; 20;];
solution_a = mat1 \ b;
%display the values of a1, a2, and a3
a1 = solution_a(1);
a2 = solution_a(2);
a3 = solution_a(3);
fprintf('a1 = %.4f\n', a1);
fprintf('a2 = %.4f\n', a2);
fprintf('a3 = %.4f\n', a3);
%3b solve the linear system
mat1 = [41 36 18; 21 72 7; 2 12 95];
c = [41.1 47.5 95; 2.1 50 100; 0.2 54.5 109;];
solution_b = mat1 \ c;
b11 = solution_b(1, 1);
b12 = solution_b(1, 2);
b13 = solution_b(1, 3);
b21 = solution_b(2, 1);
b22 = solution_b(2, 2);
b23 = solution_b(2, 3);
b31 = solution_b(3, 1);
b32 = solution_b(3, 2);
b33 = solution_b(3, 3);
fprintf('b1,1 = %.4f\n', b11);
fprintf('b1,2 = %.4f\n', b12);
fprintf('b1,3 = %.4f\n', b13);
fprintf('b2,1 = %.4f\n', b21);
fprintf('b2,2 = %.4f\n', b22);
fprintf('b2,3 = %.4f\n', b23);
fprintf('b3,1 = %.4f\n', b31);
fprintf('b3,2 = %.4f\n', b32);
fprintf('b3,3 = %.4f\n', b33);
%3c matrix multiply mat1 * mat1
mat1 = [41 36 18; 21 72 7; 2 12 95];
d = mat1 * mat1

%%Question 4: loops and logic
%4a write a loop
for n = 1:50  % loop from 1 to 50 since 50^2 = 2500
    value = n^2;
    fprintf('%d ', value);
end
fprintf('\n');
%4b write a nested loop
rows = 4;
cols = 4;
Matrix4b = zeros(rows, cols); %initialize an empty matrix
counter = 1; % initialize a counter
for col = 1:cols %loop 'for'
    for row = 1:rows
        Matrix4b(row, col) = counter;
        counter = counter + 1;
    end
end
disp(Matrix4b); % display the Matrix

%%Question 5:
%the XinmiaoZhangStats function with the given input
inputMatrix = reshape(1:45, 9, 5);
varStats = XinmiaZhangStats(inputMatrix);







