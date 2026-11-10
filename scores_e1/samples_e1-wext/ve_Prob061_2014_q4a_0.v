
module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

    
    localparam WIDTH = 8;
 

    
    reg [WIDTH-1:0] reg1;
    reg [WIDTH-1:0] reg2;

    
    always @(posedge clk) begin
        if (E) begin
            
            reg1 <= reg2;
            reg2 <= w;
        end else if (R) begin
            
            reg1 <= w;
        end else if (L) begin
            
            reg1 <= w;
        end
    end

    
    assign Q = reg1;

endmodule
