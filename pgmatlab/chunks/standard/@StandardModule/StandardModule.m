% StandardModule.m
% 
% Reads in standard module data. Extends BaseChunk.
% As it only reads in standard data, this class 
% should be extended for specific modules.

classdef StandardModule < BaseChunk
    properties
        header = @StandardModuleHeader
        footer = @StandardModuleFooter
    end
    methods
        function obj = StandardModule(); end
        function [data, selState] = read(obj, fid, data, fileInfo, length, identifier) 
            [data, selState] = read@BaseChunk(obj, fid, data, fileInfo, length, identifier);
         
            fileVersion = fileInfo.fileHeader.fileFormat;
            isBackground = identifier == -6;

            % set constants to match the flag bitmap (initialized once only)
            persistent flags;
            if isempty(flags)
                flags = struct;
                flags.TIMEMILLIS           = hex2dec('1');
                flags.TIMENANOS            = hex2dec('2');
                flags.CHANNELMAP           = hex2dec('4');
                flags.UID                  = hex2dec('8');
                flags.STARTSAMPLE          = hex2dec('10');
                flags.SAMPLEDURATION       = hex2dec('20');
                flags.FREQUENCYLIMITS      = hex2dec('40');
                flags.MILLISDURATION       = hex2dec('80');
                flags.TIMEDELAYSSECS       = hex2dec('100');
                flags.HASBINARYANNOTATIONS = hex2dec('200');
                flags.HASSEQUENCEMAP       = hex2dec('400');
                flags.HASNOISE             = hex2dec('800');
                flags.HASSIGNAL            = hex2dec('1000');
                flags.HASSIGNALEXCESS      = hex2dec('2000');
            end

            % CHECK: THIS IS LEGACY CODE AND NOT IMPLEMENTED IN PYPAMGUARD
            % if ~isBackground & isfield(fileInfo, 'objectType')
            %     if (any(data.identifier==fileInfo.objectType))
            %         % do nothing here - couldn't figure out a clean way of checking if
            %         % number wasn't in array
            %     else
            %         disp(['Error - Object Identifier does not match ' fileInfo.fileHeader.moduleType ' type.  Aborting data read.']);
            %         fseek(fid, nextObj, 'bof');
            %         return;
            %     end
            % end

            data.millis = fread(fid, 1, 'int64');
            % set date, to maintain backwards compatibility
            data.date = millisToDateNum(data.millis);
            % TODO: IMPLEMENT timeRange FILTER
            % if (data.date < timeRange(1))
            %     selState = 0;
            % elseif (data.date > timeRange(2))
            %     selState = 2;
            % end

            % read flagBitmap (since version 3)
            if (fileVersion >= 3)
                data.flagBitmap = fread(fid, 1, 'int16');
            else
                data.flagBitmap = 0;
            end
            
            % TODO: check version 2 logic here.
            if (fileVersion == 2 || (bitand(data.flagBitmap, flags.TIMENANOS) ~= 0) )
                data.timeNanos = fread(fid, 1, 'int64');
            end
            if (fileVersion == 2 || (bitand(data.flagBitmap, flags.CHANNELMAP) ~= 0) )
                data.channelMap = fread(fid, 1, 'int32');
            end
            
            % what's going on here? == UID?
            if (bitand(data.flagBitmap, flags.UID) == flags.UID)
                data.UID = fread(fid, 1, 'int64');
                % TODO: IMPLEMENT FILTERS
                % if (data.UID < uidRange(1))
                %     selState = 0;
                % elseif (data.UID > uidRange(2))
                %     selState = 2;
                % end
            end
            % TODO: IMPLEMENT uidList FILTER
            % if ~isempty(uidList) && ~isBackground
            %     inList = sum(uidList == data.UID) > 0;
            %     if ~inList
            %         selState = 0;
            %     end
            %     % rare situations where UID's not in order and this can go badly
            %     % wrong. 
            %     % if (data.UID > max(uidList))
            %     %     selState = 2;
            %     % end
            % end


            if (bitand(data.flagBitmap, flags.STARTSAMPLE) ~= 0)
                data.startSample = fread(fid, 1, 'int64');
            end
            
            if (bitand(data.flagBitmap, flags.SAMPLEDURATION) ~= 0)
                data.sampleDuration = fread(fid, 1, 'int32');
            end
            
            if (bitand(data.flagBitmap, flags.FREQUENCYLIMITS) ~= 0)
                minFreq = fread(fid, 1, 'float');
                maxFreq = fread(fid, 1, 'float');
                data.freqLimits = [minFreq maxFreq];
            end
            
            if (bitand(data.flagBitmap, flags.MILLISDURATION) ~= 0)
                data.millisDuration = fread(fid, 1, 'float');
            end
            
            if (bitand(data.flagBitmap, flags.TIMEDELAYSSECS) ~= 0)
                data.numTimeDelays = fread(fid, 1, 'int16');
                td=zeros(1, data.numTimeDelays);
                for i = 1:data.numTimeDelays
                    td(i)=fread(fid, 1, 'float');
                end
                data.timeDelays=td;
            end
            
            if (bitand(data.flagBitmap, flags.HASSEQUENCEMAP) ~= 0)
                data.sequenceMap = fread(fid, 1, 'int32');
            end

            if (bitand(data.flagBitmap, flags.HASNOISE) ~= 0)
                data.noise = fread(fid, 1, 'float32');
            end

            if (bitand(data.flagBitmap, flags.HASSIGNAL) ~= 0)
                data.signal = fread(fid, 1, 'float32');
            end

            if (bitand(data.flagBitmap, flags.HASSIGNALEXCESS) ~= 0)
                data.signalExcess = fread(fid, 1, 'float32');
            end
        end
    end
end
