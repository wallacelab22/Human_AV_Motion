function [tt] = breaktime_var(data_output, nbblocks)
% Create break time variable to check when it is time to break during task
len_data_output = size(data_output, 1);
block_length = floor(len_data_output/nbblocks);
tt = block_length:block_length:len_data_output;
% Combine last two blocks if the last block length is smaller than half the
% other block lengths
last_block_length = len_data_output - tt(1, nbblocks);
if last_block_length < block_length/2
    tt(1, nbblocks) = NaN;
end

end