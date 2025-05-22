module karatsuba_upper_overlapfree #(parameter N=64, parameter k=4,parameter m=16,parameter p =32) (input [N-1:0]A,B, output reg [N-1:0]q);

     
  wire [N/k+1:0] a0[2:0];
  wire [N/k+1:0] a1[2:0];
  wire [N/k+1:0] a2[2:0];
  wire [N/k+1:0] b0[2:0]; 
  wire [N/k+1:0] b1[2:0]; 
  wire [N/k+1:0] b2[2:0];
  wire [ 2*N/k+3:0] e0[2:0]; 
  wire [ 2*N/k+3:0] e1[2:0]; 
  wire [2*N/k+3:0] e2[2:0];
  reg [ 2*N/k+3:0] c0[1:0];
  reg [ 2*N/k+4:0] c1[1:0];  
  reg [ 2*N/k+3:0] c2[1:0];
  reg [2*N-1 :0] temp0[1:0];
  reg [2*N-1 :0] temp1[1:0];
  reg [2*N-1 :0] temp2[1:0];
  wire [(N/k):0]A0,A1,A2,A3,B0,B1,B2,B3;
  wire [N-1:0]r;
  reg [2*N-1:0]G0,G1,G2; 
  wire [2*N-1:0]out;
  

  assign r = 2**m;
  assign A3 = A[(N-1):(N-(N/k))];
  assign A2 = A[(N-(N/k)-1):(N/2)];
  assign A1 = A[((N/2)-1):(N/k)];
  assign A0 = A[((N/k)-1):0];
  
  assign B3 = B[(N-1):(N-(N/k))];
  assign B2 = B[(N-(N/k)-1):(N/2)];
  assign B1 = B[((N/2)-1):(N/k)];
  assign B0 = B[((N/k)-1):0];
  
  
  assign a0[0] = A0;
  assign a0[1] = A2; 
  assign a0[2] = A2; 
  
  assign a1[0] = A0 + A1; 
  assign a1[1] = A2 + A3; 
  assign a1[2] = A2 + A3; 

  assign a2[0] = A1;
  assign a2[1] = A3; 
  assign a2[2] = A3; 
  
  
  assign b0[0] = B2; 
  assign b0[1] = B0; 
  assign b0[2] = B2; 
  
  
  assign b1[0] = B2 + B3; 
  assign b1[1] = B0 + B1;
  assign b1[2] = B2 + B3; 
  
  
  assign b2[0] = B3; 
  assign b2[1] = B1; 
  assign b2[2] = B3; 
  
  
 integer i =0; 
 integer j =0; 
 integer d=0;
 
 
 booth #(m+2,(2*m)+4) inst0 (a0[0],b0[0],e0[0]);
  
  booth #(m+2,(2*m)+4) inst1 (a0[1],b0[1],e0[1]);
  
  booth #(m+2,(2*m)+4) inst2 (a0[2],b0[2],e0[2]);
  
 
  
  booth #(m+2,(2*m)+4) inst4 (a1[0],b1[0],e1[0]);
  
  booth #(m+2,(2*m)+4) inst5 (a1[1],b1[1],e1[1]);
  
  booth #(m+2,(2*m)+4) inst6 (a1[2],b1[2],e1[2]);
  
 
  
  booth #(m+2,(2*m)+4) inst8 (a2[0],b2[0],e2[0]);
  
  booth #(m+2,(2*m)+4) inst9 (a2[1],b2[1],e2[1]);
  
  booth #(m+2,(2*m)+4) inst10 (a2[2],b2[2],e2[2]);
  
  
 always@(*) begin 

   G0=0;
   c0[0] = e0[0] + e0[1]; 
   c0[1] = e0[2] ;
  
   for (j=0;j<2;j=j+1) 
    begin
        temp0[j] = (c0[j]*(r**((j+1)<<1)));
        G0 = G0 + temp0[j];
    end
  end 
  
    
  always@(*) begin 

   G1=0;
   c1[0] = e1[0] + e1[1]; //   c[1] = e[0] + e[1]; 
   c1[1] = e1[2];
  
   for (i=0;i<2;i=i+1) 
    begin
        temp1[i] = (c1[i]*(r**((i+1)<<1)));
        G1 = G1 + temp1[i];
    end
  end 
  
  
  always@(*) begin
    
   G2=0;
   c2[0] = e2[0] + e2[1]; 
   c2[1] = e2[2];
      
   for (d=0;d<2;d=d+1) 
    begin
        temp2[d] = (c2[d]*(r**((d+1)<<1)));
        G2 = G2 + temp2[d];
    end
    
    q = out >> p;
    
  end 
  
   
  assign out =  ( ( G1 - G2 - G0) * r ) + ( G2 * (r ** 2)) + ( A2 * B2 * (r ** 4))  + ( A1 * B1 * (r ** 2 ) );
                                              
endmodule
