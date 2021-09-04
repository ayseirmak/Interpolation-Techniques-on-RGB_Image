
clc
clear
close all

imgo=imread('Hw1.jpeg');
[row,colum]=size(imgo);
img=double(imgo);

req = 'How large should your output image be in the horizontal and vertical axis compared to the input? ';
ratio = input(req);

row4=row*ratio;
colum4=colum*ratio;

for r=1:row4 
        for c=1:colum4
            rnn=round(r/ratio);
            cnn=round(c/ratio);
            if(rnn==0)
                rnn=1;
            elseif(rnn==513)
                rnn=512;
            end
            if(cnn==0)
                cnn=1;
            elseif(cnn==513)
                cnn=512;
            end
            
            NN(r,c)=img(rnn,cnn);
        end 
end
NN=uint8(NN);
 
% %SORU 4B
for r=1:row4 
        for c=1:colum4
             r1=fix(r/ratio);
             r2=fix(r/ratio)+1;
             c1=fix(c/ratio);
             c2=fix(c/ratio)+1;
             f1=c2-c/ratio;
             f2=c/ratio-c1;
             f3=r2-r/ratio;
             f4=r/ratio-r1;
             if r1==0
                 r1=1;
             end
             if r2==0
                 r2=1;
             end
             if c1==0
                 c1=1;
             end
             if c2==0
                 c2=1;
                
             end
             if r1==513
                 r1=512;
                 
             end
             if r2==513
                 r2=512;
                 
             end
             if c1==513
                 c1=512;
                
             end
             if c2==513
                 c2=512;
                
             end     
             BL(r,c)=f1*f3*img(r1,c1)+f2*f3*img(r1,c2)+f1*f4*img(r2,c1)+img(r2,c2)*f2*f4;
        end
end
BL=uint8(BL);

% SORU 4C
%Reference: https://www.fatalerrors.org/a/0N530zo.html


 for r=1:row4
        for c=1:colum4
             r1=fix(r/ratio);
             r2=fix(r/ratio)+1;
             c1=fix(c/ratio);
             c2=fix(c/ratio)+1;
             r11=r1-1;
             c11=c1-1;
             r22=r2+1;
             c22=c2+1;
            
             if r1==0||r1==1
                 r1=1;
                 r11=1;
             end
             if r2==0
                 r2=1;
                 r1=1;
                 r11=1;
             end
             if c1==0 ||c1==1
                 c1=1;
                 c11=1;
             end
             if c2==0
                 c2=1;
                 c1=1;
                 c11=1;
                
             end
             if r1==513
                 r1=512;
                 
             end
             if r2==513||r2==512
                 r2=512;
                 r22=512;
                 
             end
             if c1==513
                 c1=512;
                 c2=512;
                
             end
             if c2==513||c2==512
                 c2=512;
                 c22=512;
                
             end
             u=double(r/ratio-r1);
             v=double (c/ratio-c1);
            
             
       A=[w(u+1),w(u),w(u-1),w(u-2)];
       B=[img(r11,c11),img(r11,c1),img(r11,c2),img(r11,c22);
          img(r1,c11),img(r1,c1),img(r1,c2),img(r1,c22);
          img(r2,c11),img(r2,c1),img(r2,c2),img(r2,c22);
          img(r22,c11),img(r22,c1),img(r22,c2),img(r22,c22)];
      C=[w(v+1);w(v);w(v-1);w(v-2)];
      BC(r,c)=A*B*C;       
             
        end
 end
BC=uint8(BC);



figure;
subplot(2,2,1),imshow(imgo),title('Original Image');axis on;
subplot(2,2,2),imshow(NN),title('Nearest Neighbor Enterpolation');axis on;
subplot(2,2,3),imshow(BL),title('Bilinear Enterpolation');axis on;
subplot(2,2,4),imshow(BC),title('Bicubic Enterpolation');axis on;

function result=w(x)
    if 0<=abs(x) && abs(x)<1
        result=1-2.*abs(x).^2+abs(x).^3;
    elseif 1<=abs(x) && abs(x)<2
        result=4-8.*abs(x)+5.*abs(x).^2-abs(x).^3;
    else
        result=0;
    end
end