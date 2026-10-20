
module TopModule(  
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    reg [513:0] shift_reg;

    
    always @(posedge clk) begin
        if (load) begin
            q <= 512'b0;
  
            shift_reg[1:512] <= data;
  
        end
    end

    
    always @(posedge clk) begin
        q <= shift_reg[2:513] ^ {shift_reg[0], shift_reg[513 obliv unsure what `obliv unsure what is error
    end
endmodule
