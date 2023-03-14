function [matrix_deinterleave] = deinterleave(sim_consts,QAM)
%j_k��Ϊ�ǹ̶��ģ�����ֱ��д����sim_consts��
    % in_bits = randn(1,block_size*1) > 0;
    % % ��һ��ת�ú�ÿ�е���������һ�㽻֯
    % m_k = block_size/N_col*mod([0:block_size-1],N_col)+floor([0:block_size-1]/N_col); %ת��Ϊ16*18,����Ϊ��λ
    % % �ڶ���ת�ú�ÿ�е��������ڶ��㽻֯
    % s = max(N_BPSC/2,1);
    % j_k = s*floor(m_k/s)+mod((m_k+block_size-floor(N_col*m_k/block_size)),s);   %�ڶ��㽻֯����s*N_col��Ϊ��λ��ÿһ�н���һ�����ɵĽ���

    % ��ɽ�֯
    if(QAM == 16)
        j_k = sim_consts.j_kQAM16;
    elseif(QAM == 64)
        j_k = sim_consts.j_kQAM64;
    elseif(QAM == 256)
        j_k = sim_consts.j_kQAM256;
    end
    matrix_deinterleave = zeros(1,sim_consts.block_size);
    for k=1:sim_consts.block_size
        matrix_deinterleave(k)=find(j_k == k-1);
    end
end

