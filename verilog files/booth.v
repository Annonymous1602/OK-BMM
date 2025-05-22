module booth #(parameter REG_WIDTH = 10, parameter OUT_WIDTH = 20)(
  
    input [REG_WIDTH-1:0] A, B,
    output reg [OUT_WIDTH-1:0] P
);
    
    reg [OUT_WIDTH-1:0] partial_sum;
    reg [REG_WIDTH:0] booth_reg;
    integer i;
    
    always @(*) begin
        
        booth_reg = {B, 1'b0};
        partial_sum = 0;
        
        for (i = 0; i < REG_WIDTH / 2; i = i + 1) begin
            case (booth_reg[2:0])
                3'b000, 3'b111: partial_sum = partial_sum;            
                3'b001, 3'b010: partial_sum = partial_sum + (A << ( i<<1)); 
                3'b011:          partial_sum = partial_sum + (A << ((i<<1) + 1)); 
                3'b100:          partial_sum = partial_sum - (A << ((i<<1) + 1)); 
                3'b101, 3'b110:  partial_sum = partial_sum - (A << ((i<<1))); 
            endcase
            booth_reg = booth_reg >> 2; 
        end
        
        P = partial_sum;
    end

endmodule
