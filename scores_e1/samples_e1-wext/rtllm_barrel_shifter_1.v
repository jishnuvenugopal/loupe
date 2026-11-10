
module barrel_shifter (
    input wire [7:0] in,  
    input wire [2:0] ctrl, 
    output reg [7:0] out   
);


module mux2X1 (
    input wire [1:0] sel, 
    input wire [7:0] in,  
    output reg [7:0] out   
);

    always @(*) begin
        if (sel == 2'b00) out = in;
 
        else out = in;
 
    end

endmodule


always @(*) begin
    reg [7:0] shifted_in = in;
 

    
    if (ctrl[2] == 1'b1) shifted_in = shifted_in >> 4;
 
    if (ctrl[1] == 1'b1) shifted_in = shifted_in >> 2;
 
    if (ctrl[0] == 1'b1) shifted_in = shifted_in >> 1;
 

    
    if (ctrl[2] == 1'b1) shifted_in = {8'b0, shifted_in};
 
    if (ctrl[1] == 1'b1) shifted_in = {6'b0, shifted_in};
 
    if (ctrl[0] == 1'b1) shifted_in = {4'b0, shifted_in};
 

    out = shifted_in;
 
end

endmodule
