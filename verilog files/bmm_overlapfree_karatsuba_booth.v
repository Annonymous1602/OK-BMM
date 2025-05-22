module bmm_overlapfree_karatsuba_booth #(parameter N = 32, 
        parameter k = 4, 
        parameter m = 8, 
        parameter a = 7, 
        parameter b = 8, 
        parameter t = 32)
    ( input [N-1:0] A_reg,B_reg,M_reg,
    input clk,
      input [2*N-1:0] const_reg,
      output reg [N-1:0] Z_reg

    );
    
    wire [2*N-1:0]Zm;
    
    wire [2*N-1:0]ql;
    reg [2*N-1:0]ql_reg;
    wire [2*N - 1:0] Th,T, q;
    reg [2*N-1:0] T_reg;    
    reg [N-1:0]A,B,M,q_reg;
    reg [2*N-1:0] constant_temp;
    reg [2*N-1:0] Z;
    
    always@(posedge clk)
       begin
         A = A_reg;
         B = B_reg;
         M = M_reg;
         constant_temp = const_reg;
         T_reg = T;
         q_reg = q;
         ql_reg = ql;
         Z_reg = Z;
       
       end
      
    karatsuba_overlapfree #( N, k, m) inst1 ( .A(A) , .B(B) , .out(T));
    
    assign Th = T_reg>>(t-b);
    
   karatsuba_upper_overlapfree #(2*N, k, 2*m,N) inst2 (.A(Th) , .B(constant_temp) ,  .q(q));
   
   karatsuba_lower_overlapfree #(N, k, m) insta3 (.A(q_reg) , .B(N), .f(N+1) , .out(ql));
    
   assign Zm = T_reg - ql_reg;
   
    always@(*) begin
      
      
        Z = Zm% (2**(N+1));
        if(Z>=M) 
            Z = Z - M;
    end
endmodule

