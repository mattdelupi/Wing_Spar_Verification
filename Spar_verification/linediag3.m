function out = linediag3(M, in1, in2, p)
    ang = M(:, 3);
    [m, ~] = size(M);

    X = M(:, 1);
    Y = M(:, 2) + ang .* (in1 - X);
    Z = M(:, 4);

    switch p
        case 3
            for i = 1:m-1
                if (((in2 >= Y(i)) && (in2 <= Y(i+1))) || ((in2 <= Y(i)) && (in2 >= Y(i+1))))
                    out = Z(i) + (Z(i+1) - Z(i))/(Y(i+1) - Y(i)) * (in2 - Y(i));
                end
            end
        case 2
            for i = 1:m-1
                if (((in2 >= Z(i)) && (in2 <= Z(i+1))) || ((in2 <= Z(i)) && (in2 >= Z(i+1))))
                    out = Y(i) + (Y(i+1) - Y(i))/(Z(i+1) - Z(i)) * (in2 - Z(i));
                end
            end
    end
end