
module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    
    reg [2:0] state;

    
    always @(*) begin
        if (state == 3'b111)
            z = 1;
        else
            z = 0;
    end

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
 
        end else begin
            case (state)
                3'b000: 
                    if (w == 1'b0)
                        state <= 3'b001;
 
                    else
                        state <= 3'b000;
 
                3'b001: 
                    if (w == 1'b0)
                        state <= 3'b010;
 
                    else
                        state <= 3'b001;
 
                3'b010: 
                    if (w == 1'b0)
                        state <= 3'b011;
 
                    else
                        state <= 3'b010;
 
                3'b011: 
                    if (w == 1'b0)
                        state <= 3'b100;
 
                    else
                        state <= 3'b011;
 
                3'b100: 
                    if (w == 1'b0)
                        state <= 3'b100;
 
                    else
                        state <= 3'b011;
 
                3'b101: 
                    if (w == 1'b0)
                        state <= 3'b010;
 
                    else
                        state <= 3'b011;
 
                default: 
                    state <= 3'b000;
 
            endcase
        end
    end

endmodule
