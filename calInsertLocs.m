function [insertLocs] = calInsertLocs(position)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
insertLocs = [];
j = 1;
for i = 2:length(position(1,:))
    if(position(1,i) == position(1,i - 1))
        insertLocs(j) = position(1,i);
        j = j + 1;
    end
end
end

