
module TopModule (
    input  [1023:0] in,  
    input  [7:0]   sel,  
    output [3:0]  out   
);

    
    reg [1023:0] input_vector;

    
    reg [3:0] output_vector;

    
    assign input_vector = in;

    
    for (genvar i = 0;
 i < 256;
 i = i + 1) begin
        
        int index = i * 4;

        
        if (sel == i) begin
            output_vector = input_vector[index:index+4];
        end
    end

    
    assign out = output_vector;

endmodule
