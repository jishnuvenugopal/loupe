
module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    
    reg [1:0] state;

    
    initial begin
        state = 2'b00;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (j == 0) begin
                        state <= 2'b00;
                    end else if (j == 1) begin
                        state <= 2'b01;
                    end
                end
                2'b01: begin
                    if (k == 0) begin
                        state <= 2'b01;
                    end else if (k == 1) begin
                        state <= 2'b00;
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        out = state[1];
    end

endmodule
