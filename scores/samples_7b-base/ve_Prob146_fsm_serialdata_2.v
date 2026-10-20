
module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);
    reg [2:0] state;
    reg [7:0] data_reg;
    reg done_reg;

    parameter IDLE = 3'b000,
                START_BIT = 3'b001,
                DATA_BITS = 3'b010,
                STOP_BIT = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 8'b0;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 0) begin
                        state <= START_BIT;
                        done_reg <= 0;
                    end
                end
                START_BIT: begin
                    state <= DATA_BITS;
                end
                DATA_BITS: begin
                    data_reg <= {data_reg[6:0], in};
                    if (data_reg == 8'b0) begin
                        state <= STOP_BIT;
                    end
                end
                STOP_BIT: begin
                    if (in == 1) begin
                        state <= IDLE;
                        done_reg <= 1;
                        out_byte <= data_reg;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign out_byte = done_reg ? data_reg : 8'b0;
    assign done = done_reg;
endmodule
