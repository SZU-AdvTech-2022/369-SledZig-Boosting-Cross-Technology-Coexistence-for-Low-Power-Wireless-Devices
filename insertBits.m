function [insertData] = insertBits(sim_consts,QAM,position,wantbits,rawdata,coding)
%������Ҫ����ı�����
%insertLocs = calInsertLocs(position);
insertNums = length(position(1,:));
if(QAM == 16)
    unit = sim_consts.unitBitsBeforeConvQAM16;
    j_k = sim_consts.j_kQAM16;
    overlapBitSame;
elseif(QAM == 64)
    unit = sim_consts.unitBitsBeforeConvQAM64;
    j_k = sim_consts.j_kQAM64;
elseif(QAM == 256)
    unit = sim_consts.unitBitsBeforeConvQAM256;
    j_k = sim_consts.j_kQAM256;
end
unitRawNums = unit - insertNums;
n = ceil(length(rawdata)/unitRawNums);  %�������ٸ�symbol
overlapBitSameFlag = 1;
symbolBits = sim_consts.num_ofdm * log2(QAM);
%-----------�ȴ�������---------------
for num = 1:n
    unitdata = rawdata(1+unitRawNums*(num-1):unitRawNums*num);
    for m=1:insertNums
        if(position(1,m)<7)
            tempzero=zeros(1,7-position(1,m));
            tempdata=unitdata((position(1,m)-1):-1:1);
            tempbits=[tempdata tempzero];
        else
            tempbits=unitdata((position(1,m)-1):-1:(position(1,m)-6));
        end
        if(position(2,m) == 2*position(1,m)-1)%significance bit��λ��Ϊ������Ҳ�����õ�һ���������������
             if(m < insertNums && position(1,m) == position(1,m+1))%�غ�����²���n-1λ
                if(tempbits(5) == 0 && overlapBitSameFlag == 1)%n-5=0��significant bits��ͬ
                    x = 0;
                elseif(tempbits(5) == 0 && overlapBitSameFlag == 0)%n-5=0��significant bits�෴
                    x = 1;
                elseif(tempbits(5) == 1 && overlapBitSameFlag == 1)%n-5=1��significant bits��ͬ
                    x = 1;
                else
                    x = 0;
                end
            unitdata = [unitdata(1:position(1,m) - 2) x unitdata(position(1,m) - 1:length(unitdata))];
            tempbits=unitdata((position(1,m)-1):-1:(position(1,m)-6));  %����tempbits
             end
            temp1=[0 tempbits];     %ǰ��Ӹ�0(��Ϊ�Ƿ�ת�ģ��൱��significance bitλ)
            coded_bit1 = rem(sum(temp1.*sim_consts.ConvCodeGenPoly(1,:)),2);   %significance bitΪ0��������ı���
            if(coded_bit1 == wantbits(m))     %��������ı���ֵ = ��֯ǰ�ı���  �����Ǽ�0�ܹ��ܹ��ﵽҪ��
                unitdata = [unitdata(1:position(1,m)-1) 0 unitdata(position(1,m):length(unitdata))];
            else        %��0���ܣ��Ǿ���1
                unitdata = [unitdata(1:position(1,m)-1) 1 unitdata(position(1,m):length(unitdata))];
            end
        else%significance bit��λ��Ϊż����Ҳ�����õڶ����������������
            %��Ϊ��һ��significance bit
            if(m == 1)      %Ϊʲôm=1������ģ���else�����ݲ�����ȫһ����
                temp1=[0 tempbits];     %ǰ��Ӹ�0(��Ϊ�Ƿ�ת�ģ��൱��significance bitλ)
                coded_bit1 = rem(sum(temp1.*sim_consts.ConvCodeGenPoly(2,:)),2);   %significance bitΪ0��������ı���
                if(coded_bit1 == wantbits(m))     %��������ı���ֵ = ��֯ǰ�ı���  �����Ǽ�0�ܹ��ܹ��ﵽҪ��
                    unitdata = [unitdata(1:position(1,m)-1) 0 unitdata(position(1,m):length(unitdata))];
                else        %��0���ܣ��Ǿ���1
                    unitdata = [unitdata(1:position(1,m)-1) 1 unitdata(position(1,m):length(unitdata))];
                end
            elseif(position(1,m) == position(1,m-1))
                %ʲô������
            else
                temp1=[0 tempbits];     %ǰ��Ӹ�0(��Ϊ�Ƿ�ת�ģ��൱��significance bitλ)
                coded_bit1 = rem(sum(temp1.*sim_consts.ConvCodeGenPoly(2,:)),2);   %significance bitΪ0��������ı���
                if(coded_bit1 == wantbits(m))     %��������ı���ֵ = ��֯ǰ�ı���  �����Ǽ�0�ܹ��ܹ��ﵽҪ��
                    unitdata = [unitdata(1:position(1,m)-1) 0 unitdata(position(1,m):length(unitdata))];
                else        %��0���ܣ��Ǿ���1
                    unitdata = [unitdata(1:position(1,m)-1) 1 unitdata(position(1,m):length(unitdata))];
                end   
            end
        end 
    end

    %�ġ���WiFidata����encoding��interleaving
    encoded_bits1 = DataConvEncoder(unitdata);  %�������
    encoded_bits = encoded_bits1(1:symbolBits*eval(coding)*2);

    %���
    punctured_bits = punctured(encoded_bits,coding);
    
    %��֯
    interleaved_encoded_bits = punctured_bits(:,j_k+1);
    %interleaved_encoded_bits111=reshape(interleaved_encoded_bits,8,block_size/8);
    %[interleaved_encoded_bits111(2:4,16:21);interleaved_encoded_bits111(6:8,16:21)]
    %interleaved_encoded_bits111(1:8,2:6)
    rawdata(1+symbolBits*(num-1) : symbolBits*num) = interleaved_encoded_bits;
end
insertData = rawdata;
%------------------------------------------------------
end

