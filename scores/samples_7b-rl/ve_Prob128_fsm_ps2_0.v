
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] state;
    reg [7:0] msg [2:0];
    reg done_reg;
    
    localparam IDLE = 2'b00;
    localparam COLLECT = 2'b01;
    localparam WAIT_2 = 2'b10;
    localparam DONE = 2'b11;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
            msg[0] <= 0;
            msg[1] <= 0;
            msg[2] <= 0;
        end else begin
            done_reg <= 0;
            case(state)
                IDLE: begin
                    if (in[3]) begin
                        msg[0] <= in;
                        state <= COLLECT;
                    end
                end
                COLLECT: begin
                    msg[1] <= in;
                    state <= WAIT_2;
                end
                WAIT_2: begin
                    msg[2] <= in;
                    state <= DONE;
                end
                DONE: begin
                    done_reg <= 1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
    
    assign done = done_reg;
    
endmodule
