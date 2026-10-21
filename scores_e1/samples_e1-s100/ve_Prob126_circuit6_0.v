
module TopModule (
    input  [2:0] a,  
    output [15:0] q   
);

    
    reg [15:0] shift_reg;

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            shift_reg <= 16'b0;
        end else begin
            shift_reg <= {shift_reg[14:0], a};
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            q <= 16'b0;
        end else begin
            q <= shift_reg;
        end
    end

endmodule
