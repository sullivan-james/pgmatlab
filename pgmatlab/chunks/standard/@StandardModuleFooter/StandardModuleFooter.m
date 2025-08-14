% StandardModuleFooter.m

classdef StandardModuleFooter < BaseChunk
    methods
        function obj = StandardModuleFooter(); end
        function data = read(obj, fid, data, fileInfo, length, identifier) 
            data.length = length;
            data.identifier = identifier;
            data.binaryLength = fread(fid, 1, 'int32');
        end
    end
end



