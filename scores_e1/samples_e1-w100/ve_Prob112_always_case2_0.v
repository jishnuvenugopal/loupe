
module TopModule (
    input  wire [3:0] in,
    output wire [1:0] pos
);

    
    reg [1:0] state;
    reg [1:0] output;

    always @(posedge in or pos) begin
        
        if (in == 0) begin
            state <= 0;
            output <= 0;
        end
        
        else begin
            state <= state + 1;
            output <= state;
        end
    end

    
    assign pos = output;

endmodule
