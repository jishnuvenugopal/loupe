
module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    
    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            
            counter <= 2'b00;
            shift_ena <= 1'b1;
        end else begin
            if (counter < 2'd4) begin
                
                shift_ena <= 1'b1;
                counter <= counter + 2'd1;
            end else begin
                
                shift_ena <= 1'b0;
                counter <= 2'd0;
            end
        end
    end

endmodule
