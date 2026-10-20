
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);


localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE = 2'b11;

reg [1:0] current_state, next_state;
reg [3:0] shift_reg;
 
reg [3:0] delay_reg;
 
reg [3:0] remaining_time;
reg [9:0] cycle_counter;
 
reg [1:0] bit_counter;
 


always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end


always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = (shift_reg == 4'b1101) ? SHIFT : IDLE;
        end
        SHIFT: begin
            next_state = (bit_counter == 2'd3) ? COUNTING : SHIFT;
        end
        COUNTING: begin
            next_state = ((remaining_time == 4'd0) && (cycle_counter == 10'd999)) ? DONE : COUNTING;
        end
        DONE: begin
            next_state = ack ? IDLE : DONE;
        end
        default: next_state = IDLE;
    endcase
end


always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0;
    end else if (current_state == IDLE) begin
        shift_reg <= {shift_reg[2:0], data};
    end
end


always @(posedge clk) begin
    if (reset) begin
        delay_reg <= 4'b0;
    end else if (current_state == SHIFT) begin
        delay_reg <= {data, delay_reg[3:1]};
    end
end


always @(posedge clk) begin
    if (reset) begin
        bit_counter <= 2'b0;
    end else if (current_state == SHIFT) begin
        bit_counter <= (bit_counter == 2'd3) ? 2'b0 : bit_counter + 1;
    end else begin
        bit_counter <= 2'b0;
    end
end


always @(posedge clk) begin
    if (reset) begin
        remaining_time <= 4'b0;
        cycle_counter <= 10'b0;
    end else begin
        case (current_state)
            SHIFT: begin
                if (next_state == COUNTING) begin
                    remaining_time <= delay_reg;
                    cycle_counter <= 10'b0;
                end
            end
            COUNTING: begin
                if (cycle_counter == 10'd999) begin
                    cycle_counter <= 10'b0;
                    if (remaining_time != 4'd0) begin
                        remaining_time <= remaining_time - 1;
                    end
                end else begin
                    cycle_counter <= cycle_counter + 1;
                end
            end
            default: begin
                
            end
        endcase
    end
end


always @(*) begin
    case (current_state)
        IDLE: begin
            counting = 1'b0;
            done = 1'b0;
            count = 4'bx;
        end
        SHIFT: begin
            counting = 1'b0;
            done = 1'b0;
            count = 4'bx;
        end
        COUNTING: begin
            counting = 1'b1;
            done = 1'b0;
            count = remaining_time;
        end
        DONE: begin
            counting = 1'b0;
            done = 1'b1;
            count = 4'bx;
        end
        default: begin
            counting = 1'b0;
            done = 1'b0;
            count = 4'bx;
        end
    endcase
end

endmodule
