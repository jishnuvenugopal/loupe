
module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg        done
);

    
    parameter IDLE = 2'b00,
              RECEIVING = 2'b01,
              DONE = 2'b10;

    reg [1:0] state;
    reg [7:0] bytes [0:2];

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bytes <= 3'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= RECEIVING;
                    else
                        state <= IDLE;
                end
                RECEIVING: begin
                    if (in[3])
                        bytes[0] <= in;
                    else
                        state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bytes <= 3'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= RECEIVING;
                    else
                        state <= IDLE;
                end
                RECEIVING: begin
                    if (in[3])
                        bytes[1] <= in;
                    else
                        state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bytes <= 3'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= RECEIVING;
                    else
                        state <= IDLE;
                end
                RECEIVING: begin
                    if (in[3])
                        bytes[2] <= in;
                    else
                        state <= IDLE;
                end
                DONE: begin
                    out_bytes <= {bytes[2], bytes[1], bytes[0]};
                    done <= 1'b1;
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
