
module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    
    reg [3:0] shift_reg;

    
    reg [3:0] counter;

    
    always @(*) begin
        shift_reg = 4'b0000;
    end

    
    always @(*) begin
        counter = 4'b0000;
    end

    
    always @(posedge clk) begin
        if (shift_ena) begin
            shift_reg = {shift_reg[2:0], data};
        end
    end

    
    always @(posedge clk) begin
        if (count_ena) begin
            counter = counter - 1;
        end
    end

    
    assign q = shift_reg;

endmodule
