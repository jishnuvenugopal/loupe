
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);

    
    reg [3:0] reg;

    
    always @(posedge clk) begin
        if (!resetn) begin
            reg <= 4'b0000;
        end else begin
            reg[3] <= reg[2];
            reg[2] <= reg[1];
            reg[1] <= reg[0];
            reg[0] <= in;
        end
    end

    
    assign out = reg[3];

endmodule
