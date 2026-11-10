
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (in == 1'b0) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin
                state <= 2'b10;
            end
            2'b10: begin
                state <= 2'b00;
            end
            2'b11: begin
                state <= 2'b10;
            end
        endcase
    end

    
    always @(posedge areset) begin
        state <= 2'b00;
    end

    
    assign out = state[0];

endmodule
