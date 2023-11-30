function out = diag3(M, in1, in2, p)
    [m, n] = size(M);
    X = M(2:m, 1);
    Y = M(2:m, 2:n);
    Z = M(1, 2:n);
    % Z = Z(:);
    
    switch p
        case 1
            for j = 1:n-2
                if (((in2 >= Z(j)) && (in2 <= Z(j+1))) || ((in2 <= Z(j)) && (in2 >= Z(j+1))))
                    G = Y(:, j) + (Y(:, j+1) - Y(:, j))/(Z(j+1) - Z(j)) * (in2 - Z(j));
                end
            end
            for i = 1:m-2
                if (((in1 >= G(i)) && (in1 <= G(i+1))) || ((in1 <= G(i)) && (in1 >= G(i+1))))
                    out = X(i) + (X(i+1) - X(i))/(G(i+1) - G(i)) * (in1 - G(i));
                end
            end
        case 2
            for j = 1:n-2
                if (((in2 >= Z(j)) && (in2 <= Z(j+1))) || ((in2 <= Z(j)) && (in2 >= Z(j+1))))
                    G = Y(:, j) + (Y(:, j+1) - Y(:, j))/(Z(j+1) - Z(j)) * (in2 - Z(j));
                end
            end
            for i = 1:m-2
                if (((in1 >= X(i)) && (in1 <= X(i+1))) || ((in1 <= X(i)) && (in1 >= X(i+1))))
                    out = G(i) + (G(i+1) - G(i))/(X(i+1) - X(i)) * (in1 - X(i));
                end
            end
    end
end