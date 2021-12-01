function L = dummy2label(D)
disp('');
d = size(D);

L = zeros(d(1:3),'uint16');
for ii=1:d(4)
    L(D(:,:,:,ii)>0) = ii;
end

end