classdef AISProcessing < StandardModule
    methods
        function obj = AISProcessing(); end
        function [data, selState] = read(obj, fid, data, fileInfo, length, identifier); 
            [data, selState] = read@StandardModule(obj, fid, data, fileInfo, length, identifier);
            
            % read AIS Processing Module specific data
            dataLength = fread(fid, 1, 'int32');
            if (dataLength==0)
                return;
            end

            data.mmsiNumber = fread(fid, 1, 'int32');
            data.fillBits = fread(fid, 1, 'int16');
            [strVal, strLen] = readJavaUTFString(fid); %#ok<ASGLU>
            data.charData = strVal;
            [strVal, strLen] = readJavaUTFString(fid); %#ok<ASGLU>
            data.aisChannel = strVal;
        end
    end
end