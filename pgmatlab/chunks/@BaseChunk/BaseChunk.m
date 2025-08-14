

classdef BaseChunk
    methods
        function obj = BaseChunk(); disp('Base Chunk constructor'); end
        function [data, selState] = read(self, fid, data, fileInfo, length, identifier);
            selState = 1;
        end
    end
end
