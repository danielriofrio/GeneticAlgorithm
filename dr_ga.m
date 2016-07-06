%% This code was developed by Daniel Riofrio.
function [BestSolutionXG, BestFitnessXG, bestSolution, bestFitness, final_G] = dr_ga(function_handler, ...
                                           population_size, ...
                                           individual_size, ...
                                           crossover_probability,...
                                           mutation_probability,...
                                           max_generations)
    
    BestSolutionXG = zeros(max_generations, individual_size);
    BestFitnessXG = zeros(max_generations, 1);
    Population = dr_initialize_population(population_size, individual_size);
    Fitness = dr_fitness(function_handler, Population, population_size);
    k = 10;
    bestFitness = Inf;
    
    for final_G=1:max_generations
        
        [Q, bestIndividualSoFar, bestFitnessSoFar] = dr_selection(Population, Fitness, k, individual_size);
        
        if(bestFitnessSoFar <= bestFitness)
            bestFitness = bestFitnessSoFar;
            bestSolution = bestIndividualSoFar;
        end
        
        BestSolutionXG(final_G, :) = bestIndividualSoFar;
        BestFitnessXG(final_G, 1) = bestFitnessSoFar;
        
        NewPopulation = dr_crossover(Q, crossover_probability, population_size);
        MutatedPopulation = dr_mutation(NewPopulation, mutation_probability);
        Population = MutatedPopulation;
        Fitness = dr_fitness(function_handler, Population, population_size);
        
    end
    
end

function [Population] = dr_initialize_population(population_size, individual_size)
    Population = randi([0,1], population_size, individual_size);
end

function [Fitness] = dr_fitness(function_handler, Population, population_size)
    Fitness = zeros(population_size,1);
    for i=1:population_size
        [x, y] = dr_toIntegers(Population(i, :));
        Fitness(i) = function_handler(x, y);
    end
end



function [Q, bestIndividualSoFar, bestFitnessSoFar] = dr_selection(Population, Fitness, k, individual_size)
    Q = zeros(k, individual_size);
    [SortedFitness,Index] = sort(Fitness);
    for i=1:k
        Q(i, :) = Population(Index(i),:);
    end
    
    bestIndividualSoFar = Population(Index(1),:);
    bestFitnessSoFar = SortedFitness(1);
end

function [NewPopulation] = dr_crossover(Q, crossover_probability, population_size)
    [k, individual_size] = size(Q);
    NewPopulation = zeros(population_size, individual_size);
    repopulation = 0;
    while repopulation < population_size
        pair_indexes = randperm(k,2);
        x = rand();
        individual_1 = Q(pair_indexes(1), :);
        individual_2 = Q(pair_indexes(2), :);
        
        if(x < crossover_probability)
            p = randi(individual_size);

            child_1 = zeros(1, individual_size);
            child_2 = zeros(1, individual_size);

            child_1(1:p) = individual_1(1:p);
            child_1(p+1:individual_size) = individual_2(p+1:individual_size);

            child_2(1:p) = individual_2(1:p);
            child_2(p+1:individual_size) = individual_1(p+1:individual_size);
            
            repopulation = repopulation + 1;
            if(repopulation <= population_size)
                NewPopulation(repopulation, :) = child_1;
            end
            repopulation = repopulation + 1;
            if(repopulation <= population_size)
                NewPopulation(repopulation, :) = child_2;
            end
        else
            repopulation = repopulation + 1;
            if(repopulation <= population_size)
                NewPopulation(repopulation, :) = individual_1;
            end
            repopulation = repopulation + 1;
            if(repopulation <= population_size)
                NewPopulation(repopulation, :) = individual_2;
            end
        end
    end

end

function [NewPopulation] = dr_mutation(NewPopulation, mutation_probability)

    [population_size, individual_size] = size(NewPopulation);
    for i=1:population_size
        x = rand();
        if(x < mutation_probability)
            p = randi(individual_size);
            if(NewPopulation(i,p)==1)
                NewPopulation(i,p)=0;
            else
                NewPopulation(i,p)=1;
            end
        end
    end
    
end

