% bitmap.m
% 
% Utility functions for working with bitmaps
%

function [val] = bitmap(flagBitmap, flag, flags)
    persistent bitmap_info;
    if isempty(bitmap_info)
        bitmap_info = flags;
    end
    val = bitand(flagBitmap, flag);
end