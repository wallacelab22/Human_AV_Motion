function [data_output] = at_generateExampleMatrix(block)
% Hard coded matrix for instructions. Showcases all possible combinations of
% our stimulus
if contains(block, 'Vis') || contains(block, 'Aud') || contains(block, 'AV')
    data_output = [1 1.0 1 1.0 0 0 0 0;
                   2 1.0 2 1.0 0 0 0 0;
                   1 1.0 NaN NaN 0 0 0 0;
                   2 1.0 NaN NaN 0 0 0 0;
                   NaN NaN 1 1.0 0 0 0 0;
                   NaN NaN 2 1.0 0 0 0 0;
                   1 0.5 NaN NaN 0 0 0 0;
                   1 0.5 1 0.5 0 0 0 0;
                   NaN NaN 2 0.3 0 0 0 0;
                   2 0.3 2 0.3 0 0 0 0;
                   2 0.1 NaN NaN 0 0 0 0;
                   2 0.1 1 0.1 0 0 0 0
                   NaN NaN 1 0.1 0 0 0 0
                   1 0.1 1 0.1 0 0 0 0];
end

end