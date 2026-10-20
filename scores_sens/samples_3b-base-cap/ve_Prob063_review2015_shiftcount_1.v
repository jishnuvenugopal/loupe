
module TopModule (
    input  clk,
    input  shift_ena,
    input  count_ena,
    input  data,
    output reg [3:0] q
);

    
    reg [3:0] shift_reg;

    
    reg shift_or_count;

    
    always @(posedge clk) begin
        if (shift_ena) begin
            shift_or_count <= 1'b1;
        end else if (count_ena) begin
            shift_or_count <= 1'b0;
        end else begin
            shift_or_count <= shift_or_count;
 
        end
    end

    
    always @(posedge clk) begin
        if (shift_or_count) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    
    always @(posedge clk) begin
        if (!shift_or_count) begin
            if (shift_reg != 4'b0000) begin
                shift_reg <= shift_reg - 1'b1;
            end
        end
    end

    
    assign q = shift_reg;

endmodule
