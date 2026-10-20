
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    localparam IDLE = 2'b00;
    localparam COLLECT = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [1:0] counter;
    reg [23:0] message_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            message_reg <= 24'b0;
            counter <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        message_reg[23:16] <= in;
                        state <= COLLECT;
                        counter <= 1;
                    end
                end
                COLLECT: begin
                    if (counter == 1) begin
                        message_reg[15:8] <= in;
                        counter <= 2;
                    end else if (counter == 2) begin
                        message_reg[7:0] <= in;
                        state <= DONE;
                        counter <= 0;
                    end
                end
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign done = (state == DONE);
    assign out_bytes = message_reg;

endmodule
