
module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    
    wire decision;

    
    always @(*) begin
        
        if (vibrate_mode) begin
            decision = 1'b1;
        
        else begin
            decision = 1'b0;
        end
    end

    
    assign ringer = decision;
    assign motor = ~decision;

endmodule
