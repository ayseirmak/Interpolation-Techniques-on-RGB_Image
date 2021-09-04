clc
clear
close all


imgRGB=imread('HW1_rgb.jpeg');
[row,colum,rgb]=size(imgRGB);

%SORU5
imgrgb=double(imgRGB);

req = 'How large should your output image be in the horizontal and vertical axis compared to the input? ';
ratio = input(req);

row5=row*ratio;
colum5=colum*ratio;

% SORU 5A
for rgb = 1:3
    for r=1:row5 
            for c=1:colum5
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

                NNrgb(r,c,rgb)=imgrgb(rnn,cnn,rgb);
            end 
    end
end
NNrgb= uint8(NNrgb);



% %SORU 5B
for rgb = 1:3
    for r=1:row5 
            for c=1:colum5
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
                 BLrgb(r,c,rgb)=f1*f3*imgrgb(r1,c1,rgb)+f2*f3*imgrgb(r1,c2,rgb)+f1*f4*imgrgb(r2,c1,rgb)+imgrgb(r2,c2,rgb)*f2*f4;
            end
    end
end    
BLrgb = uint8(BLrgb);


% SORU 5C
%Reference: https://www.fatalerrors.org/a/0N530zo.html

BC=zeros(row5,colum5);
for rgb = 1:3
     for r=1:row5
            for c=1:colum5
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
           B=[imgrgb(r11,c11,rgb),imgrgb(r11,c1,rgb),imgrgb(r11,c2,rgb),imgrgb(r11,c22,rgb);
              imgrgb(r1,c11,rgb),imgrgb(r1,c1,rgb),imgrgb(r1,c2,rgb),imgrgb(r1,c22,rgb);
              imgrgb(r2,c11,rgb),imgrgb(r2,c1,rgb),imgrgb(r2,c2,rgb),imgrgb(r2,c22,rgb);
              imgrgb(r22,c11,rgb),imgrgb(r22,c1,rgb),imgrgb(r22,c2,rgb),imgrgb(r22,c22,rgb)];
          C=[w(v+1);w(v);w(v-1);w(v-2)];
          BCrgb(r,c,rgb)=A*B*C;       

            end
     end
end
BCrgb = uint8(BCrgb);


figure;
subplot(2,2,1),imshow(imgRGB),title('Original Image');axis on;
subplot(2,2,2),imshow(NNrgb),title('Nearest Neighbor Enterpolation');axis on;
subplot(2,2,3),imshow(BLrgb),title('Bilinear Enterpolation');axis on;
subplot(2,2,4),imshow(BCrgb),title('Bicubic Enterpolation');axis on;

function result=w(x)
    if 0<=abs(x) && abs(x)<1
        result=1-2.*abs(x).^2+abs(x).^3;
    elseif 1<=abs(x) && abs(x)<2
        result=4-8.*abs(x)+5.*abs(x).^2-abs(x).^3;
    else
        result=0;
    end
end