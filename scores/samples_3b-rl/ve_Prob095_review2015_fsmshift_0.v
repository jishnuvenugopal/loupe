
module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    
    reg [3:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            
            counter <= 4'd0;
            shift_ena <= 1'b1;
        end else begin
            if (shift_ena) begin
                
                if (counter == 4'd3) begin
                    
                    shift_ena <= 1'b0;
                    counter <= 4'd0;
                end else begin
                    
                    counter <= counter + 1'b1;
                end
            end else begin
                
            end
        end
    end

endmodule
