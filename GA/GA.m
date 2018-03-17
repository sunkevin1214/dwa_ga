 function [ xmin, x] = GA( fun_handle, x_dim, l_limit, u_limit, weights)
    pop_size = 20;
    max_gen = 20000;
    V = x_dim;
    l_limit = l_limit';
    u_limit = u_limit';
    populations = rand(pop_size, V).*repmat(u_limit-l_limit, pop_size, 1) + repmat(l_limit, pop_size, 1);
    chromosomes = zeros(pop_size, V+1);
    chromosomes(:, 1:V) = populations;
    x = [];
    
    
    for i = 1:pop_size
        chromosomes(i, end) = feval(['weight_', fun_handle],chromosomes(i, 1:V), weights(1,:));
    end
    num_weights = size(weights, 1);
    for gen=1:max_gen
        
        weight_index = mod(gen+1, num_weights);
        if weight_index == 0
            weight_index = num_weights;
        end
        weight = weights(weight_index, :);
        fprintf('%d, w1:%f,w2:%f...\n',gen, weight(1), weight(2));
        % to do tournament selection
        pool_size = round(pop_size/2);
        tour = 2;
        parent_chromosome = tournament_selection(chromosomes, pool_size, tour);
        % generate offspring
        offspring_chromosome = ...
                genetic_operator(parent_chromosome, ...
                V, 20, 20, l_limit, u_limit, fun_handle, 0.9, 1/V, weight);
        x = [x; offspring_chromosome(:, 1:V)];
        % select the best
        combine_chromosome = [chromosomes; offspring_chromosome];
        combine_fitness = combine_chromosome(:, end);
        [~, I] = sort(combine_fitness);
        chromosomes = combine_chromosome(I(1:pop_size), :);
        xmin = [];
    end
    
end

