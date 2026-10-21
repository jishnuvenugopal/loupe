
module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

    
    reg [3:0] shift_reg;
    reg load_reg;
    reg ena_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 4'b0000;
            load_reg <= 1'b0;
            ena_reg <= 1'b0;
        end else begin
            load_reg <= load;
            ena_reg <= ena;
            shift_reg <= {load_reg[3], shift_reg[2:0]};
        end
    end

    
    always @(posedge clk) begin
        if (load_reg) begin
            shift_reg <= data;
        end
    end

    
    always @(posedge clk) begin
        if (ena_reg) begin
            shift_reg <= {shift_reg[3], shift_reg[2:0]};
        end
    end

    
    assign q = shift_reg;

endmodule
