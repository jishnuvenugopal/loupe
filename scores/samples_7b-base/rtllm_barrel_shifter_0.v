
module barrel_shifter (
    input [7:0] in,        
    input [2:0] ctrl,      
    output reg [7:0] out   
);

    
    reg [7:0] shifted_4;
    reg [7:0] shifted_2;
    reg [7:0] shifted_1;

    
    assign shifted_4 = {4'b0000, in[3:0]};

    
    assign shifted_2 = {2'b00, shifted_4[5:0]};

    
    assign shifted_1 = {shifted_2[6:0], 1'b0};

    
    always @(*) begin
        if (ctrl == 3'b100) out = shifted_4;
  
        else if (ctrl == 3'b010) out = shifted_2;
  
        else if (ctrl == 3'b001) out = shifted_1;
  
        else out = in;
  
    end

endmodule
