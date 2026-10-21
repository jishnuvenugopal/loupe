
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;
    reg next_state;

    
    reg out;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            next_state <= 2'b00;
            out <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    next_state <= 2'b01;
                    out <= 1'b0;
                end
                2'b01: begin
                    next_state <= 2'b10;
                    out <= 1'b0;
                end
                2'b10: begin
                    next_state <= 2'b00;
                    out <= 1'b0;
                end
                2'b11: begin
                    next_state <= 2'b10;
                    out <= 1'b1;
                end
            endcase
            state <= next_state;
        end
    end

    
    assign out = state[1];

endmodule
