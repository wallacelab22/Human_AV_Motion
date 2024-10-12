function assignTableColumnsToVariables(tbl)
% Check that the input is a table
if ~istable(tbl)
    error('Input must be a table');
end

% Get all the column names
columnNames = tbl.Properties.VariableNames;

% Assign each column to a variable in the base workspace
for i = 1:length(columnNames)
    varName = columnNames{i};
    varData = tbl.(varName);

    % Assign to the base workspace
    assignin('base', varName, varData);
end
end