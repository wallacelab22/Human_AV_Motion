function [outputArg1,outputArg2] = OLD_at_generateMatrix(inputArg1,inputArg2)

%% Old way of generating matrix
sl1 = [left_var audInfo.cohSet(1)];
sr1 = [right_var audInfo.cohSet(1)];

sl2 = [left_var audInfo.cohSet(2)];
sr2 = [right_var audInfo.cohSet(2)];

sl3 = [left_var audInfo.cohSet(3)];
sr3 = [right_var audInfo.cohSet(3)];

sl4 = [left_var audInfo.cohSet(4)];
sr4 = [right_var audInfo.cohSet(4)];

sl5 = [left_var audInfo.cohSet(5)];
sr5 = [right_var audInfo.cohSet(5)];

sl6 = [left_var audInfo.cohSet(6)];
sr6 = [right_var audInfo.cohSet(6)];

sl7 = [left_var audInfo.cohSet(7)];
sr7 = [right_var audInfo.cohSet(7)];

matsl1 = repmat(sl1, stimtrials, 1);
matsr1 = repmat(sr1, stimtrials, 1);

matsl2 = repmat(sl2, stimtrials, 1);
matsr2 = repmat(sr2, stimtrials, 1);

matsl3 = repmat(sl3, stimtrials, 1);
matsr3 = repmat(sr3, stimtrials, 1);

matsl4 = repmat(sl4, stimtrials, 1);
matsr4 = repmat(sr4, stimtrials, 1);

matsl5 = repmat(sl5, audtrials, 1);
matsr5 = repmat(sr5, audtrials, 1);

matsl6 = repmat(sl6, audtrials, 1);
matsr6 = repmat(sr6, audtrials, 1);

matsl7 = repmat(sl7, audtrials, 1);
matsr7 = repmat(sr7, audtrials, 1);

trialStruc = cat(1, catchmat, right_matrix{1}, left_matrix{1}, right_matrix{2}, left_matrix{2}, right_matrix{3}, left_matrix{3});

end