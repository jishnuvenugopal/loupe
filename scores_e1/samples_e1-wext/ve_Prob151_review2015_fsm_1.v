
module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    
    typedef enum {idle, searching, shifting, counting, done} state_t;
    state_t current_state = idle;

    
    reg [3:0] count;

    
    reg [3:0] shift_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= idle;
            count <= 0;
            shift_reg <= 0;
        end else begin
            case (current_state)
                idle: begin
                    if (data == 4'b1101) begin
                        current_state <= searching;
                        count <= 0;
                        shift_reg <= 0;
                    end
                end
                searching: begin
                    count <= count + 1;
                    if (count == 4) begin
                        current_state <= shifting;
                        shift_reg <= data;
                    end
                end
                shifting: begin
                    shift_reg <= shift_reg << 1;
                    shift_reg[0] <= data;
                    if (count == 4) begin
                        current_state <= counting;
                    end
                end
                counting: begin
                    if (done_counting) begin
                        current_state <= done;
                    end
                end
                done: begin
                    if (ack) begin
                        current_state <= idle;
                    end
                end
            endcase
        end
    end

    
    assign shift_ena = current_state == shifting;
    assign counting = current_state == counting;
    assign done = current_state == done;

endmodule
