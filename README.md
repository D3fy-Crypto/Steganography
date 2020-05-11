# Steganography
Steganography using Huffmann Coding and 2d - Block DCT
Problem Statement:
Hiding information into a cover image for providing security. Because It doesn’t seem fishy enough for hackers to see a normal image as it contains any secret information, it becomes more important for the users to maintain privacy. And to provide such security and privacy to the user, hiding information in an image and transmitting to other is very important to protect from any unauthorised user access.
Objective:
Hiding information into a cover image using Block – DCT and Huffman Encoding as this algorithm show that the information has a high capacity and a good invisibility.
Tools to be used:
MATLAB or Python based on complexity of the code and other factors such as Speed, Functionalities, Code Readability, Cost

Work Distribution:
As our project contains of two algorithms 
Embedding Algorithm: For embedding of information into cover image.

Extraction Algorithm: For extracting the secret information from cover image.
.
Methodology:
1.	Firstly, the secret message that is extracted is compressed by using Huffman encoding as the contents in the compressed string will significantly hard to detect and read, furthermore it reduces the size of string.
Huffman codes are optimal codes that map one symbol to one code word.    For an image Huffman coding assigns a binary code to each intensity value of the image and a 2-D M2 × N2 image is converted to a 1-D bits stream with length LH < M2 × N2.
Huffman table contains binary codes to each intensity value. Huffman table must be same in both the encoder and the decoder. Thus, the Huffman table must be sent to the decoder along with the compressed image data. 
2.	Secondly, the cover image is divided into 8*8 blocks. Huffman code H is decomposed into 8-bits blocks B. Let the length of Huffman encoded bits stream be LH. Thus, if LH is not divisible by 8, then last block contains r = LH % 8 number of bits (% is used as modulo operator).  
3.	Now DCT is applied, the 2-D DCT block calculates the two-dimensional discrete cosine transform of the input signal. The equation for the two-dimensional DCT is
 
4.	Finally, encoding the encrypted message in the image. It uses LSB steganographic embedding to encode data into an image.
 The least significant bit of all of the DCT coefficients inside 8×8 block is changed to a bit taken from each 8-bit block B from left to right. The method is as follows: For k=1; k1; k=k+1    LSB ((F(u,v))2 )  B(k) ; 
Where B(k) is the kth bit from left to right of a block B and (F(u,v)2 ) is the DCT coefficient in binary form, Perform the inverse block DCT on F and obtain a new image f1 which contains secret image.. Once the message is encoded the process stops.
5.	From the embedded image the information is extracted using extraction algorithm.
The stego-image is received in spatial domain. DCT is applied on the stego-image using the same block of size 8 × 8 to transform the stego-image from spatial domain to frequency domain. The size of the encoded bit stream and the encoded bit stream of secret message/image are extracted along with the Huffman table of the secret message/image.:
