
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    
    reg [2:0] state;

    
    reg z_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z_reg <= 1'b0;
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
                    state <= 3'b100;
 
                3'b101: 
                    if (w == 1'b0)
                        state <= 3'b010;
 
                    else
                        state <= 3'b011;
 
                default: 
                    state <= 3'b000;
            endcase
            
            if (state == 3'b100)
                z_reg <= 1'b1;
            else
                z_reg <= 1'b0;
        end
    end

    assign z = z_reg;

endmodule
