
module TopModule (
    input  in,      
    output pos     
);

    
    always @(*) begin
        
        pos = 2'b00;

        
        if (in[3]) pos = 2'b01;
        else if (in[2]) pos = 2'b10;
        else if (in[1]) pos = 2'b11;
        else if (in[0]) pos = 2'b00;
    end

endmodule
