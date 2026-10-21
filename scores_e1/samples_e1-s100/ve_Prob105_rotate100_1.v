
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    
    reg [99:0] current_data;
    reg [99:0] next_data;

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            current_data <= data;
        end
    end

    
    always @(posedge clk) begin
        if (ena[1]) begin
            
            next_data <= {current_data[99], current_data[98:0]};
        end else if (ena[0]) begin
            
            next_data <= {current_data[1:0], current_data[98:1]};
        end else begin
            
            next_data <= current_data;
        end
    end

    
    assign q = next_data;

endmodule
