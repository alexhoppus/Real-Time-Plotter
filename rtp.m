#!/usr/bin/octave -qf

t = 0 ;
xb = 0 ;
xc = 0 ;
xs = 0;
s = 0;
startSpot = 0;
interv = 1000 ; % considering 1000 samples
step = 0.1 ; % lowering step has a number of cycles and then acquire more data
cmds = {};
labels = {};
n_cmds = 0;
choosen_colors = {};
fid = fopen('cmdfile');
cmd = fgets(fid);
while ischar(cmd)
	if cmd(1)!="#"
		[cmdtok, label] = strtok(cmd, '@');
		cmds{end + 1} = cmdtok;
		labels{end + 1} = label;
		choosen_colors{end + 1} = [rand, rand, rand];
		n_cmds = n_cmds + 1;
	end
	cmd = fgets(fid);
end
fclose(fid);
n_cmds = n_cmds - 1;
x = [];
x = x';
while (t < interv)
    cur_vec = zeros(1, n_cmds);
    for cmd = 1 : n_cmds
        [output, str_ret] = system(cmds{cmd});
	if isempty(str_ret)
		str_ret = '0';
	end
	ret = str2num(str_ret);
	cur_vec(cmd) = ret;
    end
    x(:, end + 1) = cur_vec';
    if ((t / step) - 5000 < 0)
	startSpot = 0;
    else
    	startSpot = (t / step) - 5000;
    end
    for i = 1 : n_cmds
    	subplot(n_cmds, 1, i);
    	h = plot(x(i,:), 'linewidth', 5, 'color', choosen_colors{i});
    	hold all;
	max_val = max(x(i, :));
	if max_val == 0
		max_val = 10;
	end
    	axis([ startSpot, (t / step + 50), 0 , 1.5 * max_val]);
    	grid
	title(labels{i}(2:end));
	set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
    end
    t = t + step;
    drawnow;
    pause(0.1)
end
