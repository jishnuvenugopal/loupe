
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    
    reg [5:0] state;

    
    reg z_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 6'b0;
        end else begin
            case (state)
                6'b000000: begin 
                    if (w == 1'b0) state <= 6'b000001;
 
                    else          state <= 6'b000000;
 
                end
                6'b000001: begin 
                    if (w == 1'b0) state <= 6'b000010;
 
                    else          state <= 6'b000001;
 
                end
                6'b000010: begin 
                    if (w == 1'b0) state <= 6'b000011;
 
                    else          state <= 6'b000010;
 
                end
                6'b000011: begin 
                    if (w == 1'b0) state <= 6'b000100;
 
                    else          state <= 6'b000011;
 
                end
                6'b000100: begin 
                    if (w == 1'b0) state <= 6'b000101;
 
                    else          state <= 6'b000011;
 
                end
                6'b000101: begin 
                    if (w == 1'b0) state <= 6'b000110;
 
                    else          state <= 6'b000011;
 
                end
                default: state <= 6'b000000;
 
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (state == 6'b000101) z_reg <= 1'b1;
 
        else                  z_reg <= 1'b0;
    end

    assign z = z_reg;

endmodule
