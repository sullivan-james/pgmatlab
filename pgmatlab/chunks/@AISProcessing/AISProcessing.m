classdef AISProcessing < StandardModule
    methods
        function obj = DetectionChunk(); end
        function [data, fileInfo] = read(self, fid, data, fileInfo, length, identifier); 
            [data, selState] = read@StandardModule(self, fid, data, fileInfo, length, identifier);
            
            disp('i got ehre')
            % read AIS Processing Module specific data
            dataLength = fread(fid, 1, 'int32');
            if (dataLength==0)
                return;
            end

            data.mmsiNumber = fread(fid, 1, 'int32');
            data.fillBits = fread(fid, 1, 'int16');
            [strVal, strLen] = readJavaUTFString(fid);
            data.charData = strVal;
            [strVal, strLen] = readJavaUTFString(fid);
            data.aisChannel = strVal;
        end
    end
end