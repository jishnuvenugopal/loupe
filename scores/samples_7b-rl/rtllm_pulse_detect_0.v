
module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

    reg [1:0] state;
    reg data_out_reg;

    localparam S0 = 2'd0,
               S1 = 2'd1,
               S2 = 2'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data_out_reg <= 0;
        end else begin
            case (state)
                S0: begin
                    data_out_reg <= 0;
                    if (data_in) begin
                        state <= S0;
                    end else begin
                        state <= S1;
                    end
                end
                S1: begin
                    data_out_reg <= 0;
                    if (data_in) begin
                        state <= S2;
                    end else begin
                        state <= S0;
                    end
                end
                S2: begin
                    if (data_in == 0) begin
                        data_out_reg <= 1;
                        state <= S0;
                    end else begin
                        data_out_reg <= 0;
                        state <= S0;
                    end
                end
                default: begin
                    state <= S0;
                    data_out_reg <= 0;
                end
            endcase
        end
    end

    assign data_out = data_out_reg;

endmodule
