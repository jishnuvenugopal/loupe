
module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    
    parameter IDLE = 2'b00;
    parameter COLLECT_DATA = 2'b01;
    parameter CHECK_STOP = 2'b10;
    parameter WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] counter;
    reg [7:0] shift_reg;

    
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? COLLECT_DATA : IDLE;
            end
            COLLECT_DATA: begin
                next_state = (counter == 3'd7) ? CHECK_STOP : COLLECT_DATA;
            end
            CHECK_STOP: begin
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            end
            WAIT_STOP: begin
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 0;
            shift_reg <= 0;
            done <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        counter <= 0;
                        shift_reg <= 0;
                    end
                    done <= 0;
                end
                COLLECT_DATA: begin
                    shift_reg <= {shift_reg[6:0], in};
                    counter <= counter + 1;
                    done <= 0;
                end
                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        done <= 1;
                        out_byte <= shift_reg;
                    end else begin
                        done <= 0;
                    end
                end
                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        done <= 1;
                        out_byte <= shift_reg;
                    end else begin
                        done <= 0;
                    end
                end
                default: begin
                    done <= 0;
                end
            endcase
        end
    end

endmodule
