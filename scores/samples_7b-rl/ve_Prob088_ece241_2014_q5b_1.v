
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    reg [1:0] state, next_state;
    
    
    localparam [1:0] 
        STATE_A = 2'b01,
        STATE_B = 2'b10;
    
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_A;
        else
            state <= next_state;
    end
    
    
    always @* begin
        case (state)
            STATE_A: 
                next_state = x ? STATE_B : STATE_A;
            STATE_B: 
                next_state = STATE_B;
 
            default: 
                next_state = STATE_A;
 
        endcase
    end
    
    
    assign z = (state == STATE_A) ? x : ~x;
    
endmodule
