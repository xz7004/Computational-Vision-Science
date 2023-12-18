function varStats = XinmiaoZhangStates(inputMatrix)
    MeanValues = mean(inputMatrix);
    MinValues = min(inputMatrix);
    MaxValues = max(inputMatrix);

    % Display the statistics
    fprintf('Statistics for the variable:\n');
    fprintf('Mean: %s\n', num2str(MeanValues));
    fprintf('Min: %s\n', num2str(MinValues));
    fprintf('Max: %s\n', num2str(MaxValues));

    % Save the numerical values into the variable varStats
    varStats.mean = MeanValues;
    varStats.min = MinValues;
    varStats.max = MaxValues;
end
