function l=labelLUT(L,offset,G,outdir,names,fn)
% function gets file name fn and outdir 
% loads a label map reindexes the labels and saves the volume with indexes
% relabeled and a Look up table in the format of 
% 1   <unique name>                RGBA
% ...
% k   <unique name>                RGBA

%[L,G]=fast_nii_Load(fn);
idL = unique(L(~isnan(L))); % you atlas id's
%idL(idL==0)=[];% ignore zero's
nL = numel(idL);

LUT = zeros(2^16,1,'uint16');
if ~exist('offset','var') || isempty(offset)
    LUT(idL+1) = 1:nL;
else 
    LUT(idL+1) = offset+1:offset+nL;
end
l = intlut(uint16(L),LUT);
if nnz(isnan(L));l(isnan(L))=nan;end
        

if nargin>2
cmap = uint8(jet(nL).*255);
fid = fopen([outdir filesep fn '.txt'],'w');
for row = 1:nL;fprintf(fid,'%i  %s %i %i %i %i \n',row,names{row},cmap(row,1),cmap(row,2),cmap(row,3),0);end
fast_nii_save(l,G,[outdir filesep fn '.nii'],'uint16');
end
end