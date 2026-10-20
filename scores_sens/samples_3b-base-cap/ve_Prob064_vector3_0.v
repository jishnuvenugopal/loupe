
module TopModule (
    input  [4:0] a,  
    input  [4:0] b,  
    input  [4:0] c,  
    input  [4:0] d,  
    input  [4:0] e,  
    input  [4:0] f,  
    output [7:0] w,  
    output [7:0] x,  
    output [7:0] y,  
    output [7:0] z   
);

    
    wire [29:0] concatenated;

    
    assign concatenated = {a, b, c, d, e, f};

    
    assign w = concatenated[29:22];
    assign x = concatenated[21:14];
    assign y = concatenated[13:6];
    assign z = concatenated[5:0];

    
    wire [31:0] final_output;
    assign final_output = {concatenated, 2'b11};

    
    assign w = final_output[29:22];
    assign x = final_output[21:14];
    assign y = final_output[13:6];
    assign z = final_output[5:0];

endmodule
