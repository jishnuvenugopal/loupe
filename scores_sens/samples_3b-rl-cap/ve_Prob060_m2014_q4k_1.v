
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);

    
    reg [3:0] reg_data;

    
    always @(posedge clk) begin
        if (!resetn) begin
            reg_data <= 4'b0;
        end else begin
            
            reg_data[0] <= in;
            
            out <= reg_data[3];
            
            reg_data[1] <= reg_data[0];
            reg_data[2] <= reg_data[1];
            reg_data[3] <= reg_data[2];
        end
    end

endmodule
