
module TopModule (
    input wire [3:0] p1a,
    input wire [3:0] p1b,
    input wire [3:0] p1c,
    input wire [3:0] p1d,
    input wire [3:0] p2a,
    input wire [3:0] p2b,
    input wire [3:0] p2c,
    input wire [3:0] p2d,
    output reg [1:0] p1y,
    output reg [1:0] p2y
);

    
    function reg [1:0] nand2(input reg [1:0] a, input reg [1:0] b);
        return (a & ~b) | (~a & b);
    endfunction

    
    assign p1y = nand2(p1a, p1b);
    assign p2y = nand2(p2a, p2b);

endmodule
