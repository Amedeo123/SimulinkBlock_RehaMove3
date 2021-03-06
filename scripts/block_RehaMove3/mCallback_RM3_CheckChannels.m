function mCallback_RM3_CheckChannels( )
%MCALLBACK_RM3_CHECKCHANNELS checks that the input channels are only 1 ... 4.

%   TU Berlin --- Fachgebiet Regelungssystem
%   Author: Markus Valtin
%   Copyright © 2017 Markus Valtin. All rights reserved.
%
%   This program is free software: you can redistribute it and/or modify it under the terms of the 
%   GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
%
%   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

    %% check the input value
    channelsStr = get_param(gcb, 'stimChannels');
    channels = round( evalin('caller', channelsStr) );

    mode = get_param(gcb, 'stimRehaMoveProProtocol');
    channelSet = [false, false, false, false];
    
    has_error = false;
    has_errorML = false;
    for i = 1:length(channels)
        if (channels(i) < 0)
            channels(i) = 0; 
            has_error = true;
        end
        if (channels(i) > 4)
            channels(i) = 0; 
            has_error = true;
        end
        if (round(channels(i)) ~= channels(i))
            channels(i) = round(channels(i)); 
            has_error = true;
        end
        
        % MidLevel Mode -> allow each channel only one time
        if strcmp(mode, 'Use the MidLevel protocol   -> Only stimulation pulse updates are send.')
            if (channels(i) ~= 0)
                if channelSet(channels(i))
                    channels(i) = 0; 
                    has_errorML = true;
                else
                    channelSet(channels(i)) = true;
                end 
            end
        end
    end
    if (has_error)
        errordlg('Channels must be integers from 1 to 4!','Channel Config Error');
    end
    if (has_errorML)
        errordlg('The MidLevel Mode allows each channel only ONCE!','Channel Config Error');
    end
    
    % check the number of channels
    Nchannels = length(channels);
    if (Nchannels > 10)
        Nchannels = 10;
        errordlg('You can NOT use more than 10 stimulation pulses! ','Channel Config Error');
    end
    
    %% set the updatet value
    channelsStrNew = ['[ ',num2str(channels(1:Nchannels)), ' ]'];
    if (~strcmp(channelsStrNew, channelsStr))
        set_param(gcb, 'stimChannels', channelsStrNew);
    end
end

