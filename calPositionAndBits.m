function [position, wantbits] = calPositionAndBits(sim_consts,QAM,area,coding)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    sim_consts.QAM = QAM;
    sim_consts.block_size = log2(QAM)*48;
    matrix_deinterleave = deinterleave(sim_consts,QAM);
    subcarriers = calSubcarriers(sim_consts,area);
    if(sim_consts.QAM == 16)
        %�������֯ǰ�ı����Լ���Ҫ����λ
       [Before_interleave_masks,Before_interleave_bits] = beforeInterleaveQAM16(sim_consts,matrix_deinterleave,subcarriers);
       %������֤��QAM16��1/2������3/4�����positionλЧ��һ�£�����2���ظ������Բ���1/2����,���Բ�����

    elseif(sim_consts.QAM == 64)
       %�������֯ǰ�ı����Լ���Ҫ����λ
       [Before_interleave_masks,Before_interleave_bits] = beforeInterleaveQAM64(sim_consts,matrix_deinterleave,subcarriers);

    elseif(sim_consts.QAM == 256)
       %�������֯ǰ�ı����Լ���Ҫ����λ
       [Before_interleave_masks,Before_interleave_bits] = beforeInterleaveQAM256(sim_consts,matrix_deinterleave,subcarriers);
    end
    if(strcmp(coding,'1/2'))
        Before_puncture_masks = Before_interleave_masks;
        Before_puncture_bits = Before_interleave_bits;
    elseif(strcmp(coding,'2/3'))
        [Before_puncture_masks,Before_puncture_bits] = convEncoding2_3(Before_interleave_masks,Before_interleave_bits);
    elseif(strcmp(coding,'3/4'))
        [Before_puncture_masks,Before_puncture_bits] = convEncoding3_4(Before_interleave_masks,Before_interleave_bits);
    elseif(strcmp(coding,'5/6'))
        [Before_puncture_masks,Before_puncture_bits] = convEncoding5_6(Before_interleave_masks,Before_interleave_bits);
    end
    
   %�����position��wantbits
   [position,wantbits] = calculate(sim_consts,Before_puncture_masks,Before_puncture_bits,area);
end

