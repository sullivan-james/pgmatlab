% StandardModuleHeader.m

classdef StandardModuleHeader < BaseChunk
    methods
        function obj = StandardModuleHeader(); end
        function [data, selState] = read(self, fid, data, fileInfo, length, identifier) 
            data.length = length;
            data.identifier = identifier;
            data.version = fread(fid, 1, 'int32');
            data.binaryLength = fread(fid, 1, 'int32');
        end
    end
end



