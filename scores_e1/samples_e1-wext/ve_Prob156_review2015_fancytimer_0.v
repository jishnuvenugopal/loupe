
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input reg ack
);

    
    typedef enum {IDLE, COUNTING, DONE} state_t;
    state_t state = IDLE;

    
    reg [3:0] delay;
    reg [999:0] count_cycles;
    reg [999:0] delay_cycles;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
            delay <= 4'b0000;
            count_cycles <= 1000'd0;
            delay_cycles <= 1000'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        state <= COUNTING;
                        count_cycles <= 1000'd0;
                        delay_cycles <= delay;
                    end
                end
                COUNTING: begin
                    count_cycles <= count_cycles + 1000'd1;
                    if (count_cycles == delay_cycles) begin
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
                DONE: begin
                    if (ack == 1'b1) begin
                        state <= IDLE;
                        count_cycles <= 1000'd0;
                        delay_cycles <= 1000'd0;
                    end
                end
            endcase
        end
    end

    
    assign count = count;
    assign counting = counting;
    assign done = done;

endmodule
