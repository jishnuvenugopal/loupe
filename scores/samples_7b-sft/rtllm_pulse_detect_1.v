
module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    
    localparam IDLE = 2'b00;
    localparam S1   = 2'b01;
    localparam S2   = 2'b10;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1'b0) begin
                        state <= S1;
                        data_out <= 1'b0;
                    end else begin
                        state <= IDLE;
                        data_out <= 1'b0;
                    end
                end
                S1: begin
                    if (data_in == 1'b1) begin
                        state <= S2;
                        data_out <= 1'b0;
                    end else begin
                        state <= IDLE;
                        data_out <= 1'b0;
                    end
                end
                S2: begin
                    if (data_in == 1'b0) begin
                        state <= IDLE;
                        data_out <= 1'b1;
                    end else begin
                        state <= IDLE;
                        data_out <= 1'b0;
                    end
                end
                default: begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule
