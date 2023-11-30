function y = XYdiag(M, x)
    X = M(:, 1);
    Y = M(:, 2);
    
    [m, ~] = size(M);

    for i = 1:m-1
        if (((x >= X(i)) && (x <= X(i+1))) || ((x <= X(i)) && (x >= X(i+1))))
            y = Y(i) + (Y(i+1) - Y(i))/(X(i+1) - X(i)) * (x - X(i));
        end
    end
end