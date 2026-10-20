
module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

    
    
    
    
    
    

    
    reg [1:0] next_state_table [2:0][2:0];
    
    assign next_state_table[2'b00] = {2'b00, 2'b01};
 
    assign next_state_table[2'b01] = {2'b10, 2'b01};
 
    assign next_state_table[2'b10] = {2'b00, 2'b11};
 
    assign next_state_table[2'b11] = {2'b10, 2'b01};
 

    
    reg out_table [2:0][2:0];
    
    assign out_table[2'b00] = 1'b0;
 
    assign out_table[2'b01] = 1'b0;
 
    assign out_table[2'b10] = 1'b0;
 
    assign out_table[2'b11] = 1'b1;
 

    
    always @(*) begin
        next_state = next_state_table[state][in];
    end

    
    always @(*) begin
        out = out_table[state][in];
    end

endmodule
