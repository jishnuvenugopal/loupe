
module TopModule (
    input clk,
    input x,
    output z
);

    
    reg [1:0] d0, d1, d2;
 
    reg [1:0] d0_compl, d1_compl, d2_compl;
 

    
    reg [1:0] xnor_output;

    
    reg [1:0] state;

    
    initial begin
        state = 2'b00;
 
        d0 = 2'b00;
 
        d1 = 2'b00;
 
        d2 = 2'b00;
 
        d0_compl = 2'b00;
 
        d1_compl = 2'b00;
 
        d2_compl = 2'b00;
 
    end

    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                
                d0 = x;
                d1 = d0;
                d2 = d0;
                d0_compl = ~d0;
                d1_compl = ~d1;
                d2_compl = ~d2;
                xnor_output = d0 ^ d1 ^ d2;
                state = 2'b01;
 
            end
            2'b01: begin
                
                d0 = x;
                d1 = d0;
                d2 = d0;
                d0_compl = ~d0;
                d1_compl = ~d1;
                d2_compl = ~d2;
                xnor_output = d0 & d1 & d2;
                state = 2'b10;
 
            end
            2'b10: begin
                
                d0 = x;
                d1 = d0;
                d2 = d0;
                d0_compl = ~d0;
                d1_compl = ~d1;
                d2_compl = ~d2;
                xnor_output = d0 | d1 | d2;
                state = 2'b00;
 
            end
        endcase
    end

    
    assign z = xnor_output;

endmodule
