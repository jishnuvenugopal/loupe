
module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;

    reg [2:0] state;
    reg [7:0] received_byte;
    reg data_bit;
    reg stop_bit;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            received_byte <= 8'b0;
            data_bit <= 1'b0;
            stop_bit <= 1'b0;
            bit_count <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= START;
                        bit_count <= 3'b0;
                        received_byte <= 8'b0;
                    end
                end
                START: begin
                    if (in == 1'b0) begin
                        state <= DATA;
                        bit_count <= 3'b0;
                        received_byte <= 8'b0;
                    end else begin
                        state <= IDLE;
                    end
                end
                DATA: begin
                    if (bit_count < 3'b100) begin
                        received_byte[bit_count] <= in;
                        bit_count <= bit_count + 1'b1;
                    end else begin
                        if (in == 1'b1) begin
                            state <= STOP;
                            stop_bit <= 1'b1;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                        done <= 1'b1;
                        out_byte <= received_byte;
                    end else begin
                        state <= STOP;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
