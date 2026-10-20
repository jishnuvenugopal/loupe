
module TopModule (
    input  d,        
    input  ena,       
    output q         
);

    
    always @(posedge ena or negedge d) begin
        if (ena) begin
            if (d) begin
                q <= 1'b1;
 
            end else begin
                q <= 1'b0;
 
            end
        end else begin
            q <= 1'b0;
 
        end
    end

endmodule
