
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    
    reg [3:0] delay;
    reg [11:0] counter;
 
    reg [3:0] remaining_time;
    reg [1:0] state, next_state;

    
    localparam IDLE = 2'b00,
               DETECT = 2'b01,
               SHIFT = 2'b10,
               COUNT = 2'b11;

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data == 4'b1101)
                    next_state = DETECT;
            end
            DETECT: begin
                next_state = SHIFT;
            end
            SHIFT: begin
                if (counter == 3)
                    next_state = COUNT;
            end
            COUNT: begin
                if (counter == 0)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            remaining_time <= 0;
        end else begin
            case (state)
                COUNT: begin
                    counter <= counter - 1;
                end
                IDLE, DETECT, SHIFT, DONE, WAIT_ACK: begin
                    counter <= 3 * delay * 1000;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            delay <= 0;
        end else begin
            case (state)
                DETECT: begin
                    delay <= (delay << 1) | data;
                end
            endcase
        end
    end

    
    always @(*) begin
        counting = (state == COUNT);
        done = (state == DONE);
        count = remaining_time;
    end

endmodule
