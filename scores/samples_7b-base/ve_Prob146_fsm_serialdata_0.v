
module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg data_valid;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            data_valid <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= START;
                        bit_count <= 3'b0;
                    end
                end
                START: begin
                    shift_reg[0] <= in;
                    if (bit_count == 3'b000) begin
                        state <= DATA;
                    end else begin
                        state <= START;
                        shift_reg <= {shift_reg[7:1], 1'b0};
                        bit_count <= bit_count + 1;
                    end
                end
                DATA: begin
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                    end else begin
                        shift_reg <= {shift_reg[7:1], in};
                        bit_count <= bit_count + 1;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        state <= DATA;
                        shift_reg <= {shift_reg[7:1], 1'b0};
                        data_valid <= 1'b1;
                    end else begin
                        state <= STOP;
                    end
                end
            endcase
        end
    end

    assign out_byte = data_valid ? shift_reg : 8'b0;
    assign done = data_valid;

endmodule
