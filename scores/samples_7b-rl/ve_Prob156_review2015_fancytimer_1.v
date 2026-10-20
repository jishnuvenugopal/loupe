
module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);


localparam IDLE = 2'b00;
localparam CAPTURE = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE_ACK = 2'b11;


reg [1:0] state;
reg [3:0] shift_reg;
 
reg [3:0] delay_captured;
 
reg [3:0] delay_reg;
 
reg [9:0] cycle_counter;
 
reg [1:0] capture_count;
 


always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'b0000;
        delay_captured <= 4'b0;
        delay_reg <= 4'b0;
        cycle_counter <= 0;
        capture_count <= 0;
        counting <= 0;
        done <= 0;
        count <= 4'b0;
    end
    else begin
        case(state)
            IDLE: begin
                
                shift_reg <= {shift_reg[2:0], data};
                if(shift_reg == 4'b1101) begin
                    state <= CAPTURE;
                    capture_count <= 0;
                end
                count <= 4'bxxxx;
 
                done <= 0;
            end
            
            CAPTURE: begin
                
                if(capture_count < 4) begin
                    delay_captured[3 - capture_count] <= data;
                    capture_count <= capture_count + 1;
                end
                else begin
                    
                    delay_reg <= delay_captured;
                    remaining_time <= delay_captured;
                    cycle_counter <= 0;
                    state <= COUNTING;
                    counting <= 1;
                    done <= 0;
                end
            end
            
            COUNTING: begin
                if(cycle_counter == 999) begin
                    cycle_counter <= 0;
                    if(remaining_time > 0) begin
                        remaining_time <= remaining_time - 1;
                    end
                    else begin
                        
                        state <= DONE_ACK;
                        done <= 1;
                        counting <= 0;
                        count <= 0;
                    end
                end
                else begin
                    cycle_counter <= cycle_counter + 1;
                end
                count <= remaining_time;
            end
            
            DONE_ACK: begin
                if(ack) begin
                    state <= IDLE;
                    done <= 0;
                    count <= 4'b0;
                end
                else begin
                    done <= 1;
                end
            end
        endcase
    end
end

endmodule
