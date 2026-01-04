function TestORLFace(faces,train_n)

for i=1:39
    for j=i+1:40
        s = sprintf('\t(%d,%d):\n',i,j);
        disp(s);
        FaceCovLieFisher(faces,i,j,train_n,10,8);
    end
end