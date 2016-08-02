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

function channelized_fir_sym_tap_odd_end_init(blk, varargin)
	clog('entering channelized_fir_start_tap_init', 'trace');

	defaults = { ...
	'numChan', 16, ...
	'value', 0};

	check_mask_type(blk, 'channelized_fir_tap_odd_end');

	if same_state(blk, 'defaults', defaults, varargin{:}), return, end
	munge_block(blk, varargin{:});

	numChan                     = get_var('numChan', 'defaults', defaults, varargin{:});
	value                       = get_var('value', 'defaults', defaults, varargin{:});

	% default empty block for storage in library and check parameters if active
    if value == 0
        return;
    end
    if numChan < 8
        clog('need at least 8 Channels', {'error', 'channelized_fir_start_tap_init_debug'});
        error('need at least 8 Channels');
        return;
    end

    set_param([blk,'/Constant0'], 'const', num2str(value))
    
end % channelized_fir_tap_odd_end_init

