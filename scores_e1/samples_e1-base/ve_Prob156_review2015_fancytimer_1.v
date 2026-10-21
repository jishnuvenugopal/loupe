
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input reg ack
);

    
    typedef enum {SEARCHING, COUNTING, NOTIFYING} state_t;
    state_t state;

    
    reg [9:0] remaining_time;

    
    reg is_counting;

    
    reg [3:0] start_sequence;

    
    reg [3:0] delay;

    
    reg [9:0] cycles;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= SEARCHING;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
            start_sequence <= 4'b0000;
            delay <= 4'b0000;
            cycles <= 10'b000000000;
            remaining_time <= 10'b000000000;
            is_counting <= 1'b0;
        end else begin
            case (state)
                SEARCHING: begin
                    if (data == 4'b1101) begin
                        start_sequence <= data;
                        state <= COUNTING;
                        cycles <= 10'b000000000;
                        remaining_time <= 10'b000000000;
                        is_counting <= 1'b1;
                    end
                end
                COUNTING: begin
                    cycles <= cycles + 1;
                    if (cycles == remaining_time) begin
                        state <= NOTIFYING;
                        done <= 1'b1;
                        is_counting <= 1'b0;
                    end
                end
                NOTIFYING: begin
                    if (ack == 1'b1) begin
                        state <= SEARCHING;
                        cycles <= 10'b000000000;
                        remaining_time <= 10'b000000000;
                        is_counting <= 1'b0;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk) begin
        count <= remaining_time[3:0];
    end

endmodule
