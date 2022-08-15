%%
% 主逻辑

% A作为比较矩阵
clc; clear;
A = [];

A = [1 1 4 1/3 3;
    1 1 4 1/3 3;
    1/4 1/4 1 1/3 1/2;
    3 3 3 1 3;
    1/3 1/3 2 1/3 1];

if check(A) == false
    error('A 不满足一致性');
end

weight = cal_weight(A);
weight % 显示结果
%%
function res = check(mat_A)
    lam = cal_lambda_max(mat_A);
    n = size(mat_A, 1);
    CR = cal_CR(lam, n);

    if CR > 0.1
        res = false;
    end

    res = true;
end

%
function lambda_max = cal_lambda_max(mat_A)
    lambda_max = max(eig(mat_A));
end

%
function CR = cal_CR(lambda_max, n)
    CI = (lambda_max - n) / (n - 1);
    RI = [0 0 0.52 0.89 1.12 1.26 1.36 1.41 1.46 1.49 1.52 1.54 1.56 1.58 1.59];
    CR = CI / RI(n);
end

%%
function wei = cal_weight(A)
    wei_avg.name = "算术平均法";
    wei_avg.value = cal_avg(A);
    wei_geo.name = "几何平均法";
    wei_geo.value = cal_geo(A);
    wei_fea.name = "特征值法";
    wei_fea.value = cal_fea(A);
    wei = compare(wei_avg, wei_geo, wei_fea);
end

%

function mat_res = cal_avg(mat_A)
    n = size(mat_A, 1);
    col_sum = sum(mat_A, 1);
    mat_col_sum = repmat(col_sum, [n, 1]);
    cof = mat_A ./ mat_col_sum;
    mat_res = sum(cof, 2) / n;
end

%

function mat_res = cal_geo(mat_A)
    n = size(mat_A, 1);
    row_prod = prod(mat_A, 2).^(1 / n);
    mat_sum = sum(row_prod);
    mat_res = row_prod / mat_sum;
end

%

function mat_res = cal_fea(mat_A)
    n = size(mat_A, 1);
    [V, D] = eig(mat_A);
    lambda_max = max(diag(D));
    [r, c] = find(abs(D) == lambda_max);
    feature_max = V(:, c);
    mat_res = feature_max / sum(feature_max);
end

function wei = compare(wei1, wei2, wei3)
    disp(wei1.name);
    disp(wei1.value);
    disp(wei2.name);
    disp(wei2.value);
    disp(wei3.name);
    disp(wei3.value);
    wei = wei3.value;
end
