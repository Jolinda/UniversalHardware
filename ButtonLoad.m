% use ButtonSetup to define keys file
function k = ButtonLoad(keyfile)
    if nargin < 1
    	keyfile = GetKeyfileName;
    end
    if ~keyfile
        error("No keyfile");
    end
    
    opts.Interpreter = 'tex';
    
    % we need this to easily get just the first letter of the keys
    index = @(x,n) x(n);
    
    devices_found = 0;
    while ~devices_found    
        clear keys;
        load(keyfile, 'keys');
        if exist('keys','var')
            k = keys;
            k.keyboard_index = GetKeyboardIndices([], [], k.keyboard_loc);
            k.trigger_index = GetKeyboardIndices([], [], k.trigger_loc);
            k.left_index = GetKeyboardIndices([], [], k.left_loc);
            k.right_index = GetKeyboardIndices([], [], k.right_loc);
            % convenience - they are only different in the mock
            k.response_indices = unique([k.left_index, k.right_index]);

            devices_found = length([k.keyboard_index, k.trigger_index, ...
                k.left_index, k.right_index]) == 4;
        else
            devices_found = false;
        end
        
        
        if ~devices_found
            message = '\fontsize{14}Unable to find devices.';
            title = 'Warning';
            opts.Default = ButtonText('Run Setup');
            answer = questdlg(message, title, ...
               ButtonText('Try another file'), ...
               ButtonText('Ignore'), ...
               ButtonText('Run Setup'), opts);
        
            switch answer
                case ButtonText('Try another file')
                    keyfile = GetKeyfileName;
                case ButtonText('Run Setup')
                    keyfile = ButtonSetup;
                case ButtonText('Ignore')
                    return;
            end
        else
            message = ["\fontsize{14}Keyboard device: " + k.keyboard_name];
            message = [message, "", "Trigger device: " + k.trigger_name];
            message = [message, "", "Left response device: " + k.left_name];
            message = [message, "", "Right response device: " + k.right_name];
            message = [message, "", "Trigger key: " + KbName(k.trigger)];
            message = [message, "", "Left buttons: " + ...
                index(KbName(k.b0), 1) + " " + ...
                index(KbName(k.b1), 1) + " " + ...
                index(KbName(k.b2), 1) + " " + ...
                index(KbName(k.b3), 1) + " " + ...
                index(KbName(k.b4), 1)];
            message = [message, "", "Right buttons: " + ...
                index(KbName(k.b5), 1) + " " + ...
                index(KbName(k.b6), 1) + " " + ...
                index(KbName(k.b7), 1) + " " + ...
                index(KbName(k.b8), 1) + " " + ...
                index(KbName(k.b9), 1)];
            message = [message, "", "Is this correct?"];
            opts.Default = ButtonText('Yes');
            answer = questdlg(message, 'Devices loaded', ...
                ButtonText('Yes'), ...
                ButtonText('No, try another file'), ...
                ButtonText('No, run button setup'), opts);

            switch answer
                case ButtonText('No, try another file')
                    keyfile = GetKeyfileName;
                    devices_found = false;
                case ButtonText('No, run button setup')
                    keyfile = ButtonSetup;
                    devices_found = false;
            end
        end   
    end
    
end

function kfile = GetKeyfileName
    disp("Select keyfile");
    [kfilename, kdir] = uigetfile(pwd, 'Select key file', '*.mat');
    kfile = fullfile(kdir, kfilename);
    if ~kfilename
        opts.Interpreter = 'tex';
        opts.Default = ButtonText('Yes');
        answer = questdlg("\fontsize{14}Run button setup?", ...
            'No keyfile', ...
            ButtonText('Yes'), ButtonText('No'), ...
            opts);
        
        switch answer
             case ButtonText('Yes')
                 kfile = ButtonSetup;
             case ButtonText('No')
                 error("No keyfile");
        end
    end
end

function ConvertedText = ButtonText(input)
    ConvertedText = "<html><font size='4'>" + input;
end