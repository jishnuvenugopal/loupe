
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [7:0] byte1, byte2, byte3;
    reg [1:0] state;

    
    localparam [1:0]
        S_IDLE           = 2'b00,
        S_WAIT_SECOND    = 2'b01,
        S_WAIT_THIRD     = 2'b10,
        S_DONE           = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            byte1 <= 8'h00;
            byte2 <= 8'h00;
            byte3 <= 8'h00;
            done <= 0;
            out_bytes <= 24'h000000;
        end
        else begin
            done <= 0;
 
            case (state)
                S_IDLE: begin
                    if (in[3] == 1'b1) begin
                        byte1 <= in;
                        state <= S_WAIT_SECOND;
                    end
                end

                S_WAIT_SECOND: begin
                    byte2 <= in;
                    state <= S_WAIT_THIRD;
                end

                S_WAIT_THIRD: begin
                    byte3 <= in;
                    state <= S_DONE;
                end

                S_DONE: begin
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1'b1;
                    state <= S_IDLE;
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end
endmodule
