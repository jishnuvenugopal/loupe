
module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    reg [1:0] state;
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data_out <= 0;
        end
        else begin
            case (state)
                S0: begin
                    data_out <= 0;
                    if (data_in == 0)
                        state <= S1;
                    else
                        state <= S0;
                end
                S1: begin
                    data_out <= 0;
                    if (data_in == 1)
                        state <= S2;
                    else
                        state <= S1;
                end
                S2: begin
                    if (data_in == 0) begin
                        data_out <= 1;
                        state <= S1;
                    end
                    else begin
                        data_out <= 0;
                        state <= S0;
                    end
                end
                default: begin
                    state <= S0;
                    data_out <= 0;
                end
            endcase
        end
    end

endmodule
