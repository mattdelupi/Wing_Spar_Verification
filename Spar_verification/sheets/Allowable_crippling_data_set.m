close all; clear; clc;

A = readmatrix('Allowable_crippling.xlsx');
[m, n] = size(A);

k = linspace(0, 1, m-1);
k = k(:);

M = NaN(m, 12);
M(2:m, 1) = k;
M(1, 2:9) = [.5 .7 1 1.5 2 2.5 3 4];

for i = 2:m
    for j = 2:9
        for r = 2:m
            if (((k(i-1) >= A(r, 2*j-3)) && (k(i-1) <= A(r+1, 2*j-3))) && (~isnan(A(r+1, 2*j-3))))
                M(i, j) = A(r, 2*j-2) + (A(r+1, 2*j-2) - A(r, 2*j-2))/(A(r+1, 2*j-3) - A(r, 2*j-3)) * (k(i-1) - A(r, 2*j-3));
            end
        end

        if isnan(M(i, j))
            M(i, j) = M(i-1, j) + (M(i-1, j) - M(i-2, j))/(M(i-1, 1) - M(i-2, 1)) * (M(i, 1) - M(i-1, 1));
        end
    end
end

X = linspace(0, 1, m-1);
X = X(:);
M(2:m, 10) = X;
M(1, 11:12) = [1 2];

for i = 2:m
    for j = 1:2
        for r = 2:m
            if (((X(i-1) >= A(r, 15+2*j)) && (X(i-1) <= A(r+1, 15+2*j))) && (~isnan(A(r+1, 15+2*j))))
                M(i, 10+j) = A(r, 16+2*j) + (A(r+1, 16+2*j) - A(r, 16+2*j))/(A(r+1, 15+2*j) - A(r, 15+2*j)) * (k(i-1) - A(r, 15+2*j));
            end
        end
        
        if isnan(M(i, 10+j))
            M(i, 10+j) = M(i-1, 10+j) + (M(i-1, 10+j) - M(i-2, 10+j))/(M(i-1, 10) - M(i-2, 10)) * (M(i, 10) - M(i-1, 10));
        end
    end
end

% writematrix(M, 'Crippling_Strength_data.xlsx');