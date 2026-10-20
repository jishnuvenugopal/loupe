
module TopModule (
    input  d,        
    input  ena,       
    output q         
);

    
    always @(posedge ena) begin
        if (ena) begin
            q <= d;
    
        end else begin
            q <= q;
    
        end
    end

endmodule
