% Obtains the homography matrix from a set of matched points
% https://www.mathworks.com/matlabcentral/answers/26141-homography-matrix
function v = homography_solve(pin, pout)
    if ~isequal(size(pin), size(pout))
        error('Points matrices different sizes');
    end
    if size(pin, 1) ~= 2
        error('Points matrices must have two rows');
    end
    n = size(pin, 2);
    if n < 4
        error('Need at least 4 matching points');
    end

    % Solve equations using SVD
    x = pout(1, :); y = pout(2, :); X = pin(1, :); Y = pin(2, :);
    rows0 = zeros(3, n);
    rowsXY = -[X; Y; ones(1, n)];
    hx = [rowsXY; rows0; x .* X; x .* Y; x];
    hy = [rows0; rowsXY; y .* X; y .* Y; y];
    h = [hx hy];
    if n == 4
        [U, ~, ~] = svd(h);
    else
        [U, ~, ~] = svd(h, 'econ');
    end
    v = (reshape(U(:,9), 3, 3)).';

    % divide by bottom right value (always equal to 1 in lectures)
    v = v / v(3, 3);
end