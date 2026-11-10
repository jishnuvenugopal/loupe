
module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    
    reg [1:0] state;
    reg [1:0] next_state;

    
    initial begin
        state = 2'b00;
        z = 1'b0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (w == 1'b0) begin
                        next_state <= 2'b01;
                    end else begin
                        next_state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (w == 1'b0) begin
                        next_state <= 2'b00;
                    end else begin
                        next_state <= 2'b10;
                    end
                end
                2'b10: begin
                    if (w == 1'b0) begin
                        next_state <= 2'b00;
                    end else begin
                        next_state <= 2'b11;
                    end
                end
                2'b11: begin
                    if (w == 1'b0) begin
                        next_state <= 2'b00;
                    end else begin
                        next_state <= 2'b01;
                    end
                end
            endcase
            z <= state[0];
        end
    end

endmodule
