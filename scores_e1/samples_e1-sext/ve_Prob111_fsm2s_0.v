
module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    
    reg [1:0] state;
    reg output;

    
    initial begin
        state = 2'b00;
        out = 0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state = 2'b00;
            out = 0;
        end else begin
            case (state)
                2'b00: begin
                    if (j == 0) begin
                        state = 2'b00;
                        out = 0;
                    end else begin
                        state = 2'b01;
                        out = 1;
                    end
                end
                2'b01: begin
                    if (k == 0) begin
                        state = 2'b01;
                        out = 1;
                    end else begin
                        state = 2'b10;
                        out = 0;
                    end
                end
                2'b10: begin
                    state = 2'b10;
                    out = 0;
                end
            endcase
        end
    end

endmodule
