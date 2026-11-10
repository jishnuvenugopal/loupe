
module TopModule (
    input  wire [31:0] in,  
    output wire [31:0] out   
);

    
    assign out = ((in >> 24) & 0xFF) | ((in >> 8) & 0xFF00) | ((in << 8) & 0xFF0000) | ((in << 24) & 0xFF000000);

endmodule
