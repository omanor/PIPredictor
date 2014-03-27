function WriteArray2TabDelimited (array, out_file_name, print_nans)
%function WriteArray2TabDelimited (array, out_file_name, print_nans)
% the array can be a cell array


if ~exist('print_nans','var')
    print_nans = 0;
end

fid = fopen(out_file_name, 'w');

if fid < 0
    error(['File ' out_file_name ' can not be created.']);
end

r_num = length(array);


for r=1:r_num
    
    if isnumeric(array)
        if ~(print_nans == 0 && isnan(array(r)))


            fprintf(fid,'%s', num2str(array(r)));
        end
    else
        fprintf(fid,'%s', array{r});
    end

    fprintf(fid,'\n');
end

fclose(fid);