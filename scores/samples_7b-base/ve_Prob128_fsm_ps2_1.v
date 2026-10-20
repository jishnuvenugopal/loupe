
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    parameter IDLE = 2'b00;
    parameter FIRST_BYTE = 2'b01;
    parameter SECOND_BYTE = 2'b10;
    parameter THIRD_BYTE = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1'b1) begin
                        state <= FIRST_BYTE;
                        done <= 1'b0;
                    end else begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
                FIRST_BYTE: begin
                    state <= SECOND_BYTE;
                    done <= 1'b0;
                end
                SECOND_BYTE: begin
                    state <= THIRD_BYTE;
                    done <= 1'b0;
                end
                THIRD_BYTE: begin
                    state <= IDLE;
                    done <= 1'b1;
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule
