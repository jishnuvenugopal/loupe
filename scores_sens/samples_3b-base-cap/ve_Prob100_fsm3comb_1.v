
module TopModule (
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    
    
    
    
    
    

    
    localparam [3:0] state_table[4:0] = {
        4'b0000, 
        4'b0001, 
        4'b0010, 
        4'b0011  
    };

    
    always @(*) begin
        case (state)
            2'b00: begin
                next_state = state_table[0];
                out = state_table[0][2];
            end
            2'b01: begin
                next_state = state_table[1];
                out = state_table[1][2];
            end
            2'b10: begin
                next_state = state_table[2];
                out = state_table[2][2];
            end
            2'b11: begin
                next_state = state_table[3];
                out = state_table[3][2];
            end
        endcase
    end

endmodule
