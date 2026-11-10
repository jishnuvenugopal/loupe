
module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    
    reg [1:0] state;

    
    initial state = 2'b00;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (w) begin
                        state <= 2'b01;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    state <= 2'b10;
                end
                2'b10: begin
                    if (w) begin
                        state <= 2'b11;
                    end else begin
                        state <= 2'b10;
                    end
                end
                2'b11: begin
                    state <= 2'b00;
                end
            endcase
            z <= state[0];
        end
    end

endmodule
