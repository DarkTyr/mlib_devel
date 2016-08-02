%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
%   National Institute of Standards and Technology - Boulder                  %
%                                                                             %
%   Author: Johnathon Gard                                                    %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function channelized_fir_start_sym_tap_init(blk, varargin)
	clog('entering channelized_fir_start_tap_init', 'trace');

	defaults = { ...
	'numChan', 16, ...
	'value', 0};

	check_mask_type(blk, 'channelized_fir_tap');

	if same_state(blk, 'defaults', defaults, varargin{:}), return, end
	munge_block(blk, varargin{:});

	numChan                     = get_var('numChan', 'defaults', defaults, varargin{:});
	value                       = get_var('value', 'defaults', defaults, varargin{:});

	% default empty block for storage in library and check parameters if active
    if numChan == 0
        return;
    elseif numChan < 8
        clog('need at least 8 Channels', {'error', 'channelized_fir_start_tap_init_debug'});
        error('need at least 8 Channels');
        return;
    end

    set_param([blk,'/Constant0'], 'const', num2str(value))
    set_param([blk,'/delay_bram0'], 'DelayLen', num2str(numChan-2))
    set_param([blk,'/delay_bram1'], 'DelayLen', num2str(numChan-4))
    set_param([blk,'/delay_bram2'], 'DelayLen', num2str(numChan-2))
    
end % channelized_fir_start_tap_init

