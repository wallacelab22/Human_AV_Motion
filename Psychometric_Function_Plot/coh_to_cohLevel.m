function [data_output] = coh_to_cohLevel(data_output, save_name)
%  Replace coherence levels percentages (0-1) to whole number integers (1-5)

if data_output(:, 2) <= 1
    unique_vals = unique(data_output(:, 2));
    val_map = containers.Map('KeyType', 'double', 'ValueType', 'double');
    counter = 1;
    for i = 1:length(unique_vals)
        curr_val = unique_vals(i);
        
        if isKey(val_map, curr_val)
            data_output(data_output(:, 2) == curr_val, 2) = val_map(curr_val);
        else
            data_output(data_output(:, 2) == curr_val, 2) = counter;
            val_map(curr_val) = counter;
            counter = counter + 1;
        end
    end 
end

if contains(save_name, 'AV')
    if data_output(:, 4) <= 1
        unique_vals = unique(data_output(:, 4));
        val_map = containers.Map('KeyType', 'double', 'ValueType', 'double');
        counter = 1;
        for i = 1:length(unique_vals)
            curr_val = unique_vals(i);
            
            if isKey(val_map, curr_val)
                data_output(data_output(:, 4) == curr_val, 4) = val_map(curr_val);
            else
                data_output(data_output(:, 4) == curr_val, 4) = counter;
                val_map(curr_val) = counter;
                counter = counter + 1;
            end
        end 
    end
end
    

end