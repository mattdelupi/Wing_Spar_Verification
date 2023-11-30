function Ffu = cripstr(M, k, t, p)
    % p = 1 for 7075 and 2 for 2024
    [m, ~] = size(M);
    A = M(:, 1:9);

    x = diag3(A, k, t, 2);

    B = [M(2:m, 10) M(2:m, 10+p)];
    Ffu = XYdiag(B, x);
end