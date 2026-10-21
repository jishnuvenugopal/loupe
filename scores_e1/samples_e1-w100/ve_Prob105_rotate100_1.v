
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

    
    reg [99:0] reg_data;

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            reg_data <= data;
        end
    end

    
    always @(posedge clk or posedge ena) begin
        if (ena[1]) begin
            
            q <= {reg_data[99], reg_data[98:0]};
        end else if (ena[0]) begin
            
            q <= {reg_data[0], reg_data[1:99]};
        end else begin
            
            q <= reg_data;
        end
    end

endmodule
