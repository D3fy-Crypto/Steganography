% Image to be Encoded
inputimg = imread('cameraman.tif');
imshow('cameraman.tif');
vecImg = reshape(inputimg,1,[]);
Data = vecImg;
% Perform Huffman Encoding
HEAD=0;
%%%%%%%%%%%%%%%%%%%%
%--Compute Header--------
POS=0; 
S_=size(Data);        
for i=1:S_(2)
    if (POS~=0)
      S=size(HEAD); F=0;
      k=1;
      while (F==0 && k<=S(2))
         if (Data(i)==HEAD(k))  F=1; end
         k=k+1;
      end
    else F=0; 
    end
    if (F==0)
      POS=POS+1;
      HEAD(POS)=Data(i);
    end
end
fprintf('Header:\n');
display(HEAD);
%%%%%%%%Compute probability for symbols%%%%%%%%%%%%
S_H=size(HEAD);
Count(1:S_H(2))=0;
for i=1:S_H(2)
    for j=1:S_(2)
        if (Data(j)==HEAD(i))
            Count(i)=Count(i)+1;
        end
    end
end
Count=Count./S_(2);
fprintf('probability for symbols\n');
display(Count);
%%%Sort accoridng to maximum number%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:S_H(2)-1
    for j=i+1:S_H(2)
        if (Count(j)>Count(i))
            T1=Count(i); Count(i)=Count(j); Count(j)=T1;
            T1=HEAD(i); HEAD(i)=HEAD(j); HEAD(j)=T1;
        end
    end
end
fprintf('Sort Results\n');
display(HEAD);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[dict,avglen] = huffmandict(HEAD,Count); % Create dictionary.
hcode = huffmanenco(Data,dict); % Encode the data.
display(hcode);
len1 = size(hcode,2)
bin_num_message = hcode(:); 
[n5,n6]=size(hcode);

% Cover Image 
a1 = imread('wall.jpg');
a1 = imresize(a1,[1024 1024]);
figure(),imshow(a1),title('cover image');
a=a1(:,:,1);
t1=a1(:,:,2);
t2=a1(:,:,3);
a=rgb2gray(a1);
[r,c]=size(a);
a=im2double(a);
a=a*255;
b=8;
n1=(floor(r/(b)))*b;
n2=(floor(c/b))*b;
a=imresize(a,[n1,n2]);
t1=imresize(t1,[n1,n2]);
t2=imresize(t2,[n1,n2]);
I=a;
z=zeros(n1,n2);

for i=1:b:n1
    for j=1:b:n2
      f=I(i:i+b-1,j:j+b-1);
      f1=dct2(f);
      z(i:i+b-1,j:j+b-1)=f1;
    end
end
figure(2),imshow(z/255);

quantization_table = [
 16  11  10  16  24   40   51   61;
 12  12  14  19  26   58   60   55;
 14  13  16  24  40   57   69   56;
 14  17  22  29  51   87   80   62;
 18  22  37  56  68   109  103  77;
 24  35  55  64  81   104  113  92;
 49  64  78  87  103  121  120  101;
 72  92  95  98  112  100  103  99];
quant1=zeros(n1,n2);
    for i=1:b:n1
        for j=1:b:n2
            for ii=1:b
                for jj=1:b
                    aa=z(i+ii-1,j+jj-1);
                    quant1(i+ii-1,j+jj-1)=(aa/quantization_table(ii,jj));
                end
            end
        end
    end
quant=round(quant1);
B2 = quant;
figure(3),imshow(quant/255);
B2(1:8,1:8)
B2 = zigzag(B2);
len = length(B2)

%embedding using LSB
input = B2;
input(:,1:8)
output = input; 
embed_counter = 1; 
for i = 1 : len
    if(embed_counter <= len1)
        % Finding Least Significant Bit of the current pixel 
        LSB = mod(input(:,i), 2);   
        % Find whether the bit is same or needs to change 
        temp = double(xor(LSB, bin_num_message(embed_counter)));
        % Updating the output to input + temp 
        output(i) = input(i)+temp;  
        % Increment the embed counter 
        embed_counter = embed_counter+1; 
    end
end
output(:,1:8)
B2 = izigzag(output,1024,1024);

%Performing Inverse Quantization By Multiplying with q_mtx and 2D - DCT
quant=zeros(n1,n2);

    for i=1:b:n1
        for j=1:b:n2
            for ii=1:b
                for jj=1:b
                    aa=B2(i+ii-1,j+jj-1);
                    quant(i+ii-1,j+jj-1)=(aa*quantization_table(ii,jj));
                end
            end
        end
    end
z11=zeros(n1,n2);
for i=1:b:n1
    for j=1:b:n2
      f=quant(i:i+b-1,j:j+b-1);
      f1=idct2(f);
      z11(i:i+b-1,j:j+b-1)=f1;
    end
end
figure(),imshow(z11/255),title('final grayscale image');
%z1=round(z11);
fi=cat(3,z11,t1,t2);
figure(),imshow(fi),title('stego image');
imwrite(fi,'stego01.jpg');

%Decoding of Image
s=z11/255;
s1=im2double(s);
s1=s1*255;
% DCT and Quantiztion
[n7,n8]=size(s1);
s2=zeros(n7,n8);
for i=1:b:n7
    for j=1:b:n8
        s3=s1(i:i+b-1,j:j+b-1);
        s4=dct2(s3);
        s2(i:i+b-1,j:j+b-1)=s4;
    end
end
s2=round(s2);
quant1=zeros(n1,n2);

    for i=1:b:n1
        for j=1:b:n2
            for ii=1:b
                for jj=1:b
                    aa=s2(i+ii-1,j+jj-1);
                    quant1(i+ii-1,j+jj-1)=(aa/quantization_table(ii,jj));
                end
            end
        end
    end
quant1=round(quant1);
B2 = zigzag(quant1);
B2(1:10)
% Get height and width for traversing through the image 
message_length =len1; 
% counter to keep track of number of bits extracted 
counter = 1; 
% Traverse through the image 
for i = 1 : len1 
        % If more bits remain to be extracted 
        if (counter <= message_length)  
        % Store the LSB of the pixel in extracted_bits 
        extracted_bits(i) = mod(B2(i),2); 
        % Increment the counter 
        counter = counter + 1; 
        end
end


display(extracted_bits);
h2=huffmandeco(extracted_bits,dict);
display(h2);
SecretImage = reshape(h2,[256 256]);
uint8(SecretImage);
display(SecretImage);
xlswrite('SecretImage.xls',SecretImage);

input_image = xlsread('SecretImage.xls'); 
imshow(input_image);

function output = zigzag(in)
h = 1;
v = 1;
vmin = 1;
hmin = 1;
vmax = size(in, 1);
hmax = size(in, 2);
i = 1;
output = zeros(1, vmax * hmax);
%----------------------------------
while ((v <= vmax) && (h <= hmax))
    
    if (mod(h + v, 2) == 0)                 % going up
        if (v == vmin)       
            output(i) = in(v, h);        % if we got to the first line
            if (h == hmax)
	      v = v + 1;
	    else
              h = h + 1;
            end
            i = i + 1;
        elseif ((h == hmax) && (v < vmax))   % if we got to the last column
            output(i) = in(v, h);
            v = v + 1;
            i = i + 1;
        elseif ((v > vmin) && (h < hmax))    % all other cases
            output(i) = in(v, h);
            v = v - 1;
            h = h + 1;
            i = i + 1;
     end
        
    else                                    % going down
       if ((v == vmax) && (h <= hmax))       % if we got to the last line
            output(i) = in(v, h);
            h = h + 1;
            i = i + 1;
        
       elseif (h == hmin)                   % if we got to the first column
            output(i) = in(v, h);
            if (v == vmax)
	      h = h + 1;
	    else
              v = v + 1;
            end
            i = i + 1;
       elseif ((v < vmax) && (h > hmin))     % all other cases
            output(i) = in(v, h);
            v = v + 1;
            h = h - 1;
            i = i + 1;
        end
    end
    if ((v == vmax) && (h == hmax))          % bottom right element
        output(i) = in(v, h);
        break
    end
end
end



function output = izigzag(in, vmax, hmax)
% initializing the variables
%----------------------------------
h = 1;
v = 1;
vmin = 1;
hmin = 1;
output = zeros(vmax, hmax);
i = 1;
%----------------------------------
while ((v <= vmax) & (h <= hmax))
    if (mod(h + v, 2) == 0)                % going up
        if (v == vmin)
            output(v, h) = in(i);
            if (h == hmax)
	      v = v + 1;
	    else
              h = h + 1;
            end;
            i = i + 1;
        elseif ((h == hmax) & (v < vmax))
            output(v, h) = in(i);
            i;
            v = v + 1;
            i = i + 1;
        elseif ((v > vmin) & (h < hmax))
            output(v, h) = in(i);
            v = v - 1;
            h = h + 1;
            i = i + 1;
        end;
        
    else                                   % going down
       if ((v == vmax) & (h <= hmax))
            output(v, h) = in(i);
            h = h + 1;
            i = i + 1;
        
       elseif (h == hmin)
            output(v, h) = in(i);
            if (v == vmax)
	      h = h + 1;
	    else
              v = v + 1;
            end;
            i = i + 1;
       elseif ((v < vmax) & (h > hmin))
            output(v, h) = in(i);
            v = v + 1;
            h = h - 1;
            i = i + 1;
        end;
    end;
    if ((v == vmax) & (h == hmax))
        output(v, h) = in(i);
        break
    end;
end;

end
