clc;clear;
weight_file = 'obj8.mat';
load(weight_file);
temp_w = obj8;
num = size(temp_w, 1);
re_index = num:-1:1;
temp_w1 = temp_w(re_index,:);
unform_weight = [temp_w; temp_w1];


% func_name = 'func1';
% x_dim = 20;
% l_bound = zeros(x_dim, 1);
% u_bound = 2*ones(x_dim, 1);

% func_name = 'func2';
% x_dim = 30; 
% l_bound = zeros(x_dim, 1);
% u_bound = ones(x_dim, 1);
addpath('./GA/');
func_name = 'DTLZ2_';
y_dim = 8;
x_dim = 17;
l_bound = zeros(x_dim, 1);
u_bound = ones(x_dim, 1);
[xmin, all_solutions] = GA(func_name, x_dim, l_bound, u_bound, unform_weight);
objs = zeros(size(all_solutions, 1), y_dim);
for i = 1:size(all_solutions, 1)
    objs(i,:) = feval(func_name, all_solutions(i,:));
end
fronts = ENS_BS(objs);
optimal_solutions = objs(fronts{1}, :);
optimal_x = all_solutions(fronts{1}, :);
if size(optimal_solutions, 2) == 2
    scatter(optimal_solutions(:,1), optimal_solutions(:,2));
elseif size(optimal_solutions, 2) == 3
    scatter3(optimal_solutions(:,1), optimal_solutions(:,2), optimal_solutions(:,3));
end