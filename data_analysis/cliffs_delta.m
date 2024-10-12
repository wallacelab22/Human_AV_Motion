function delta = cliffs_delta(group1, group2)
    % Get the sample sizes of each group
    n1 = length(group1);
    n2 = length(group2);
    
    % Initialize counters for comparisons
    larger_count = 0;
    smaller_count = 0;
    equal_count = 0;
    
    % Loop over all pairwise comparisons
    for i = 1:n1
        for j = 1:n2
            if group1(i) > group2(j)
                larger_count = larger_count + 1;
            elseif group1(i) < group2(j)
                smaller_count = smaller_count + 1;
            else
                equal_count = equal_count + 1;
            end
        end
    end
    
    % Calculate Cliff's Delta
    delta = (larger_count - smaller_count) / (n1 * n2);
end
