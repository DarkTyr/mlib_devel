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

function channelized_fir_init(blk, varargin)
	clog('entering channelized_fir_init', 'trace');

	defaults = { ...
	'numChan', 16, ...
	'coeff', [0, 1, 2, 3, 4, 5, 6 ,7, 8, 9]};

	check_mask_type(blk, 'channelized_fir');

	if same_state(blk, 'defaults', defaults, varargin{:}), return, end
	munge_block(blk, varargin{:});

	numChan                     = get_var('numChan', 'defaults', defaults, varargin{:});
	coeff                       = get_var('coeff', 'defaults', defaults, varargin{:});

	% default empty block for storage in library and check parameters if active
    if coeff == 0
		clean_blocks(blk);
		set_param(blk, 'AttributesFormatString', '');
		save_state(blk, 'defaults', defaults, varargin{:});  % Save and back-populate mask parameter values
		%clog('entering channelized_fir_init','trace');
		return;
    end
    
    if numChan == 0
		clean_blocks(blk);
        set_param(blk, 'AttributesFormatString', '');
		save_state(blk, 'defaults', defaults, varargin{:});  % Save and back-populate mask parameter values
		return;
        
	elseif numChan < 8
		clog('need at least 8 Channels', {'error', 'channelized_fir_init_debug'});
		error('need at least 8 Channels');
		return;
    end
    
    remove_all_blks(blk);
	% Extract Coefficients into indexable list
	fir_coeff = str2num(coeff);
	xsize = 120;
	ysize = 142;
	xoff = 100;
	yoff = 0;
	yinc = 100;
	xinc = xsize;

	%Make Fir Input Port
	port_name = 'fir_in';
	port_offset = 0;
	%in_position = [0 yoff+(port_offset*yinc)-8 30 yoff+(port_offset*yinc)+8];
	position = [0 -16 30 0];
	reuse_block(blk, port_name, 'built-in/Inport', 'Port', num2str(port_offset+1), 'Position', position);
	%add_line(blk,[in_port_name,'/1'], ['bus_create/',num2str(port_offset+1)]);

    
    for index = 1:length(fir_coeff)
        if index == 1
            xsize = 120;
            ysize = 142;
            tap_name = ['start_tap' num2str(index)];
            position = [xoff+index*2*xinc -ysize xoff+xsize+index*2*xinc 0];
            reuse_block(blk, tap_name, 'nist_library/channelized_fir/start_tap', ...
                    'Position', position, ...
                    'numChan', num2str(numChan), ...
                    'value', num2str(fir_coeff(index)));

            add_line(blk,[port_name,'/1'], [tap_name,'/',num2str(1)]);
            
        elseif index == length(fir_coeff)
            xsize = 120;
            ysize = 142;
            tap_name_p = tap_name;
            tap_name = ['end_tap' num2str(index)];
            position = [xoff+index*2*xinc -ysize xoff+xsize+index*2*xinc 0];
            reuse_block(blk, tap_name, 'nist_library/channelized_fir/end_tap', ...
                    'Position', position, ...
                    'numChan', num2str(numChan), ...
                    'value', num2str(fir_coeff(index)));

            add_line(blk,[tap_name_p,'/2'], [tap_name,'/2']);
            add_line(blk,[tap_name_p,'/1'], [tap_name,'/1']);
                    
        else
            xsize = 120;
            ysize = 142;

            tap_name_p = tap_name;
            tap_name = ['tap' num2str(index)];
            position = [xoff+index*2*xinc -ysize xoff+xsize+index*2*xinc 0];
            reuse_block(blk, tap_name, 'nist_library/channelized_fir/tap', ...
                    'Position', position, ...
                    'numChan', num2str(numChan), ...
                    'value', num2str(fir_coeff(index)));

            add_line(blk,[tap_name_p,'/2'], [tap_name,'/2']);
            add_line(blk,[tap_name_p,'/1'], [tap_name,'/1']);
        end % end if control 
        

    end % Overall tap for loop
    
    %Make Fir Output Port
    port_name = 'fir_out';
    port_offset = 0;
    position = [xoff+(1+index)*2*xinc -16 xoff+(1+index)*2*xinc+30 0];
    reuse_block(blk, port_name, 'built-in/Outport', 'Port', num2str(port_offset+1), 'Position', position);
    add_line(blk,[tap_name,'/1'], [port_name,'/1']);
end % pfb_fir_generic_init


