
module fsm (
    input        CLK,
    input        RST,
    input        IN,
    output reg   MATCH
);

    
    reg [4:0] state;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 5'b0;
            MATCH <= 1'b0;
        end else begin
            
            state <= {state[3:0], IN};
            
            if (state == 5'b10011)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule
