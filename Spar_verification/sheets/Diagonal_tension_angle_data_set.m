close all; clear; clc;

A = readmatrix('Diagonal_tension_angle.xlsx');
[m, n] = size(A);

k = linspace(0, 2, m-1);
k = k(:);

M = NaN(m, 4);
M(2:m, 1) = k;
M(1, 2:4) = [0 .5 1];

for i = 2:m
    for j = 2:4
        for r = 2:m-1
            if (((k(i-1) >= A(r, 2*j-3)) && (k(i-1) <= A(r+1, 2*j-3))) && (~isnan(A(r+1, 2*j-3))))
                M(i, j) = A(r, 2*j-2) + (A(r+1, 2*j-2) - A(r, 2*j-2))/(A(r+1, 2*j-3) - A(r, 2*j-3)) * (k(i-1) - A(r, 2*j-3));
            end
        end

        if isnan(M(i, j))
            M(i, j) = M(i-1, j) + (M(i-1, j) - M(i-2, j))/(M(i-1, 1) - M(i-2, 1)) * (M(i, 1) - M(i-1, 1));
        end
    end
end

% writematrix(M, 'Diagonal_tension_angle_data.xlsx');