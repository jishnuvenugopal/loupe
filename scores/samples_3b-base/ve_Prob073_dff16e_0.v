
module TopModule (
    input  clk,
    input  resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output [15:0] q
);

    
    reg [15:0] reg_file [0:15];

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            for (int i = 0;
 i < 16;
 i++) begin
                reg_file[i] <= 16'h0000;
            end
        end
    end

    
    always @(posedge clk) begin
        if (byteena[1]) begin
            reg_file[15:8] <= d[15:8];
        end
        if (byteena[0]) begin
            reg_file[7:0] <= d[7:0];
        end
    end

    
    assign q = reg_file;

endmodule
