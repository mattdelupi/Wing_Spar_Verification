close all; clear; clc;

A = readmatrix('Allowable_strength.xlsx');
[m, n] = size(A);

k = linspace(0, 1, m-1);
k = k(:);

M = NaN(m, 7);
M(2:m, 1) = k;
M(1, 2:7) = [20 25 30 35 40 45];

for i = 2:m
    for j = 2:7
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

% writematrix(M, 'Allowable_strength_data.xlsx');