
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

    
    wire [29:0] concatenated_input;
    assign concatenated_input = {a, b, c, d, e, f};

    
    wire [7:0] w_output;
    wire [7:0] x_output;
    wire [7:0] y_output;
    wire [7:0] z_output;

    assign w_output = concatenated_input[29:22];
    assign x_output = concatenated_input[21:14];
    assign y_output = concatenated_input[13:6];
    assign z_output = concatenated_input[5:0];

    
    wire [31:0] final_output;
    assign final_output = {concatenated_input, 2'b11};

    
    assign w = w_output;
    assign x = x_output;
    assign y = y_output;
    assign z = z_output;

endmodule
