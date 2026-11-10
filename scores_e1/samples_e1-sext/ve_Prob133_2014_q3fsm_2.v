
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    
    reg [1:0] state;
    reg [2:0] counter;

    
    initial begin
        state = 2'b00;
        counter = 3'b000;
        z = 0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state = 2'b00;
            counter = 3'b000;
            z = 0;
        end else begin
            case (state)
                2'b00: begin
                    if (s) begin
                        state = 2'b01;
                        counter = 3'b000;
                    end
                end
                2'b01: begin
                    if (w) begin
                        counter++;
                    end else begin
                        counter = 0;
                    end
                    if (counter == 2) begin
                        z = 1;
                        state = 2'b00;
                    end
                end
                default: begin
                    state = 2'b00;
                    counter = 3'b000;
                    z = 0;
                end
            endcase
        end
    end

endmodule
