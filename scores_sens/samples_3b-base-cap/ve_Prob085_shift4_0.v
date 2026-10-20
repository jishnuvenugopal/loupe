
module TopModule (
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

    
    reg [3:0] shift_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 4'b0000;
 
        end else if (ena) begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};
 
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 4'b0000;
 
        end else if (load) begin
            shift_reg <= data;
 
        end
    end

    
    assign q = shift_reg;

endmodule
