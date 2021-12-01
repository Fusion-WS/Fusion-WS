function T=cell2Table(C,vn)
% gets a cell with inner hierarchy and returns a table 


[m,~]= size(C);
ix=find(~cellfun(@isempty,C{1})); 
n = numel(ix);
T = table();
for ii=1:m
	tmp = cell2table(C{ii});
	T = [T;tmp{1,ix}];
end
if exist('vn','var')
    T.Properties.VariableNames =vn;
end


end