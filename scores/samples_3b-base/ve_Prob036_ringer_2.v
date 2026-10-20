
module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output reg ringer,
    output reg motor
);

    
    

    
    
    
    

    always @(posedge ring or posedge vibrate_mode) begin
        if (ring) begin
            if (vibrate_mode) begin
                motor <= 1;
 
                ringer <= 0;
 
            end else begin
                motor <= 0;
 
                ringer <= 1;
 
            end
        end else begin
            motor <= 0;
 
            ringer <= 0;
 
        end
    end

endmodule
