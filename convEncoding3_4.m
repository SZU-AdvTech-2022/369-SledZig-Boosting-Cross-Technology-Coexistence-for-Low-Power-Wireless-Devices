function [Before_puncture_masks,Before_puncture_bits] = convEncoding3_4(Before_interleave_masks,Before_interleave_bits)
%CONVENCODINGQAM64 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    %3/4����
    %------------------------------------------------------------------
    %1.�������� + ����
    len = floor(length(Before_interleave_masks)/4)*4;
    padding = zeros(2,length(Before_interleave_bits)/4);
    Before_puncture_masks4 = zeros(4,len/4);
    Before_puncture_bits4 = zeros(4,len/4);
    for i=1:4
        for j = 1:len/4
            Before_puncture_masks4(i,j) = Before_interleave_masks(4*(j - 1) + i);   %������!!!
            Before_puncture_bits4(i,j) = Before_interleave_bits(4*(j - 1) + i);
        end
    end
    Before_puncture_masks5 = [Before_puncture_masks4(1:3,1:length(Before_interleave_masks)/4);padding;Before_puncture_masks4(4,1:length(Before_interleave_masks)/4)];
    Before_puncture_masks = [Before_puncture_masks5(:)'  Before_interleave_masks(len + 1:length(Before_interleave_masks))];  %������������ + ����
    %���ݲ��֣���׵�����0����
    Before_puncture_bits5 = [Before_puncture_bits4(1:3,1:length(Before_interleave_bits)/4);padding;Before_puncture_bits4(4,1:length(Before_interleave_bits)/4)];
    Before_puncture_bits = [Before_puncture_bits5(:)'  Before_puncture_bits5(len + 1:length(Before_puncture_bits5))];  %������������ + ����
    %----------------------------------------------------------------------------------------
end

