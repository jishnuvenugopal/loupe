
module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    
    parameter IDLE = 4'd0;
    parameter BYTE1 = 4'd1;
    parameter BYTE2 = 4'd2;
    parameter BYTE3 = 4'd3;

    reg [3:0] state;
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            byte1   <= 8'd0;
            byte2   <= 8'd0;
            byte3   <= 8'd0;
            done    <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= BYTE1;
                    else
                        state <= IDLE;
                end
                BYTE1: begin
                    byte1 <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    byte2 <= in;
                    state <= BYTE3;
                end
                BYTE3: begin
                    byte3 <= in;
                    done  <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
