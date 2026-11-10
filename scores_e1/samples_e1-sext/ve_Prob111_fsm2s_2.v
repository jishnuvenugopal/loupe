
module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg [1:0] state;
    reg [1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            counter <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (j == 0 && k == 0) begin
                        state <= 2'b00;
                    end else if (j == 0 && k == 1) begin
                        state <= 2'b01;
                    end else if (j == 1 && k == 0) begin
                        state <= 2'b01;
                    end else if (j == 1 && k == 1) begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    state <= 2'b01;
                end
            endcase

            counter <= state;
        end
    end

    assign out = counter[1];

endmodule
