
module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

    localparam IDLE = 2'b00,
               START_BIT = 2'b01,
               DATA_BITS = 2'b10,
               STOP_BIT = 2'b11;

    reg [1:0] state;
    reg [7:0] data;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'b0;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= START_BIT;
                    end
                    done <= 1'b0;
                end
                START_BIT: begin
                    bit_count <= bit_count + 1;
                    if (bit_count == 2'b000) begin
                        state <= DATA_BITS;
                        bit_count <= 3'b111;
                    end
                end
                DATA_BITS: begin
                    data <= {in, data[7:1]};
                    bit_count <= bit_count - 1;
                    if (bit_count == 3'b000) begin
                        state <= STOP_BIT;
                    end
                end
                STOP_BIT: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                        done <= 1'b1;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
