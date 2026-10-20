
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    
    reg [3:0] state;
    
    reg [3:0] pattern = 4'b1101;
    
    reg [3:0] count;

    
    always @(*) begin
        if (data == pattern)
            shift_ena = 1'b1;
        else
            shift_ena = 1'b0;
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0000;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            case (state)
                4'b0000: begin 
                    if (shift_ena)
                        state <= 4'b0001;
                    else
                        state <= 4'b0000;
                end
                4'b0001: begin 
                    if (data == pattern)
                        state <= 4'b0010;
                    else
                        state <= 4'b0000;
                    shift_ena <= 1'b0;
                end
                4'b0010: begin 
                    if (count == 4'd15)
                        state <= 4'b0100;
                    else
                        state <= 4'b0011;
                    count <= count + 4'd1;
                end
                4'b0011: begin 
                    if (count == 4'd15)
                        state <= 4'b0100;
                    else
                        state <= 4'b0011;
                    count <= count + 4'd1;
                end
                4'b0100: begin 
                    if (done_counting)
                        state <= 4'b0110;
                    else
                        state <= 4'b0100;
                end
                4'b0110: begin 
                    if (ack)
                        state <= 4'b0000;
                    else
                        state <= 4'b0110;
                end
                default: state <= 4'b0000;
            endcase
            case (state)
                4'b0001: counting <= 1'b1;
                4'b0010: counting <= 1'b1;
                4'b0011: counting <= 1'b1;
                4'b0100: counting <= 1'b1;
                4'b0110: counting <= 1'b1;
                default: counting <= 1'b0;
            endcase
            case (state)
                4'b0001: done <= 1'b0;
                4'b0010: done <= 1'b0;
                4'b0011: done <= 1'b0;
                4'b0100: done <= 1'b0;
                4'b0110: done <= 1'b1;
                default: done <= 1'b0;
            endcase
        end
    end

endmodule
