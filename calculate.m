function [position,wantbits] = calculate(sim_consts,Before_puncture_masks,Before_puncture_bits,area)
%CALCULATE �˴���ʾ�йش˺�����ժҪ
    %   �˴���ʾ��ϸ˵��
    m=1;
%     if(sim_consts.QAM == 16)
%         afterConvNums = 4*48;    %QAM16ʹ��1/2����
%     elseif(sim_consts.QAM == 64)
%         afterConvNums = 6*48 * 3/2 %QAM64ʹ��3/4���루3/4 / 1/2��
%     elseif(sim_consts.QAM == 256)
%         afterConvNums = 8*48 * 3/2  %QAM256ʹ��3/4���루3/4 / 1/2��
%     end
    
for k=1:length(Before_puncture_masks)      %�ҳ�mask��λ�ã�������һ��
    if(Before_puncture_masks(k)==1)
        position(1,m)=ceil(k/2);    %/2������룬matlab��ʼ1��������ceil
        position(2,m)=k;
        wantbits(1,m) = Before_puncture_bits(1,k);     %��Ҫ��������Ĺؼ�bits
        m=m+1;
    end
end
end

