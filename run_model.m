function run_model(TabF_reduced_file, surname, sex, models_mat_file, output_prefix, verbose)
% run_model(TabF_reduced_file, surname, sex, models_mat_file, output_prefix, verbose)
%
%  runs a prediction given:
%    TabF_reduced_file - tab separated file with one publication per line with the following features as columns:
%      

warning off;
tic

if (strcmp(verbose,'on'))
  display(['pub file: ' TabF_reduced_file]);
  display(['surname: ' surname]);
  display(['models file: ' models_mat_file]);
  display(['out prefix: ' output_prefix]);
end

%if ischar(surname)
 %   surname = eval(surname)
%end
%surname_string = surname{1};
%for i = 2:length(surname)
 %   surname_string = strcat(surname_string, {' '}, surname{i});
%end
%surname = char(surname_string)

surname = regexprep(surname,'(\<[a-z])','${upper($1)}');

if (strcmp(verbose,'on'))     
  display('Getting time series');
end

s = GetAuthorTimeSeries_single_author(TabF_reduced_file, surname);

% is not PI
s.is_PI = false(size(s.PMIDs))';

%through_year = [1:15 20 50]; % or get through years from models: models_mat_file.mat
%through_year = 1:7;
through_year = [2 4 6];

% add author h-index
if (strcmp(verbose,'on'))
  disp 'adding h-index'
end

for N = through_year
    s = GetAuthorHindexUpToPI(s,'n_citations',['hindex_ty_' num2str(N)],N);
end

% assign country and affiliation ranking
%s = PIPAssignAffiliationQ(s, 1, 'temp.mat');

% add gender - Removed for now     add checkbox in website ??
%s = PIPPredictGenderFromFirstName(s);
if (ischar(sex))
    sex = str2double(sex);
end
s.sex = sex;

if (strcmp(verbose,'on'))
  display('Assigning uni rank')
end
s = PIPAssignAffiliation_single_author(s);

%display('Affilation features...');
% Todo: binary feature for each feature for first and second half of the career
%aff_vec = max(s.AffiliationMatrix,[],1);
%aff_as_first_vec = max(s.AffiliationMatrix(s.AuthorPositions==1,:),[],1);
%if isempty(aff_as_first_vec)
%	aff_as_first_vec = zeros(size(aff_vec));
%end
%for J=1:length(aff_vec)
%	s.(genvarname(['Aff_' num2str(J)])) = aff_vec(J);
%	s.(genvarname(['Aff_as_first_' num2str(J)])) = aff_as_first_vec(J);
%end
%

if (strcmp(verbose,'on'))     
  display('Adding IF...');
end
% Add IF: use cites per doc if JIF 5 year doesnt exist
s.IF = s.JIF_5year;
s.IF(isnan(s.IF)) = s.Cites_per_Doc_2_years(isnan(s.IF));
%

% add cite per IF
if (strcmp(verbose,'on'))     
  disp 'adding cite per IF'
end
s.log_cite_per_IF = log2(s.n_citations) - log2(s.IF);
s.log_cite_per_IF(isinf(s.log_cite_per_IF)) = nan;

if (strcmp(verbose,'on'))     
  display('Adding year info...');
end

s = PIPAddFeaturesUpToYearN_var(s,through_year,'JIF');
s = PIPAddFeaturesUpToYearN_var(s,through_year,'NumAuthors');
s = PIPAddFeaturesUpToYearN_var(s,through_year,'n_citations');
s = PIPAddFeaturesUpToYearN_var(s,through_year,'log_cite_per_IF');

s = PIPAddFeaturesUpToYearN_npub(s,through_year);


%s = PIPAddFeaturesUpToYearN_var(s,through_year,'Cites_per_Doc_2_years');
%s = PIPAddFeaturesUpToYearN_var(s,through_year,'SJR');
%s = PIPAddFeaturesUpToYearN_var(s,through_year,'JIF_5year');
%s = PIPAddFeaturesUpToYearN_var(s,through_year,'IF');
%s = PIPAddFeaturesUpToYearN_var(s,through_year,'Eigenfactor_Score');
%s = PIPAddFeaturesUpToYearN_var(s,through_year,'Journal_H_index');
% add features for NumAuthors
%


%save('s_new.mat','s'); % debug

%% create plot

%number_of_pub_years = str2double(datestr(s.DateNums(end), 'yyyy')) - str2double(datestr(s.DateNums(1), 'yyyy')) + 1

%start_year = ['01-01-' datestr(s.DateNums(1), 'yyyy')]

%x_ks = zeros(number_of_pub_years+1,1);
%x_label = cell(number_of_pub_years+1,1);
% create x-axis of years
%for i = 1:number_of_pub_years+1
%    x_ks(i) = datenum(start_year) + (i-1)*366;
%    x_label{i} = datestr((datenum(start_year) + (i-1)*366), 'yyyy');
%end

%display(x_label);


%hold off;

% first the line
%h = plot(s.DateNums, s.IF, '--k');
%hold on;

% first author
%plot(s.DateNums(s.AuthorPositions == 1), s.IF(s.AuthorPositions == 1), 'sb', 'MarkerSize', 10, 'MarkerFaceColor', 'b');

% second author
%plot(s.DateNums(s.AuthorPositions == 2), s.IF(s.AuthorPositions == 2), 'dr', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% middle author
%plot(s.DateNums(s.AuthorPositions > 2), s.IF(s.AuthorPositions > 2), 'om', 'MarkerSize', 4, 'MarkerFaceColor', 'm');

%text(((xlocs(1)+xlocs(2)) /2), MEAN_IF_OF_PI + 0.2   , 'Mean PIs', 'Fontsize',14,'FontWeight', 'bold');
%xlim([x_ks(1) x_ks(end)]);

%plot(xlim, [MEAN_MAX_IF_OF_PI MEAN_MAX_IF_OF_PI], '-g', 'linewidth', 2);
%plot(xlim, [max(s.IF) max(s.IF)], '-b', 'linewidth', 2);
%plot(xlim, [MEAN_MAX_IF_OF_NON_PI MEAN_MAX_IF_OF_NON_PI], '-r', 'linewidth', 2);

%set(gca, 'Xk', x_ks, 'Xklabel', x_label);
%set(gcf, 'PaperPositionMode', 'auto');
%print(gcf, '-djpeg', [output_prefix '.jpg']);
%print(gcf, '-dpdf', [output_prefix '.pdf']);


% create 3 vectors for table output
% n_publications, mean IF, max IF, max IF as first

given_stats = [length(s.IF) ; mean(s.IF) ; max(s.IF) ; max(s.IF(s.AuthorPositions == 1))];
given_stats(isnan(given_stats)) = 0;

PI_stats = [MEAN_N_PUBS_OF_PI ; MEAN_MEAN_IF_OF_PI ; MEAN_MAX_IF_OF_PI ; MEAN_MAX_AS_FIRST_IF_OF_PI];

NON_PI_stats = [MEAN_N_PUBS_OF_NON_PI ; MEAN_MEAN_IF_OF_NON_PI ; MEAN_MAX_IF_OF_NON_PI ; MEAN_MAX_AS_FIRST_IF_OF_NON_PI];

WriteArray2TabDelimited(given_stats, [output_prefix '.stats']);
WriteArray2TabDelimited(PI_stats, [output_prefix '.pis']);
WriteArray2TabDelimited(NON_PI_stats, [output_prefix '.non_pis']);

if (strcmp(verbose,'on'))     
  display('Creating feature matrix...');
end
%% create feature matrix from struct:

all_field_names = fieldnames(s);
given_feature_names = {};
NUM_FEATURES = 0;

for i = 1:length(all_field_names)
    curr_field = getfield(s,{1},all_field_names{i});
    if ((islogical(curr_field) || isnumeric(curr_field)) && (length(curr_field) == 1))
       if ~isempty(regexp(all_field_names{i}, '_$', 'once'))
           continue;
       else
           NUM_FEATURES = NUM_FEATURES + 1;
           given_feature_names{NUM_FEATURES} = all_field_names{i}; %#ok<AGROW>
       end
   end
end

given_features = zeros(1, NUM_FEATURES);

for j = 1:NUM_FEATURES
%try
        curr_feature_vals = [s.(given_feature_names{j})];
        given_features(:,j) = curr_feature_vals;      
% 	catch me
%         me , j , given_feature_names{j} , size(given_features) , [s.(given_feature_names{j})] , ...
%             error(['probably some structs have an empty value instead of 0/NaN in feature ' num2str(j) given_feature_names{j}]);
% 	end
end


given_features(isnan(given_features)) = 0; % ?????? <<<<<<<<<<<<<<   this is needed !!!!!!!!!!!!
given_features(isinf(given_features)) = 0; % ?????? <<<<<<<<<<<<<<   this is needed !!!!!!!!!!!!

if (strcmp(verbose,'on'))     
  display('Loading and running model...');
end

% load models (m) that were trained on all data
load(models_mat_file); % load cell array (m) with models

model_feature_names = feature_names;

if (strcmp(verbose,'on'))     
  display(['num features in given file = ' num2str(length(given_feature_names))]);
  display(['num features in model = ' num2str(length(model_feature_names))]); 
end
% %%remove gender from the given features
% given_gender_ind = find(strcmp(given_feature_names, 'sex'));
% if (~isempty(given_gender_ind))
%     given_features(given_gender_ind) = [];
%     given_feature_names(given_gender_ind) = [];
% end

%% make sure the proper weigths are assigned to the proper features

[~, model_ind, given_ind] = intersect(model_feature_names, given_feature_names, 'stable');
C_model = setdiff(model_feature_names, given_feature_names);
C_given = setdiff(given_feature_names, model_feature_names);
given_features = given_features(given_ind);
given_feature_names = given_feature_names(given_ind);

if (strcmp(verbose,'on'))     
  display(['num features after intersection = ' num2str(length(given_features))]);
  display(['num feature names after intersection = ' num2str(length(given_feature_names))]);
end

%display 'features in model that are not given:'
%C_model'
%display 'features given that are not in model:'
%C_given'

% normalize given features
given_features = (given_features - model_mu(model_ind)) ./ model_sigma(model_ind);
given_features(isnan(given_features)) = 0;

%whos

% run PIPredictor  and get P for each model
models = models(:);
score_quant_PI = score_quant_PI(:);
score_quant_NON = score_quant_NON(:);

num_models = length(models);
P = nan(num_models,1);
PI_percentile = nan(num_models,1);
NON_percentile_FDR = nan(num_models,1);

for I=1:5%length(models)
    models{I}.beta = models{I}.beta(model_ind);
    
    P(I) = glmnetPredict(models{I}, 'response', given_features);
    P(I);
    score_quant_PI{I}(2:end-1);
    score_quant_NON{I}(2:end-1);
    
    [min_pi,~] = min(find(score_quant_PI{I}(2:end-1) > P(I)));
    
    [max_non_pi,~] = max(find(score_quant_NON{I}(2:end-1) <= P(I)));
    
    if (isempty(min_pi)) % Ohad, has to put this in since I got an error when I ran a model that was trained on a subset of the data, is this OK ???????
        min_pi = 1;
    end
    
    PI_percentile(I) = min_pi * 5;
    
    if (isempty(max_non_pi))
        max_non_pi = 1;
    end
    
    NON_percentile_FDR(I) = (20 - max_non_pi) * 5;
    
end



% return mean model P
%display(P)
%
if (strcmp(verbose,'on'))     
  display(['Mean test AUC of loaded models = ' num2str(mean(modstruct.results_mean_auc_across_10_repeats(:,2)))]);
  display(['Mean probability of becoming PI for given = ' num2str(nanmean(P))]);
end

P = nanmean(P);
PI_percentile = nanmedian(PI_percentile);
NON_percentile_FDR = nanmedian(NON_percentile_FDR);

if (strcmp(verbose,'on'))
   display([P PI_percentile NON_percentile_FDR]);
end

WriteArray2TabDelimited([P PI_percentile NON_percentile_FDR] , [output_prefix '.pred']);

WriteMatrixWithHeader2TabDelimited(given_features', {'Name', 'Val'}, given_feature_names, [output_prefix '.features']);

toc
display('Done running');
%exit();

