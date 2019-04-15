##    close;##    scatter(reservoir_sizes, test_Error, "r"); hold on##    plot(unique(reservoir_sizes), mean_test_error);##    axis([reservoir_sizes(1) - 10, inf, 0, 1]);##    xlabel("No. of Reservoir Nodes");##    ylabel("Test Error NRMSE");##    title(experiment_title, "fontsize", 15);##    ##    plot_title = char(["Plot-", date(), "-", experiment_title, ".png"]); ##    print(plot_title);##    %create input-output plots##    nPlotPoints = 1000 ; ##    plot_sequence(trainOutputSequence(nForgetPoints+1:end,:), predictedTrainOutput, nPlotPoints,...##        'training: teacher sequence (red) vs predicted sequence (blue)');##    plot_sequence(testOutputSequence(nForgetPoints+1:end,:), predictedTestOutput, nPlotPoints, ...##        'testing: teacher sequence (red) vs predicted sequence (blue)') ;     trainError = compute_NRMSE(predictedTrainOutput, trainOutputSequence); ##    disp(sprintf('train NRMSE = %s', num2str(trainError)));    testError = compute_NRMSE(predictedTestOutput, testOutputSequence); ##    %disp(sprintf('Test NRMSE = %s', num2str(testError)));    