function WriteMatrixWithHeader2TabDelimited(data, col_headers, row_headers, out_file_name, print_nans)
%function WriteMatrixWithHeader2TabDelimited(data, col_headers, row_headers, out_file_name, print_nans)

if ~exist('print_nans','var')
    print_nans = 0;
end

if length(col_headers) - 1 ~= size(data,2) && ~isempty(col_headers)
    error('col headers number do not fit to data: ' );
end
if length(row_headers)  ~= size(data,1)
    error('row headers number do not fit to data');
end

fid = fopen(out_file_name, 'w');
if fid < 0
    error(['File ' out_file_name ' was not found.']);
end

if ~isempty(col_headers)
    for i=1:length(col_headers)
        if (i > 1)
            fprintf(fid,'%s', char(9));
        end
        if isnumeric(col_headers)
            fprintf(fid,'%s', num2str(col_headers(i)));
        else
            fprintf(fid,'%s', col_headers{i});
        end
    end
    fprintf(fid,'\n');
end

r_num = size(data,1);
c_num = size(data,2);

for r=1:r_num

    
    if isnumeric(row_headers)
        fprintf(fid,'%s', num2str(row_headers(r)));
    else
        fprintf(fid,'%s', row_headers{r});
    end

    for c=1:c_num
        fprintf(fid,'%s', char(9));
        if print_nans ~= 0 || ~isnan(data(r,c))
                if ((data(r,c) ~= 0) && (abs(data(r,c)) < 0.000001))
                    fprintf(fid,'%e', data(r,c));
                else
                    fprintf(fid,'%f', data(r,c));
                end
        end
    end

    fprintf(fid,'\n');
end

fclose(fid);