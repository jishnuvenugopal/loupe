
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    
    reg [1:0] counter;

    
    reg [99:0] shift_reg;

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_reg <= data;
            counter <= 2'b00;
 
        end else begin
            if (ena == 2'b01) begin
                
                shift_reg <= {shift_reg[99], shift_reg[98:0]};
                counter <= counter + 1'b1;
 
            end else if (ena == 2'b10) begin
                
                shift_reg <= {shift_reg[1:99], shift_reg[99]};
                counter <= counter - 1'b1;
 
            end else if (ena == 2'b00) begin
                
                shift_reg <= shift_reg;
            end else if (ena == 2'b11) begin
                
                shift_reg <= shift_reg;
            end
        end
    end

    
    assign q = shift_reg;

endmodule
