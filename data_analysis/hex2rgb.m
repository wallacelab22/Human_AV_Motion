function rgb = hex2rgb(hex)
    % HEX2RGB converts a hexadecimal color code to an RGB triplet
    %
    % Input:
    %   hex - a string representing a color in hex format (e.g., '#d73027')
    %
    % Output:
    %   rgb - a 1x3 array representing the color in RGB format with values between 0 and 1
    
    % Remove the '#' if it is present
    if hex(1) == '#'
        hex = hex(2:end);
    end
    
    % Convert hex to decimal
    rgb = [hex2dec(hex(1:2)), hex2dec(hex(3:4)), hex2dec(hex(5:6))] / 255;
end