
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [7:0] in,
    output reg [23:0] out_bytes,
    output reg        done
);

    
    typedef enum {IDLE, BYTE1, BYTE2, BYTE3} state_t;
    reg state;

    
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;

    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            byte1   <= 8'b0;
            byte2   <= 8'b0;
            byte3   <= 8'b0;
            out_bytes <= 24'b0;
            done     <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        state <= BYTE1;
                    end else begin
                        state <= IDLE;
                    end
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
                    state <= IDLE;
                    out_bytes <= {byte3, byte2, byte1};
                    done      <= 1'b1;
                end
                default: begin
                    state <= IDLE;
                    byte1 <= 8'b0;
                    byte2 <= 8'b0;
                    byte3 <= 8'b0;
                    out_bytes <= 24'b0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule
