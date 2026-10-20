
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    localparam IDLE = 2'b00,
               SEARCH = 2'b01,
               COLLECT = 2'b10,
               OUTPUT = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] byte_cnt;
    reg [23:0] message;

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    always @(*) begin
        next_state = state;
        byte_cnt = byte_cnt;
        out_bytes = out_bytes;
        done = done;
        case (state)
            IDLE:
                begin
                    if (!reset)
                        next_state = SEARCH;
                end
            SEARCH:
                begin
                    if (in[3] == 1)
                        next_state = COLLECT;
                end
            COLLECT:
                begin
                    byte_cnt <= byte_cnt + 1;
                    if (byte_cnt == 2)
                        next_state = OUTPUT;
                end
            OUTPUT:
                begin
                    byte_cnt <= 0;
                    next_state = SEARCH;
                    
                    out_bytes = message;
                    done = 1;
                end
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            message <= 24'b0;
        else
            case (state)
                COLLECT:
                    begin
                        if (byte_cnt == 0)
                            message[23:16] <= in;
                        else if (byte_cnt == 1)
                            message[15:8] <= in;
                        else if (byte_cnt == 2)
                            message[7:0] <= in;
                    end
                default:
                    message <= message;
            endcase
    end

endmodule
